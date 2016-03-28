require 'responders' unless defined? ::ActionController::Responder

module Dossier
  class Responder < ::ActionController::Responder
    alias :report :resource

    def to_json
      controller.render json: report.results.hashes
    end

    def to_csv
      set_content_disposition!
      controller.response_body = StreamCSV.new(*collection_and_headers(report.raw_results.arrays))
    end

    def to_xls
      set_content_disposition!
      xls_opts = [options[:user]]+collection_and_headers(report.raw_results.arrays)
      controller.response_body = Xls.new(*xls_opts)
    end

    def respond
      super
    end
    
    private

    def set_content_disposition!
      controller.headers["Content-Disposition"] = %[attachment;filename=#{filename}]
    end
    
    def collection_and_headers(collection)
      headers = collection.shift.map { |header| report.format_header(header) }
      [collection, headers]
    end

    def filename
      "#{report.class.filename}.#{format}"
    end

  end
end
