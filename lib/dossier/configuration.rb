require 'erb'
require 'yaml'

module Dossier
  class Configuration

    attr_accessor :config_path, :client

    def initialize
      @config_path = Rails.root.join('config', 'dossier.yml')
      setup_client!
    end
   
    def connection_options
      yaml_config.merge(dburl_config || {})
    end

    def yaml_config
      YAML.load(ERB.new(File.read(@config_path)).result)[Rails.env].symbolize_keys
    rescue
      {}
    end
   
    def dburl_config
      Dossier::ConnectionUrl.new.to_hash if ENV.has_key? "DATABASE_URL"
    end

    private

    def setup_client!
      @client = Dossier::Client.new(connection_options)

    rescue Errno::ENOENT => e
      raise ConfigurationMissingError.new(
        "#{e.message}. #{@config_path} must exist for Dossier to connect to the database."
      )
    end

  end

  class ConfigurationMissingError < StandardError ; end
end
