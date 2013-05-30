require "map"
require "dossier/engine"
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

  def class_to_name(klass)
    klass.name.underscore[0..-8]
  end

  def name_to_class(name)
    "#{name}_report".classify.constantize
  end

  class ExecuteError < StandardError; end
end

require "dossier/naming"
require "dossier/adapter/active_record"
require "dossier/adapter/active_record/result"
require "dossier/client"
require "dossier/configuration"
require "dossier/formatter"
require "dossier/multi_report"
require "dossier/query"
require "dossier/renderer"
require "dossier/report"
require "dossier/responder"
require "dossier/result"
require "dossier/segment"
require "dossier/segment/chain"
require "dossier/segment/definition"
require "dossier/segment/rows"
require "dossier/segmenter"
require "dossier/stream_csv"
require "dossier/xls"
