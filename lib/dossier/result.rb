module Dossier
  class Result
    include Enumerable

    attr_accessor :report, :adapter_results

    def initialize(adapter_results, report)
      self.adapter_results = adapter_results
      self.report          = report
    end

    def headers
      @headers ||= adapter_results.headers
    end

    def body
      @body ||= rows.first(rows.length - report.options[:footer].to_i)
    end

    def footers
      @footer ||= rows.last(report.options[:footer].to_i)
    end

    def rows
      @rows ||= to_a
    end

    def arrays
      @arrays ||= [headers] + rows
    end

    def hashes
      return @hashes if defined?(@hashes)
      @hashes = rows.map { |row| row_hash(row) }
    end

    def row_hash(row)
      Hash[headers.zip(row)].with_indifferent_access
    end

    def each
      raise NotImplementedError, "#{self.class.name} must define `each`"
    end

    class Formatted < Result

      alias :raw_headers :headers

      def headers
        @formatted_headers ||= super.map { |h| report.format_header(h) }
      end

      def each
        adapter_results.rows.each { |row| yield format(row) }
      end

      def format(row)
        unless row.kind_of?(Enumerable)
          raise ArgumentError.new("#{row.inspect} must be a kind of Enumerable") 
        end

        row.each_with_index.map do |value, i|
          column = raw_headers.at(i)
          method = "format_#{column}"

          if report.respond_to?(method)
            args = [method, value]
            # Provide the row as context if the formatter takes two arguments
            args << row_hash(row) if report.method(method).arity == 2
            report.public_send(*args)
          else
            report.format_column(column, value)
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
