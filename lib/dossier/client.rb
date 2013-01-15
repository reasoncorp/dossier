module Dossier
  class Client

    attr_reader :adapter
    delegate :execute, :headers, :escape, to: :adapter

    def initialize(options = {})
      raise ArgumentError.new "No database adapter specified" if options[:adapter].nil?
      options.symbolize_keys!
      @adapter = adapter_class(options.delete(:adapter)).new(options)
    end

    private

    def adapter_class(adapter_name)
      require "dossier/adapter/#{adapter_name}"
      "Dossier::Adapter::#{classname_for(adapter_name)}".constantize
    end

    def classname_for(adapter_name)
      {
        'mysql2'  => 'Mysql2',
        'sqlite3' => 'SQLite3'
      }.fetch(adapter_name)
    end

  end
end
