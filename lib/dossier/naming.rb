module Dossier
  module Naming

    def self.included(base)
      base.extend ActiveModel::Naming
      base.extend ClassMethods
    end

    def formatted_title
      Dossier::Formatter.report_name(self)
    end

    def to_key
      [report_name]
    end

    def to_s
      report_name
    end

    def report_name
      self.class.report_name
    end

    module ClassMethods
      def report_name
        Dossier.class_to_name(self)
      end

      def model_name
        @model_name ||= ActiveModel::Name.new(self, nil, superclass.name).tap do |name|
          name.instance_variable_set(:@param_key, 'options')
        end
      end
    end

  end
end
