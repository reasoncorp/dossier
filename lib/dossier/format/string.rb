module Dossier
  module Format
    class String < Formatter
      def format
        value.to_s
      end
    end
  end
end
