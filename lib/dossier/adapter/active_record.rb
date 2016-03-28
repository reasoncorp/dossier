module Dossier
  module Adapter
    class ActiveRecord

      attr_accessor :options, :connection

      def initialize(options = {})
        self.options    = options
      end

      def connection
        ::ActiveRecord::Base.connection
      end

      def escape(value)
        connection.quote(value)
      end

      def execute(query, report_name = nil)
        # Ensure that SQL logs show name of report generating query
        Result.new(connection.exec_query(*["\n#{query}", report_name].compact))
      rescue => e
        raise Dossier::ExecuteError.new "#{e.message}\n\n#{query}"
      end

    end

  end
end
