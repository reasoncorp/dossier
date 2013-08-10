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
      @connection_options = YAML.load(ERB.new(File.read(@config_path)).result)[Rails.env].symbolize_keys
      @client = Dossier::Client.new(@connection_options)

    rescue Errno::ENOENT => e
      raise ConfigurationMissingError.new(
        "#{e.message}. #{@config_path} must exist for Dossier to connect to the database."
      )
    end

  end

  class ConfigurationMissingError < StandardError ; end
end
