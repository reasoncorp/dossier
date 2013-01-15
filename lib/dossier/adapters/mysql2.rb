require 'mysql2'

module Dossier
  module Adapters
    class Mysql2
      attr_accessor :results
      attr_reader   :connection

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
        self.results = connection.query(sql)
      end

      def headers
        results.fields
      end

      def escape(value)
        connection.escape(value)
      end

    end
  end
end
