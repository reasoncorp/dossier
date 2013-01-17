class SqliteEmployeeReport < Dossier::Report

  def sql
    "SELECT * FROM `employees` WHERE name LIKE :name"
  end

  def name
    '%Jimmy%'
  end

  def format_salary(salary)
    formatter.number_to_currency(salary)
  end

end
