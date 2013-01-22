module Dossier
  class ReportsController < ApplicationController
    def show
      report = report_class.new(params[:options] || {})
      report.run

      respond_to do |format|
        format.html do
          begin
            render template: "dossier/reports/#{report.view}", locals: {report: report}
          rescue ActionView::MissingTemplate => e
            render template: 'dossier/reports/show', locals: {report: report}
          end
        end

        format.json do
          render :json => report.results.hashes
        end

        format.csv do
          headers["Content-Disposition"] = %[attachment;filename=#{params[:report]}-report_#{Time.now.strftime('%m-%d-%Y-%H%M%S')}.csv]
          self.response_body = StreamCSV.new(report.raw_results.arrays)
        end
      end
    end

    private

    def report_class
      "#{params[:report].titleize.delete(' ')}Report".constantize
    end

  end
end
