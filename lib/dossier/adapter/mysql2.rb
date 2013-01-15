require 'mysql2'

module Dossier
  module Adapter
    class Mysql2
      attr_reader :connection

      def self.connection_class
        ::Mysql2::Client
      end

      def self.defaults
        {username: 'root', reconnect: true}
      end

      def initialize(options = {})
        @connection = self.class.connection_class.new(self.class.defaults.merge(options))
      end

      def execute(sql)
        Result.new connection.query(sql)
      rescue ::Mysql2::Error => e
        raise Dossier::ExecuteError.new "#{e.message}\n\n#{sql}"
      end

      def escape(value)
        connection.escape(value)
      end

      class Result
        attr_accessor :rows

        def initialize(rows)
          self.rows = rows
        end

        def headers
          rows.fields
        end
      end

    end
  end
end
