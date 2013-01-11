def insert_employees
  Dossier.client.query('TRUNCATE `employees`')
  [
    {name: 'Moustafa McMann',  hired_on: '2010-10-02', suspeded: false, division: 'Zany Inventions',       salary: 30_000 },
    {name: 'Jimmy Jackalope',  hired_on: '2013-01-11', suspeded: true,  division: 'Tedious Toiling',       salary: 20_000 },
    {name: 'Elise Elderberry', hired_on: '2013-01-11', suspeded: false, division: 'Corporate Malfeasance', salary: 99_000 }
  ].each do |employee|
    query = <<-QUERY
      INSERT INTO 
        `employees` (`name`, `hired_on`, `suspended`, `division`, `salary`) 
      VALUES ('#{employee[:name]}', '#{employee[:hired_on]}', #{employee[:suspeded]}, '#{employee[:division]}', #{employee[:salary]});
    QUERY
    Dossier.client.query(query)
  end
end
