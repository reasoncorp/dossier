module Dossier
  class Formatter
    attr_accessor :value, :options

    def initialize(value, options={})
      @options = options
      @value = value
    end

    def to_s
      format
    end

    def as_json(options={})
      format
    end

    def format
      raise NotImplementedError.new("You must define format in all subclasses of Dossier::Formatter")
    end

  end
end

require 'dossier/format/currency'
require 'dossier/format/currency_in_cents'
require 'dossier/format/date'
require 'dossier/format/number'
require 'dossier/format/title'
require 'dossier/format/object'
require 'dossier/format/url'
