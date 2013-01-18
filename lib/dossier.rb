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

  class ExecuteError < StandardError; end
end

require "dossier/adapter/activerecord"
require "dossier/adapter/activerecord/result"
require "dossier/client"
require "dossier/configuration"
require "dossier/formatter"
require "dossier/query"
require "dossier/report"
require "dossier/result"
require "dossier/stream_csv"
