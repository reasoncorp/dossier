module Dossier
  class Client

    attr_accessor :adapter, :options

    delegate :escape, :execute, to: :adapter

    def initialize(options)
      self.options = options.symbolize_keys
      self.adapter = "Dossier::Adapter::#{dossier_adapter.classify}".constantize.new(
        self.options.except(:dossier_adapter)
      )
    end

    def dossier_adapter
      options.fetch(:dossier_adapter) { determine_dossier_adapter }
    end

    private

    attr_accessor :connection

    def determine_dossier_adapter
      if options.has_key?(:connection)
        namespace_to_adapter_name(options[:connection].class)
      else
        guess_adapter_name
      end
    end

    def guess_adapter_name
      unless orms.length == 1
        raise IndeterminableAdapter.new(
          "Dossier can't determine what (ps: #{orms.join(' ,')}) adapter not determinable (Nondeterminable adapter?)"
        )
      end
      namespace_to_adapter_name(orms.first)
    end

    def orms
      [].tap do |orms|
        orms << ActiveRecord::Base if defined?(ActiveRecord)
      end
    end

    def namespace_to_adapter_name(klass)
      klass.name.split('::').first.underscore
    end

    # attr_accessor :connection

    # def initialize(connection)
    #   self.connection = connection
    # end

    # def escape(value)
    #   raise NotImplementedError
    # end

    # def execute(query)
    #   raise NotImplementedError
    # end


    class IndeterminableAdapter < StandardError; end
  end
end
