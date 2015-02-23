class SQL_Helper
  def initialize(database_name)
    @database_name = database_name
  end

  def db_connection
    begin
      connection = PG.connect(dbname: @database_name)
      yield(connection)
    ensure
      connection.close
    end
  end

  def get_ingredients_from_db
    ingredients_in_db_array = []
    ingredients_in_db = db_connection { |conn| conn.exec("SELECT ingredient FROM ingredients") }
    ingredients_in_db.each_row do |row|
      ingredients_in_db_array.push(row[0])
    end
    ingredients_in_db_array
  end
end
