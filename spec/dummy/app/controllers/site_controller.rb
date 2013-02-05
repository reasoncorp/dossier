class SiteController < ApplicationController
  def index
    render text: 'wooo!'
  end

  def report
    report = EmployeeReport.new
    render template: 'dossier/reports/show', locals: {report: report.run}
  end
end
