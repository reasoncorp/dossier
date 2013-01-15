def insert_employees
  Dossier.client.execute('TRUNCATE `employees`')
  [
    {name: "Moustafa McMann",  hired_on: '2010-10-02', suspended: false, division: 'Zany Inventions',       salary: 30_000 },
    {name: 'Jimmy Jackalope, Jr.',  hired_on: '2013-01-11', suspended: true,  division: 'Tedious Toiling',       salary: 20_000 },
    {name: 'Elise Elderberry', hired_on: '2013-01-11', suspended: false, division: 'Corporate Malfeasance', salary: 99_000 }
  ].each do |employee|
    query = <<-QUERY
      INSERT INTO 
        `employees` (`name`, `hired_on`, `suspended`, `division`, `salary`) 
      VALUES ('#{employee[:name]}', '#{employee[:hired_on]}', #{employee[:suspended]}, '#{employee[:division]}', #{employee[:salary]});
    QUERY
    Dossier.client.execute(query)
  end
end
