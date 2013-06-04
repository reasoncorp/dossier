class Dossier::MultiReport
  include Dossier::Naming

  attr_accessor :options

  class << self
    attr_accessor :reports
  end

  def self.combine(*reports)
    self.reports = reports
  end

  def initialize(options = {})
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
end
