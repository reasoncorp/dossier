module Dossier
  module ApplicationHelper

    def report
      @report
    end

    def formatted_dossier_report_path(format, report)
      dossier_report_path(format: format, options: report.options, report: report.report_name)
    end

    def render_options(report)
      return if report.parent
      render "dossier/reports/#{report.report_name}/options", report: report
    rescue ActionView::MissingTemplate
    end

  end
end
