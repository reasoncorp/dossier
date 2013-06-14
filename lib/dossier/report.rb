module Dossier
  class Report
    include Dossier::Naming
    include ActiveSupport::Callbacks

    define_callbacks :build_query, :execute

    attr_reader :options
    attr_accessor :parent

    class_attribute :formatter
    class_attribute :template

    self.formatter = Dossier::Formatter

    delegate :formatter, :template, to: "self.class"

    def self.inherited(base)
      super
      base.template = base.report_name
    end

    def self.filename
      "#{report_name.parameterize}-report_#{Time.now.strftime('%m-%d-%Y_%H-%M-%S')}"
    end
    
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

    def format_header(header)
      formatter.titleize(header.to_s)
    end

    def format_column(column, value)
      value
    end

    def dossier_client
      Dossier.client
    end

    def renderer
      @renderer ||= Renderer.new(self)
    end
    
    delegate :render, to: :renderer

    private

    def build_query
      run_callbacks(:build_query) { @query = Dossier::Query.new(self) }
    end

    def execute
      build_query
      run_callbacks :execute do
        self.results = dossier_client.execute(query, self.class.name)
      end
    end

    def results=(results)
      results.freeze
      @raw_results = Result::Unformatted.new(results, self)
      @results     = Result::Formatted.new(results, self)
    end

  end
end
