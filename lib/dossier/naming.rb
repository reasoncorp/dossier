module Dossier
  module Naming
    extend ActiveSupport::Concern

    included do
      extend ActiveModel::Naming
    end

    def formatted_title
      Dossier::Formatter.report_name(self)
    end

    module ClassMethods
      def report_name
        Dossier.class_to_name(self)
      end
    end

  end
end
