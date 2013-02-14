module Dossier
  class ReportsController < ApplicationController
    def show
      report = report_class.new(params[:options] || {})
      report.run

      respond_to do |format|
        format.html do
          begin
            render template: "dossier/reports/#{report_class.report_name}", locals: {report: report}
          rescue ActionView::MissingTemplate => e
            render template: 'dossier/reports/show', locals: {report: report}
          end
        end

        format.json do
          render :json => report.results.hashes
        end

        format.csv do
          set_content_disposition!
          self.response_body = StreamCSV.new(report.raw_results.arrays)
        end

        format.xls do
          set_content_disposition!
          self.response_body = Xls.new(report.raw_results.arrays)
        end
      end
    end

    def report_class
      Dossier.name_to_class(params[:report])
    end

    private

    def set_content_disposition!
      headers["Content-Disposition"] = %[attachment;filename=#{params[:report]}-report_#{Time.now.strftime('%m-%d-%Y_%H-%M-%S')}.#{params[:format]}]
    end

  end
end
