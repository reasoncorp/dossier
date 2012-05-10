module Dossier
  module Format
    class Currency < Formatter
      include ActionView::Helpers::NumberHelper

      def format
        number_to_currency(value)
      end
    end
  end
end
