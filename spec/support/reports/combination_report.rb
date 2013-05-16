require Rails.root.join('..', 'support', 'reports', 'employee_report')
require Rails.root.join('..', 'support', 'reports', 'employee_with_custom_view_report')

class CombinationReport < Dossier::MultiReport

  combine EmployeeReport, EmployeeWithCustomViewReport

end
