module Dossier
  class Responder < ::ActionController::Responder
    attr_accessor :template

    alias :report :resource

    def to_html
      custom_template!
      default_render
    rescue ActionView::MissingTemplate => e
      default_template!
      default_render
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
      "#{report.class.report_name.parameterize}-report_#{Time.now.strftime('%m-%d-%Y_%H-%M-%S')}.#{format}"
    end

    def default_render
      controller.render template: template, locals: {report: report}
    end

    def default_template!
      self.template = 'show'
    end

    def custom_template!
      self.template = report.class.report_name
    end

    def template=(value)
      @template = "dossier/reports/#{value}"
    end
  end
end
