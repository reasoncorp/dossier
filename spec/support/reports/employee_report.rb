class EmployeeReport < Dossier::Report

  option :names, :default => []

  select "* from employees"

  where do 
    conditions << condition("salary > :salary", :salary => 10000) if options[:salary].present?
    names = options[:names].map { |name| condition("name like :name", :name => "%#{name}%") }
    conditions << names.join(' or ')
  end

end
