class EmployeeWithCustomViewReport < Dossier::Report
  # See spec/dummy/app/views
  
  def self.dragon_colors
    %w[blue red green black white silver brown]
  end

  def sql
    "SELECT * FROM employees WHERE suspended = :suspended"
  end

  def dragon_color
    options.fetch(:dragon_color, self.class.dragon_colors.sample)
  end
  
  def formatter
    @formatter ||= CustomFormatter
  end

  def suspended
    true
  end

  module CustomFormatter
    extend Dossier::Formatter
    def margery_butts(word)
      "Margery Butts #{word}"
    end
  end

end
