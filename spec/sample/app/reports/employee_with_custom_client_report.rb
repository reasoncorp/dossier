class EmployeeWithCustomClientReport < Dossier::Report

  def sql
    "SELECT * FROM `employees`"
  end

  def dossier_client
    Dossier::Factory.sqlite3_client 
  end
end
