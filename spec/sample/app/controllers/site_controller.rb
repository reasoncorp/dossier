class SiteController < ApplicationController
  def report
    report = EmployeeReport.new
    render template: 'dossier/reports/show', locals: {report: report.run}
  end
end
