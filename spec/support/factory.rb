module Dossier
  module Factory
    extend self
    def employees
      [
        {name: "Moustafa McMann",  hired_on: '2010-10-02', suspended: false, division: 'Zany Inventions',       salary: 30_000 },
        {name: 'Jimmy Jackalope, Jr.',  hired_on: '2013-01-11', suspended: true,  division: 'Tedious Toiling',       salary: 20_000 },
        {name: 'Elise Elderberry', hired_on: '2013-01-11', suspended: false, division: 'Corporate Malfeasance', salary: 99_000 }
      ]
    end

    def mysql2_client
      @mysql2_client ||= Dossier::Client.new(DB_CONFIG.fetch(:mysql2))
    end

    def sqlite3_client
      @sqlite3_client ||= Dossier::Client.new(DB_CONFIG.fetch(:sqlite3))
    end

    def mysql2_connection
      mysql2_client.adapter.connection
    end

    def sqlite3_connection
      sqlite3_client.adapter.connection
    end

    def mysql2_create_employees
      mysql2_connection.execute('CREATE DATABASE IF NOT EXISTS `dossier_test`', 'FACTORY')
      mysql2_connection.execute('DROP TABLE IF EXISTS `employees`', 'FACTORY')
      mysql2_connection.execute(
        <<-SQL, 'FACTORY'
          CREATE TABLE `employees` (
            `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
            `name` varchar(255) NOT NULL,
            `division` varchar(255) NOT NULL,
            `salary` int(11) NOT NULL,
            `suspended` tinyint(1) NOT NULL DEFAULT 0,
            `hired_on` date NOT NULL,
            PRIMARY KEY (`id`)
          ) ENGINE=InnoDB DEFAULT CHARSET=utf8;
        SQL
      )
    end

    def sqlite3_create_employees
      sqlite3_connection.execute('DROP TABLE IF EXISTS `employees`', 'FACTORY')
      sqlite3_connection.execute(
        <<-SQL, 'FACTORY'
          CREATE TABLE `employees` (
            `id` INTEGER PRIMARY KEY AUTOINCREMENT,
            `name` TEXT NOT NULL,
            `division` TEXT NOT NULL,
            `salary` INTEGER NOT NULL,
            `suspended` TINYINT NOT NULL DEFAULT 0,
            `hired_on` DATE NOT NULL
          );
        SQL
      )
    end

    def mysql2_seed_employees
      mysql2_connection.execute('TRUNCATE `employees`', 'FACTORY')
      employees.each do |employee|
        query = <<-QUERY
          INSERT INTO 
            `employees` (`name`, `hired_on`, `suspended`, `division`, `salary`) 
          VALUES ('#{employee[:name]}', '#{employee[:hired_on]}', #{employee[:suspended]}, '#{employee[:division]}', #{employee[:salary]});
        QUERY
        mysql2_connection.execute(query, 'FACTORY')
      end
    end

    def sqlite3_seed_employees
      sqlite3_connection.execute('DELETE FROM `employees`', 'FACTORY')
      employees.each do |employee|
        query = <<-QUERY
          INSERT INTO 
            `employees` (`name`, `hired_on`, `suspended`, `division`, `salary`) 
          VALUES ('#{employee[:name].upcase}', '#{employee[:hired_on]}', #{employee[:suspended] ? 1 : 0}, '#{employee[:division]}', #{employee[:salary]});
        QUERY
        sqlite3_connection.execute(query, 'FACTORY')
      end
    end
  end
end
