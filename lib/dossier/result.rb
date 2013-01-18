module Dossier
  class Result
    include Enumerable

    attr_accessor :report, :adapter_results

    def initialize(adapter_results, report)
      self.adapter_results = adapter_results
      self.report          = report
    end

    def headers
      adapter_results.headers
    end

    def body
      rows.first(rows.length - report.options[:footer].to_i)
    end

    def footers
      rows.last(report.options[:footer].to_i)
    end

    def rows
      @rows ||= to_a
    end

    def arrays
      @arrays ||= [headers] + rows
    end

    def hashes
      return @hashes if defined?(@hashes)
      @hashes = rows.map { |row| Hash[headers.zip(row)] }
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
        unless result_row.kind_of?(Enumerable)
          raise ArgumentError.new("#{result_row.inspect} must be a kind of Enumerable") 
        end

        result_row.each_with_index.map do |field, i|
          method = "format_#{headers[i]}"
          report.respond_to?(method) ? report.public_send(method, field) : field
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
