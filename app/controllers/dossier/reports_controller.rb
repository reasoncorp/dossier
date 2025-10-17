module Dossier
  class ReportsController < ApplicationController
    include ViewContextWithReportFormatter

    self.responder = Dossier::Responder

    respond_to :html, :json, :csv, :xls

    def show
      respond_with(report)
    end

    def multi
      respond_with(report)
    end

    private

    def report_class
      Dossier::Model.name_to_class(params.fetch :report)
    end

    def report
      @report ||= report_class.new(options_params)
    end

    def options_params
      params.slice(:options).permit![:options] || {}
    end
  end
end
