CREATE TABLE users(
 user_id serial PRIMARY KEY,
 username VARCHAR (50) UNIQUE NOT NULL
);

CREATE TABLE songs(
 song_id serial PRIMARY KEY,
 song_title VARCHAR (50) UNIQUE NOT NULL
);

CREATE TABLE song_likes
(
  user_id integer NOT NULL,
  song_id integer NOT NULL,
  PRIMARY KEY (user_id, song_id),
  CONSTRAINT song_likes_song_id_fkey FOREIGN KEY (song_id)
      REFERENCES songs (song_id) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION,
  CONSTRAINT song_likes_users_id_fkey FOREIGN KEY (user_id)
      REFERENCES users (user_id) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION
);

CREATE TABLE user_connections
(
  user_id_1 integer NOT NULL,
  user_id_2 integer NOT NULL,
  PRIMARY KEY (user_id_1, user_id_2),
  CONSTRAINT user_connections_user_1_id_fkey FOREIGN KEY (user_id_1)
      REFERENCES users (user_id) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION,
  CONSTRAINT user_connections_user_2_id_fkey FOREIGN KEY (user_id_2)
    REFERENCES users (user_id) MATCH SIMPLE
    ON UPDATE NO ACTION ON DELETE NO ACTION
);