module Dossier
  class Client

    attr_accessor :adapter, :options

    delegate :escape, :execute, to: :adapter

    def initialize(options)
      self.options = options.symbolize_keys
    end

    def adapter
      @adapter ||= dossier_adapter.new(self.options.except(:dossier_adapter))
    end

    def dossier_adapter
      adapter_name = options.fetch(:dossier_adapter) { determine_adapter_name }
      "Dossier::Adapter::#{adapter_name.classify}".constantize
    end

    private

    def determine_adapter_name
      if options.has_key?(:connection)
        namespace_for(options[:connection].class)
      else
        guess_adapter_name
      end
    end

    def namespace_for(klass)
      klass.name.split('::').first.underscore
    end

    def guess_adapter_name
      return namespace_for(loaded_orms.first) if loaded_orms.length == 1

      message = <<-Must_be_one_of_them_newfangled_ones.strip_heredoc
        You didn't specify a dossier_adapter. If you had exactly one
        ORM loaded that Dossier knew about, it would try to choose an
        appropriate adapter, but you have #{loaded_orms.length}.
        Must_be_one_of_them_newfangled_ones
      message << "Specifically, Dossier found #{loaded_orms.join(', ')}" if loaded_orms.any?
      raise IndeterminableAdapter.new(message)
    end

    def loaded_orms
      [].tap do |loaded_orms|
        loaded_orms << ActiveRecord::Base if defined?(ActiveRecord)
      end
    end

    class IndeterminableAdapter < StandardError; end
  end
end
