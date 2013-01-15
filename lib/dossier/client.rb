module Dossier
  class Client

    attr_reader :adapter

    def initialize(options = {})
      raise ArgumentError.new "No database adapter specified" if options[:adapter].nil?
      options.symbolize_keys!
      @adapter = adapter_class(options.delete(:adapter)).new(options)
    end

    private

    def adapter_class(adapter_name)
      adapter = "dossier/adapters/#{adapter_name}"
      require adapter
      adapter.classify.constantize
    end

  end
end
