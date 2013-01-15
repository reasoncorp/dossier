module Dossier
  class Report
    include ActiveSupport::Callbacks
    extend ActiveModel::Naming

    define_callbacks :build_query, :execute

    attr_reader :options

    def initialize(options = {})
      @options = options.dup.with_indifferent_access
    end

    def sql
      raise NotImplementedError, "`sql` method must be defined by each report"
    end

    def query
      build_query unless defined?(@query)
      @query.to_s
    end

    def results
      execute unless defined?(@results)
      @results
    end

    def raw_results
      execute unless defined?(@raw_results)
      @raw_results
    end

    def run
      tap { execute }
    end

    def view
      self.class.name.sub(/Report\Z/, '').underscore
    end

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
        self.results = client.execute(query)
      end
    end

    def results=(results)
      results.freeze
      @raw_results = Result::Unformatted.new(results, self)
      @results     = Result::Formatted.new(results, self)
    end

    def client
      Dossier.client
    end

  end
end
