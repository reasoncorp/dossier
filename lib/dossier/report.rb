module Dossier
  class Report
    include ActiveSupport::Callbacks

    define_callbacks :build_query, :execute

    attr_reader :options, :results

    def initialize(options = {})
      @options = options.dup.with_indifferent_access
    end

    def build_query
      run_callbacks :build_query do
        @query = query
      end
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
      raise Mysql2::Error.new("#{e.message}. \n\n #{sql}")
    end

    def run
      tap { @results = Results.new(execute, self) }
    end

    def headers
      results.headers.map {|key| Dossier::Format::Title.new(key)}
    end

    def rows
      results.map(&:values).tap do |r|
        @footer = r.pop if footer?
      end
    end

    def to_a
      [headers] + rows.map {|row| row.map(&:value)}
    end

    def view
      self.class.name.sub('Report', '').underscore
    end

  end
end
