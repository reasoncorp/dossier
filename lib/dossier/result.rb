module Dossier
  class Result
    include Enumerable

    attr_accessor :report, :adapter_results

    def initialize(adapter_results, report)
      self.adapter_results = adapter_results
      self.report          = report
      @raw_headers         = adapter_results.headers
      @use_format_column   = report.use_format_column?
    end
    
    def raw_headers
      @raw_headers ||= adapter_results.headers
    end

    def headers
      raise NotImplementedError.new("#{self.class.name} must implement `headers', use `raw_headers' for adapter headers")
    end

    def body
      size = rows.length - report.options[:footer].to_i
      @body ||= size < 0 ? [] : rows.first(size)
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

    # this is the method that creates the individual hash entry
    # hashes should always use raw headers
    def row_hash(row)
      Hash[raw_headers.zip(row)].with_indifferent_access
    end

    def each
      raise NotImplementedError.new("#{self.class.name} must define `each`")
    end

    class Formatted < Result

      def headers
        @formatted_headers ||= @raw_headers.map { |h| report.format_header(h) }
      end

      def each
        adapter_results.rows.each { |row| yield format(row) }
      end

      def format(row)
        unless row.kind_of?(Enumerable)
          raise ArgumentError.new("#{row.inspect} must be a kind of Enumerable") 
        end
        
        row.each_with_index.map do |value, i|
          column = @raw_headers.at(i)
          method = "format_#{column}"

          if report.respond_to?(method)
            args = [method, value]
            # Provide the row as context if the formatter takes two arguments
            args << row_hash(row) if report.method(method).arity == 2
            report.public_send(*args)
          elsif @use_format_column
            report.format_column(column, value)
          else
            value
          end
        end
      end

      private

      def displayable_columns(row)
        row.each_with_index.select { |value, i|
          column = raw_headers.at(i)
          report.display_column?(column)
        }
      end

      def apply_formatter(row, column, value)
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

    class Unformatted < Result
      def each
        adapter_results.rows.each { |row| yield row }
      end

      def headers
        raw_headers
      end
    end

  end
end
