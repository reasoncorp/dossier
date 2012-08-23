module Dossier
  module Format
    class Title < Formatter

      def format
        value.to_s.titleize
      end
    end
  end
end
