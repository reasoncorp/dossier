require 'erb'
require 'yaml'

module Dossier
  class Configuration

    attr_accessor :config_path, :connection_options, :client

    def initialize
      @config_path = Rails.root.join('config', 'dossier.yml')
      setup_client!
    end
 
    def load_config
      raw_connection_options = YAML.load(ERB.new(File.read(@config_path)).result)[Rails.env].symbolize_keys || {}
      @connection_options = if ENV["DATABASE_URL"]
        raw_connection_options.merge(Dossier::ConnectionUrl.new.to_hash) 
      else 
        raw_connection_options
      end
    end

    private

    def setup_client!
      load_config
      @client = Dossier::Client.new(@connection_options)

    rescue Errno::ENOENT => e
      raise ConfigurationMissingError.new(
        "#{e.message}. #{@config_path} must exist for Dossier to connect to the database."
      )
    end

  end

  class ConfigurationMissingError < StandardError ; end
end
