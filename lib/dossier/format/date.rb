module Dossier
  module Format
    class Date < Formatter

      def format
        value.strftime '%m/%d/%Y'
      end

    end
  end
end
