module Dossier
  module Format
    class Url < Formatter
      include ActionView::Helpers::UrlHelper

      def _routes
        Rails.application.routes
      end

      def controller
      end

      def format
        super # we want to raise the not implemented because this is just a helepr formatter
      end
    end
  end
end

