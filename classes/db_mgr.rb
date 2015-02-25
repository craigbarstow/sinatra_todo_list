require 'pg'
require 'pry'

class Database_Manager
  def initialize(database_name)
    @database_name = database_name
    @user_id = nil
  end

  def execute
    begin
      connection = PG.connect(dbname: @database_name)
      yield(connection)
    ensure
      connection.close
    end
  end

  def add_users_from_csv(csv_file_path)
    execute do |conn|
      CSV.foreach(csv_file_path, headers: true) do |row|
        conn.exec_params("INSERT INTO users (username, password, email) VALUES ($1, $2, $3)", [row[0], row[1], row[2]])
      end
    end
  end

  def add_user(username, password, email)
    execute do |conn|
      conn.exec_params("INSERT INTO users (username, password, email) VALUES ($1, $2, $3)", [username, password, email])
      user_id = conn.exec_params("SELECT id from users WHERE username = $1 and password = $2", [username, password])[0]['id']
      conn.exec("CREATE TABLE lists_#{user_id} (
        list_id SERIAL unique NOT NULL PRIMARY KEY,
        user_id integer NOT NULL DEFAULT #{user_id},
        title varchar (255),
        CONSTRAINT lists FOREIGN KEY (user_id)
          REFERENCES users (id) MATCH SIMPLE ON UPDATE
          CASCADE ON DELETE CASCADE)")
    end
  end

  def validate_new_user?(username, email)
    execute do |conn|
      if conn.exec_params("SELECT * FROM users WHERE username = $1", [username]).ntuples > 0
        return false
      elsif conn.exec_params("SELECT * FROM users WHERE email = $1", [email]).ntuples > 0
        return false
      else
        return true
      end
    end
  end

  def validate_login?(username, password)
    execute do |conn|
      if conn.exec("SELECT * FROM users WHERE username = $1 and password = $2", [username, password]).ntuples > 0
        @user_id = conn.exec_params("SELECT id from users WHERE username = $1 and password = $2", [username, password])[0]['id']
        return true
      end
      return false
    end
  end

  def add_list(list_name)
    


    conn.exec("CREATE TABLE list_contents_#{user_id} (
      list_id SERIAL unique NOT NULL PRIMARY KEY,
      user_id integer NOT NULL DEFAULT #{user_id},
      title varchar (255),
      CONSTRAINT lists FOREIGN KEY (user_id)
        REFERENCES users (id) MATCH SIMPLE ON UPDATE
        CASCADE ON DELETE CASCADE)")
  end
end
