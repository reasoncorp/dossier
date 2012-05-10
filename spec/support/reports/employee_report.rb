class EmployeeReport < Dossier::Report

  option :names, :default => []

  select "* from employees"

  select do
    if options[:columns].present?
      "#{options[:columns]} from employees"
    else
      "* from employees"
    end
  end

  where do 
    conditions << condition("salary > :salary", :salary => 10000) if options[:salary].present?
    names = options[:names].map { |name| condition("name like :name", :name => "%#{name}%") }
    conditions << names.join(' or ')
  end

  class FormatName < Dossier::Formatter
    def format
      "Employee #{value}"
    end
  end

  format :salary   => Currency,
         :hired_on => Date,
         :name     => FormatName

end
