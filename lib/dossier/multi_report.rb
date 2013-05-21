class Dossier::MultiReport

  attr_accessor :options

  class << self
    attr_accessor :reports
  end

  def self.report_name
    Dossier.class_to_name(self)
  end

  def self.combine(*reports)
    self.reports = reports
  end

  def self.report=(value)
    value
  end

  def initialize(options = {})
    self.options = options.dup.with_indifferent_access
  end

  def reports
    @reports ||= self.class.reports.map(&:new)
  end

end
