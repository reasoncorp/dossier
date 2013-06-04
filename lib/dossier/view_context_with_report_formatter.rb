module Dossier
  module ViewContextWithReportFormatter
    def view_context
      super.extend(report.formatter)
    end
  end
end
