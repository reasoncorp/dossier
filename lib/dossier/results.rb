module Dossier
  class Results
    include Enumerable

    def initialize(adapter_results, report)
      unless adapter_results.respond_to?(:each)
        raise ArgumentError.new("#{adapter_results.inspect} does not respond to :each") 
      end
      @adapter_results = adapter_results
      @report          = report
    end

    def each
      @adapter_results.each do |row|
        yield format(row)
      end
    end

    def format(result_row)
      raise ArgumentError.new("#{result_row.inspect} must respond to :[]") unless result_row.respond_to?(:[])
      formats = @report.class.formats
      result_row.inject({}) do |new_row, (key, value)|
        new_row[key] = (formats[key] || Dossier::Format::Object).new(value, @report.options)
        new_row
      end
    end

    def headers
      @adapter_results.fields
    end

  end
end
