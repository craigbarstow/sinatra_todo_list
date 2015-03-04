DROP TABLE IF EXISTS list_items CASCADE;
DROP TABLE IF EXISTS lists CASCADE;
DROP TABLE IF EXISTS users CASCADE;

/* database name == todo_list_db */

CREATE TABLE users (
  id SERIAL unique not null Primary Key,
  username varchar(255) unique not null,
  email varchar(255) unique not null,
  password varchar(255) not null
);

CREATE TABLE lists (
  id SERIAL unique not null Primary Key,
  list_title varchar(255) not null,
  date_created TIMESTAMP not null,
  user_id integer NOT NULL REFERENCES users(id)
);

CREATE TABLE list_items (
  id SERIAL unique not null Primary Key,
  item varchar(500) not null,
  list_id integer NOT NULL REFERENCES lists(id),
  user_id integer NOT NULL REFERENCES users(id)
);
