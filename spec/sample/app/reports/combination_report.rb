class CombinationReport < Dossier::MultiReport

  combine EmployeeReport, EmployeeWithCustomViewReport

  def tiger_stripes
    options.fetch(:tiger_stripes, 0)
  end

end
