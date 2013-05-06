module Dossier
  class Query

    attr_reader :string, :report

    def initialize(report)
      @report = report
      @string = report.sql.dup
    end

    def to_s
      compile
    end

    private

    def compile
      string.gsub(/\w*\:[a-z]{1}\w*/) { |match| escape(report.public_send(match[1..-1])) }
    end

    def escape(value)
      if value.respond_to?(:map)
        "(#{value.map { |v| escape(v) }.join(', ')})"
      else
        report.dossier_client.escape(value)
      end
    end

  end
end
