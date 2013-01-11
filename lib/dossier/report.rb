module Dossier
  class Report
    include ActiveSupport::Callbacks

    define_callbacks :build_query, :execute

    attr_reader :options

    def initialize(options = {})
      @options = options.dup.with_indifferent_access
    end

    def sql
      raise NotImplementedError, "Must be defined by each report"
    end

    def query
      build_query unless @query.is_a?(Dossier::Query)
      @query.to_s
    end

    def results
      execute unless @results.is_a?(Dossier::Result)
      @results
    end

    def run
      tap { results }
    end

    # TODO move into presentation object
    def headers
      results.headers.map {|key| Dossier::Formatter.titleize(key.to_s)}
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
    # END TODO

    def formatter
      Dossier::Formatter
    end

    private

    def build_query
      run_callbacks(:build_query) { @query = Dossier::Query.new(self) }
    end

    def execute
      build_query
      run_callbacks :execute do
        self.results = Dossier.client.query(query)
      end
    rescue Mysql2::Error => e
      raise Mysql2::Error.new("#{e.message}. \n\n #{@query}")
    end

    def results=(results)
      @results = Result.new(results, self)
    end

  end
end
