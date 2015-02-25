DROP TABLE IF EXISTS users;

CREATE TABLE users (
  id SERIAL unique not null Primary Key,
  username varchar(255) unique not null,
  email varchar(255) unique not null,
  password varchar(255) not null
);

/* database name == todo_list_db */

/*
CREATE TABLE lists (
  list_id integer NOT NULL PRIMARY KEY,
  user_id integer NOT NULL,
  title varchar (255),
  CONSTRAINT fk1_lists lists FOREIGN KEY (user_id)
    REFERENCES users (id) MATCH SIMPLE ON UPDATE
    CASCADE ON DELETE CASCADE);



  CONSTRAINT pk_child PRIMARY KEY (child_id),
  CONSTRAINT fk1_child FOREIGN KEY (parent_id)
    REFERENCES parent (parent_id) MATCH SIMPLE
    ON UPDATE CASCADE ON DELETE CASCADE
)
*/
