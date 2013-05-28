module Dossier
  class Renderer

    attr_reader :report
    attr_accessor :template

    def self._helpers
      Module.new do
        include Dossier::ApplicationHelper
      end
    end

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

    def view_context_class
      @view_context_class ||= ActionView::Base.prepare(nil, nil)
    end

    def view_context
      view_context_class.new(view_renderer)
    end

    def view_renderer

    end

    def default_render
      render_to_string template: template, locals: {report: report}
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
  end
end
