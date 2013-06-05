module Dossier
  module Naming

    # not using ActiveSupport::Concern because ClassMethods
    # must be extended after ActiveModel::Naming
    def self.included(base)
      base.extend ActiveModel::Naming
      base.extend ClassMethods
    end

    def self.class_to_name(klass)
      (klass.name || anonymous_report).underscore[0..-8]
    end

    def self.name_to_class(name)
      "#{name}_report".classify.constantize
    end

    def self.anonymous_report
      'AnonymousReport'
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
        Dossier::Naming.class_to_name(self)
      end

      def formatted_title
        Dossier::Formatter.report_name(self)
      end

      def model_name
        @model_name ||= ActiveModel::Name.new(self, nil, superclass.name).tap do |name|
          name.instance_variable_set(:@param_key, 'options')
        end
      end

    end

  end
end
