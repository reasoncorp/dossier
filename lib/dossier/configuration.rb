require 'erb'
require 'yaml'

module Dossier
  class Configuration

    DB_KEY = 'DATABASE_URL'.freeze

    attr_accessor :config_path, :client

    def initialize
      @config_path = Rails.root.join('config', 'dossier.yml')
      setup_client!
    end
   
    def connection_options
      yaml_config.merge(dburl_config || {}).presence || raise_empty_conn_config
    end

    def yaml_config
      YAML.load(ERB.new(File.read(config_path)).result)[Rails.env].symbolize_keys
    rescue Errno::ENOENT
      {}
    end
   
    def dburl_config
      Dossier::ConnectionUrl.new(ENV['DOSSIER_DATABASE_URL']).to_hash if ENV.has_key? DB_KEY
    end

    private

    def setup_client!
      @client = Dossier::Client.new(connection_options)
    end

    def raise_empty_conn_config
      raise ConfigurationMissingError.new(
        "Your connection options are blank, you are missing both #{config_path} and ENV['#{DB_KEY}']"
      )
    end

  end

  class ConfigurationMissingError < StandardError ; end
end
