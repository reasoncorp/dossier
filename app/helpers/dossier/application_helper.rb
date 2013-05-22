module Dossier
  module ApplicationHelper

    def formatted_dossier_report_path(format, report)
      dossier_report_path(format: format, options: report.options, report: report.class.report_name)
    end

  end
end
