module Dossier
  class Report
    include ActiveSupport::Callbacks

    define_callbacks :build_query, :execute

    attr_reader :options, :results

    def initialize(options = {})
      @options = options.dup.with_indifferent_access
    end

    def build_query
      run_callbacks(:build_query) { @query = compile(query) }
    end

    def query
      raise NotImplementedError, "Must be defined by each report"
    end

    def execute
      build_query
      run_callbacks :execute do
        Dossier.client.query(@query)
      end
    rescue Mysql2::Error => e
      raise Mysql2::Error.new("#{e.message}. \n\n #{@query}")
    end

    def run
      tap { @results = Results.new(execute, self) }
    end

    def headers
      results.headers.map {|key| Dossier::Format::Title.new(key)}
    end

    def rows
      results.map(&:values)
    end

    def to_a
      [headers] + rows.map {|row| row.map(&:value)}
    end

    def view
      self.class.name.sub('Report', '').underscore
    end

    private
    
    def compile(query)
      query.gsub(/\w*\:\w+/) {|match| escape(send(match[1..-1])) }
    end


    def escape(value)
      case value
      when Fixnum
        value
      when String
        "'#{Dossier.client.escape(value)}'"
      when Array
        value.map { |v| escape(v) }.join(', ')
      else
        raise ArgumentError.new(
          "bound values may only be an Array, String, or Fixnum; you provided a #{value.class} (#{value.inspect})."
        )
      end
    end

  end
end
