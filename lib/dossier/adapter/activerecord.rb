module Dossier
  module Adapter
    class ActiveRecord

      attr_accessor :options, :connection

      def initialize(options = {})
        self.options    = options
        self.connection = options.delete(:connection) || active_record_connection
      end

      delegate :execute, to: :connection

      def escape(value)
        connection.quote(value)
      end

      private

      def active_record_connection
        Class.new(::ActiveRecord::Base) do
          self.abstract_class = true
        end.establish_connection(options)
      end

    end


    # def execute(sql)
    #   Result.new connection.query(sql)
    # rescue ::Mysql2::Error => e
    #   raise Dossier::ExecuteError.new "#{e.message}\n\n#{sql}"
    # end

    # def escape(value)
    #   connection.escape(value)
    # end

    # class Result
    #   attr_accessor :rows

    #   def initialize(rows)
    #     self.rows = rows
    #   end

    #   def headers
    #     rows.fields
    #   end
    # end
  end
end
