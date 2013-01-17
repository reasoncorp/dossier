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
      string.gsub(/\w*\:\w+/) { |match| escape(report.public_send(match[1..-1])) }
    end

    def escape(value)
      report.client.escape(value)
    end

    # def escape(value)
    #   case value
    #   when NilClass
    #     "NULL"
    #   when Numeric
    #     value
    #   when Array
    #     value.map { |v| escape(v) }.join(', ')
    #   else
    #     "'#{Dossier.client.escape(value.to_s)}'"
    #   end
    # end

  end
end
