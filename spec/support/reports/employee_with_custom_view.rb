class EmployeeWithCustomViewReport < Dossier::Report
  # See spec/dummy/app/views

  def sql
    "SELECT * FROM employees WHERE suspended = true"
  end

end
