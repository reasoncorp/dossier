module Dossier
  module ApplicationHelper

    def formatted_dossier_report_path(format, report)
      dossier_report_path(format: format, options: report.options, report: report.class.report_name)
    end

    def render_options(report)
      return if report.multi
      render "dossier/reports/#{report.class.report_name}/options", report: report
    rescue ActionView::MissingTemplate
    end

  end
end
