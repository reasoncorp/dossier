module Dossier
  class Renderer
    attr_reader :report
    attr_accessor :template, :engine

    def initialize(report)
      @report = report
    end

    def render
      custom_template!
      default_render
    rescue ActionView::MissingTemplate => e
      default_template!
      default_render
    end

    private

    def default_render
      engine.render template: template, locals: {report: report}
    end

    def default_template!
      self.template = 'show'
    end

    def custom_template!
      self.template = report.class.report_name
    end

    def template=(value)
      @template = "dossier/reports/#{value}"
    end

    def engine
      @engine ||= Engine.new
    end

    class Engine < AbstractController::Base
      include AbstractController::Rendering

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
