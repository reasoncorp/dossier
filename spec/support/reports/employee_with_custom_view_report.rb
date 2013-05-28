class EmployeeWithCustomViewReport < Dossier::Report
  # See spec/dummy/app/views
  
  def self.dragon_colors
    %w[blue red green black white silver brown]
  end

  def sql
    "SELECT * FROM employees WHERE suspended = true"
  end

  def dragon_color
    options.fetch(:dragon_color, self.class.dragon_colors.sample)
  end

end
