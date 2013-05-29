module Dossier
  module Naming

    # not using ActiveSupport::Concern because ClassMethods
    # must be extended after ActiveModel::Naming
    def self.included(base)
      base.extend ActiveModel::Naming
      base.extend ClassMethods
    end


    def to_key
      [report_name]
    end

    def to_s
      report_name
    end

    delegate :report_name, :formatted_title, to: "self.class"

    module ClassMethods
      def report_name
        Dossier.class_to_name(self)
      end

      def model_name
        @model_name ||= ActiveModel::Name.new(self, nil, superclass.name).tap do |name|
          name.instance_variable_set(:@param_key, 'options')
        end
      end

      def formatted_title
        Dossier::Formatter.report_name(self)
      end
    end

  end
end
