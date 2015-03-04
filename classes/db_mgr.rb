require 'pg'
require 'pry'

class DatabaseManager
  def initialize(database_name)
    @database_name = database_name
  end

  def add_user(username, password, email)
    execute do |conn|
      conn.exec_params("INSERT INTO users (username, password, email) VALUES ($1, $2, $3)", [username, password, email])
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
      id_value_object = conn.exec("SELECT id FROM users WHERE username = $1 and password = $2", [username, password])
      if id_value_object.ntuples > 0
        id_value_object[0]['id']
      else
        return -1
      end
    end
  end

  def get_list_titles(user_id)
    execute do |conn|
      conn.exec_params("SELECT * FROM lists WHERE user_id = $1", [user_id]);
    end
  end

  def get_list_title_from_id(list_id)
    execute do |conn|
      conn.exec_params("SELECT list_title FROM lists WHERE id = $1", [list_id])[0]['list_title'];
    end
  end

  def add_list(list_name, created_timestamp, user_id)
    execute do |conn|
      conn.exec_params("INSERT INTO lists (list_title, date_created, user_id) VALUES ($1, $2, $3)", [list_name, created_timestamp, user_id])
    end
  end

  def delete_list(list_id, user_id)
    execute do |conn|
      conn.exec_params("DELETE FROM list_items WHERE list_id = $1 and user_id = $2", [list_id, user_id])
      conn.exec_params("DELETE FROM lists WHERE id = $1 and user_id = $2", [list_id, user_id])
    end
  end

  def get_list_items(list_id, user_id)
    execute do |conn|
      conn.exec_params("SELECT * FROM list_items WHERE list_id = $1 and user_id = $2", [list_id, user_id]);
    end
  end

  def add_list_item(item, list_id, user_id)
    execute do |conn|
      conn.exec_params("INSERT INTO list_items (item, list_id, user_id) VALUES ($1, $2, $3)", [item, list_id, user_id]);
    end
  end

  def delete_list_item(item_id, user_id)
    execute do |conn|
      conn.exec_params("DELETE FROM list_items Where id = $1 and user_id = $2", [item_id,  user_id]);
    end
  end

  private

  def execute
    begin
      connection = PG.connect(dbname: @database_name)
      yield(connection)
    ensure
      connection.close
    end
  end
end
