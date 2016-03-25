require "dossier/engine"
require "dossier/model"
require "dossier/view_context_with_report_formatter"
require "dossier/version"

module Dossier
  extend self

  def configuration
    @configuration || configure
  end

  def configure
    @configuration = Configuration.new
    yield(@configuration) if block_given?
    @configuration
  end

  def client
    configuration.client
  end

  class ExecuteError < StandardError; end
end

require "dossier/adapter/active_record"
require "dossier/adapter/active_record/result"
require "dossier/client"
require "dossier/connection_url"
require "dossier/configuration"
require "dossier/formatter"
require "dossier/query"
require "dossier/report"
require "dossier/responder"
require "dossier/result"
require "dossier/stream_csv"
require "dossier/xls"
