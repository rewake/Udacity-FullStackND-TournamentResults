-- Table definitions for the tournament project.
--
-- Put your SQL 'create table' statements in this file; also 'create view'
-- statements if you choose to use it.
--
-- You can write comments in this file by starting them with two dashes, like
-- these lines here.

-- Players table
CREATE TABLE players (
  id        SERIAL PRIMARY KEY,
  name      TEXT,
  email     TEXT UNIQUE,
  username  TEXT UNIQUE,
  created   TIMESTAMP
);

-- Create unique indexes
CREATE UNIQUE INDEX ON players (lower(email));
CREATE UNIQUE INDEX ON players (lower(username));

-- Tournaments table, which will support multiple tournaments
CREATE TABLE tournaments (
  id      SERIAL PRIMARY KEY,
  title   TEXT,
  t_date  DATE,
  t_time  TIME,
  created TIMESTAMP
);

-- Matches table
CREATE TABLE matches (
  id            SERIAL PRIMARY KEY,
  tournament_id SERIAL REFERENCES tournaments (id) ON UPDATE CASCADE ON DELETE CASCADE,
  player_id     SERIAL REFERENCES players (id) ON UPDATE CASCADE ON DELETE CASCADE,
  result        SMALLINT,
  created       TIMESTAMP
);

-- View to get Player count
CREATE VIEW view_player_count AS
  SELECT COUNT(*)
  FROM players
