class Dossier::MultiReport

  attr_accessor :reports

  class << self
    attr_accessor :reports
  end

  def self.combine(*reports)
    self.reports = reports
  end

  def self.report=(value)
    value
  end

  def reports
    @reports ||= self.class.reports.map(&:new)
  end

  def run
    reports.each(&:run)
  end

end
