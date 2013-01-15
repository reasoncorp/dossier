require 'sqlite3'

module Dossier
  module Adapter
    class SQLite3
      attr_reader :connection

      def self.connection_class
        ::SQLite3::Database
      end

      def initialize(options = {})
        @connection = self.class.connection_class.new(options.fetch(:database))
      end

      def execute(sql)
        Result.new connection.execute(sql)
      rescue ::SQLite3::Exception => e
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
