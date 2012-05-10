module Dossier
  module Format
    class Header < Formatter

      def format
        value.to_s.humanize
      end
    end
  end
end
