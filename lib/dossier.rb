require "dossier/engine"
require "dossier/version"

module Dossier

  def self.configuration
    @configuration
  end

  def self.configure
    @configuration = Configuration.new
    yield(@configuration) if block_given?
    @configuration
  end

  def self.client
    configure unless configuration
    configuration.client
  end

end

require "dossier/configuration"
require "dossier/formatter"
require "dossier/report"
require "dossier/results"
require "dossier/stream_csv"
