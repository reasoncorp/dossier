module Dossier
  class Result
    include Enumerable

    attr_reader :report

    def initialize(adapter_results, report)
      unless adapter_results.respond_to?(:each)
        raise ArgumentError.new("#{adapter_results.inspect} does not respond to :each") 
      end
      @adapter_results = adapter_results
      @report          = report
    end

    def headers
      @adapter_results.fields.map { |header| Dossier::Formatter.titleize(header) }
    end

    def body
      rows.first(rows.length - report.options[:footer].to_i)
    end

    def footers
      rows.last(report.options[:footer].to_i)
    end

    def rows
      @rows ||= map(&:values)
    end

    def arrays
      @arrays ||= [headers] + rows
    end

    def hashes
      @hashes ||= to_a
    end

    def each
      raise NotImplementedError, "Every result class must define `each`"
    end

    class Formatted < Result
      def each
        @adapter_results.each do |row|
          yield format(row)
        end
      end

      def format(result_row)
        raise ArgumentError.new("#{result_row.inspect} must respond to :[]") unless result_row.respond_to?(:[])

        result_row.inject({}) do |new_row, (key, value)|
          new_row.tap do |row|
            method       = "format_#{key}"
            value        = report.public_send(method, value) if report.respond_to?(method)
            new_row[key] = value
          end
        end
      end
    end

    class Unformatted < Result
      delegate :each, to: :@adapter_results
    end

  end
end
