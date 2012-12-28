module Dossier
  module Format
    class Number < Formatter
      include ActionView::Helpers::NumberHelper

      def format
        number_with_delimiter(value)
      end
    end
  end
end
