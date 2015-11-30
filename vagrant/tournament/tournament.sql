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
  email     TEXT,
  username  TEXT,
  created   TIMESTAMP
);

-- Tournaments table, which will support multiple tournaments
CREATE TABLE tournaments (
  id      SERIAL PRIMARY KEY,
  title   TEXT,
  t_date  DATE,
  t_time  TIME,
  created TIMESTAMP
);

-- This was a "first thought" - simple data aggregation ultimately made more sense...
-- ENUM for match results
--CREATE TYPE match_result AS ENUM ('win', 'loss', 'draw', 'bye');

-- Matches table
CREATE TABLE matches (
  id            SERIAL PRIMARY KEY,
  tournament_id SERIAL REFERENCES tournaments (id),
  player_id     SERIAL REFERENCES players (id),
  --result        match_result,
  result        SMALLINT,
  created       TIMESTAMP
);

-- View to get Player count
CREATE VIEW view_player_count AS
  SELECT COUNT(*)
  FROM players
