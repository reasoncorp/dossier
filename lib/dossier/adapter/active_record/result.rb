module Dossier
  module Adapter
    class ActiveRecord
      class Result

        attr_accessor :result

        def initialize(activerecord_result)
          self.result = activerecord_result
        end

        def headers
          result.columns
        end

        def rows
          result.rows
        end

      end
    end

  end
end
