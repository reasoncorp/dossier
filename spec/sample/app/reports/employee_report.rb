class EmployeeReport < Dossier::Report

  set_callback :build_query, :before, :example_before_hook
  set_callback :execute,     :after  do
    # do some stuff
  end

  # Valid for users to choose via a multi-select
  def self.valid_columns
    %w[id name hired_on suspended]
  end

  def sql
    "SELECT #{columns} FROM employees WHERE 1=1".tap do |sql|
      sql << "\n AND division in (:divisions)"  if divisions.any?
      sql << "\n AND salary > :salary"          if salary?
      sql << "\n AND (#{names_like})"           if names_like.present?
      sql << "\n ORDER BY name #{order}"
    end
  end

  def columns
    valid_columns.join(', ').presence || '*'
  end

  def valid_columns
    self.class.valid_columns & Array.wrap(options[:columns])
  end

  def order
    options[:order].to_s.upcase === 'DESC' ? 'DESC' : 'ASC'
  end

  def salary
    10_000
  end

  def name
    "%#{names.pop}%"
  end

  def divisions
    @divisions ||= options.fetch(:divisions) { [] }
  end

  def salary?
    options[:salary].present?
  end

  def names_like
    names.map { |name| "name like :name" }.join(' or ')
  end

  def names
    @names ||= options.fetch(:names) { [] }.dup
  end

  def display_column?(name)
    name != 'id'
  end

  def format_salary(amount, row)
    return "Who's Asking?" if row[:division] == "Corporate Malfeasance"
    formatter.number_to_currency(amount)
  end

  def format_hired_on(date)
    date = Date.parse(date) if String === date
    date.to_s(:db)
  end

  def format_name(name)
    "Employee #{name}"
  end

  def format_suspended(value)
    value.to_s.in?(%w(true 1 t)) ? 'Yes' : 'No'
  end

  def example_before_hook
    # do some stuff
  end

  def raw_results
    super
    results = query_results.rows.map { |qr|
      qr.tap { |q| q[4] = format_suspended(q[4]) }
    }
    @raw_results ||= Result::Unformatted.new(results, self)
  end

end
