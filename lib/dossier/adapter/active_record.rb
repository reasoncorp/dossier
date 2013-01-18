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

      def execute(query)
        Result.new(connection.execute(query))
        # TODO: Determine how we can rescue something more specific and still be
        # neutral about what adapter is used. Mix a common module into all known
        # exceptions like Mysql2::Error and rescue that module?
        # rescue ::Mysql2::Error => e
      rescue => e
        raise Dossier::ExecuteError.new "#{e.message}\n\n#{query}"
      end

      private

      def active_record_connection
        klass = Class.new(::ActiveRecord::Base)
        klass.abstract_class = true
        klass.establish_connection(options)
        klass.connection
      end


    end

  end
end
