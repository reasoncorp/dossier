module Dossier
  class Renderer
    attr_reader :report
    attr_writer :engine

    def initialize(report)
      @report = report
    end

    def render(options = {})
      render_template :custom, options
    rescue ActionView::MissingTemplate => e
      render_template :default, options
    end

    def engine
      @engine ||= Engine.new
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
      template_path(report.report_name)
    end

    def default_template_path
      template_path('show')
    end

    class Engine < AbstractController::Base
      include AbstractController::Layouts

      layout 'dossier/layouts/application'

      def self._helpers
        Module.new do
          include Rails.application.helpers
          include Rails.application.routes_url_helpers
        end
      end

      def self._view_paths
        ActionController::Base.view_paths
      end
    end
  end
end
