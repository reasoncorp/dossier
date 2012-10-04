require 'yaml'

module Dossier
  class Configuration

    attr_accessor :config_path, :connection_options, :client

    def initialize
      @config_path = Rails.root.join('config', 'dossier.yml')
      setup_client!
    end

    private

    def setup_client!
      @connection_options = YAML.load_file(@config_path)[Rails.env].symbolize_keys
      @client = Mysql2::Client.new(@connection_options.merge(:reconnect => true))

    rescue Errno::ENOENT => e
      raise ConfigurationMissingError.new("#{e.message}. #{@config_path} must exist for Dossier to connect to the database.")
    end

  end

  class ConfigurationMissingError < StandardError ; end
end
