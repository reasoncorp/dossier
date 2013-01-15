module Dossier
  class Result
    include Enumerable

    attr_accessor :report, :adapter_results

    def initialize(adapter_results, report)
      self.adapter_results = adapter_results
      self.report          = report
    end

    def headers
      adapter_results.headers.map { |header| Dossier::Formatter.titleize(header) }
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
        adapter_results.rows.each do |row|
          yield format(row)
        end
      end

      def format(result_row)
        unless result_row.is_a?(Enumerable)
          raise ArgumentError.new("#{result_row.inspect} must be Enumerable") 
        end

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
      def each
        adapter_results.rows.each { |row| yield row }
      end
    end

  end
end
