require Rails.root.join(*%w[.. support reports employee_report])
require Rails.root.join(*%w[.. support reports employee_with_custom_view_report])

class CombinationReport < Dossier::MultiReport

  combine EmployeeReport, EmployeeWithCustomViewReport

  def tiger_stripes
    options.fetch(:tiger_stripes, 0)
  end

end
