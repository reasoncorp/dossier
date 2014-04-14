module Dossier
  class Renderer
    attr_reader :report
    attr_writer :engine

    # Conditional for Rails 4.1 or < 4.1 Layout module
    def self.layouts
      defined?(ActionView::Layouts) ? ActionView::Layouts : AbstractController::Layouts
    end

    def initialize(report)
      @report = report
    end

    def render(options = {})
      render_template :custom, options
    rescue ActionView::MissingTemplate => _e
      render_template :default, options
    end

    def engine
      @engine ||= Engine.new(report)
    end

    private

    def render_template(template, options)
      template = send("#{template}_template_path")
      engine.render options.merge(template: template, locals: {report: report})
    end

    def template_path(template)
      "dossier/reports/#{template}"
    end

    def custom_template_path
      template_path(report.template)
    end

    def default_template_path
      template_path('show')
    end

    class Engine < AbstractController::Base
      include Renderer.layouts
      include ViewContextWithReportFormatter
      include AbstractController::Rendering

      attr_reader :report
      config.cache_store = ActionController::Base.cache_store

      layout 'dossier/layouts/application'

      def render_to_body(options = {})
        context  = ActionView::Base.view_context_class.new(lookup_context, {}, self)
        renderer = ActionView::Renderer.new(lookup_context)
        renderer.render(context, options)
      end

      def lookup_context
        ActionView::LookupContext.new(self.class._view_paths)
      end

      def self._helpers
        Module.new do
          include Rails.application.helpers
          include Rails.application.routes.url_helpers
        end
      end

      def self._view_paths
        ActionController::Base.view_paths
      end

      def initialize(report)
        @report = report
        super()
      end
    end
  end
end
