class EmployeeReport < Dossier::Report

  def options
    @options[:names] ||= []
    @options
  end

  select "* from employees"

  where do 
    names = options[:names].map { |name| fragment("name like :name", :name => "%#{name}%") }
    conditions << fragment("salary > :salary", :salary => 10000) if options[:salary].present?
    conditions << names.join(' or ')
  end

end
