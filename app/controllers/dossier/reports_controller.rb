module Dossier
  class ReportsController < ApplicationController
    def show
      @report = report_class.new(params[:options] || {})
      @report.run
      respond_to do |format|
        format.html do
          begin
            render @report.view
          rescue ActionView::MissingTemplate => e
            render
          end
        end

        format.json do
          render :json => @report.results.to_a
        end

        format.csv do
          headers["Content-Disposition"] = %[attachment;filename=#{params[:report]}-report_#{Time.now.strftime('%m-%d-%Y-%H%M%S')}.csv]
          self.response_body = StreamCSV.new(@report.to_a)
        end
      end
    end

    private

    def report_class
      "#{params[:report].classify}Report".constantize
    end

  end
end
