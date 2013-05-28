module Dossier
  class Responder < ::ActionController::Responder
    alias :report :resource

    def to_html
      report.renderer.engine   = controller
      controller.response_body = report.render
    end

    def to_json
      controller.render json: report.results.hashes
    end

    def to_csv
      set_content_disposition!
      controller.response_body = StreamCSV.new(report.raw_results.arrays)
    end

    def to_xls
      set_content_disposition!
      controller.response_body = Xls.new(report.raw_results.arrays)
    end
    
    private

    def set_content_disposition!
      controller.headers["Content-Disposition"] = %[attachment;filename=#{filename}]
    end

    def filename
      "#{report.class.filename}.#{format}"
    end

    def set_report_view_context!
      report.renderer.view = controller.view
    end
  end
end
