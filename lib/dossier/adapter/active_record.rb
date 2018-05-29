module Dossier
  module Adapter
    class ActiveRecord

      attr_accessor :options, :connection

      def initialize(options = {})
        self.options    = options
        self.connection = options.delete(:connection) || active_record_connection
      end

      def escape(value)
        connection.quote(value)
      end

      def execute(query, report_name = nil)
        new_result(connection, query, report_name)
      rescue => e
        # In case the error ocurred because of a faulty connection, we should
        # aquire a new connection.
        self.connection = active_record_connection
        new_result(connection, query, report_name)
      rescue => e
        raise Dossier::ExecuteError.new "#{e.message}\n\n#{query}"
      end

      def new_result(connection, query, report_name)
        # Ensure that SQL logs show name of report generating query
        Result.new(connection.exec_query(*["\n#{query}", report_name].compact))
      end

      private

      def active_record_connection
        @abstract_class = Class.new(::ActiveRecord::Base) do
          self.abstract_class = true
          
          # Needs a unique name for ActiveRecord's connection pool
          def self.name
            "Dossier::Adapter::ActiveRecord::Connection_#{object_id}"
          end
        end
        @abstract_class.establish_connection(options)
        @abstract_class.connection
      end

    end

  end
end
