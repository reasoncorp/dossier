module Dossier
  class ReportsController < ApplicationController
    def show
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

    def multi
      respond_to do |format|
        format.html do
          begin
            render template: "dossier/reports/#{report_class.report_name}", locals: {multi: report}
          rescue ActionView::MissingTemplate => e
            render template: 'dossier/reports/multi', locals: {multi: report}
          end
        end
      end
    end

    private

    def report_class
      Dossier.name_to_class(params[:report])
    end

    def set_content_disposition!
      headers["Content-Disposition"] = %[attachment;filename=#{params[:report]}-report_#{Time.now.strftime('%m-%d-%Y_%H-%M-%S')}.#{params[:format]}]
    end

    def report
      @report ||= report_class.new(options_params)
    end

    def options_params
      params[:options].presence || {}
    end

  end
end
