module Dossier
  module Adapter
    class ActiveRecord
      class Result

        attr_accessor :rows

        def initialize(ar_connection_results)
          self.rows = ar_connection_results
        end

        def headers
          rows.fields
        end

      end
    end

  end
end
