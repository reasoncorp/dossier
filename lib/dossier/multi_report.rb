class Dossier::MultiReport
  include Dossier::Model

  attr_accessor :options

  class << self
    attr_accessor :reports
  end

  def self.combine(*reports)
    self.reports = reports
  end

  def initialize(options = {})
    self.options = self.options.to_unsafe_h if self.options.respond_to?(:to_unsafe_h)
    self.options = options.dup.with_indifferent_access
  end

  def reports
    @reports ||= self.class.reports.map { |report|
      report.new(options).tap { |r|
        r.parent = self
      }
    }
  end

  def parent
    nil
  end

  def formatter
    Module.new
  end

  def dom_id
    nil
  end

  def template
    'multi'
  end

  def renderer
    @renderer ||= Dossier::Renderer.new(self)
  end

  delegate :render, to: :renderer

  class UnsupportedFormatError < StandardError
    def initialize(format)
      super "Dossier::MultiReport only supports rendering in HTML format (you tried #{format})"
    end
  end
end
