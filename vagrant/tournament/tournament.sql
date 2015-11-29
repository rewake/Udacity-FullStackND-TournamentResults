-- Table definitions for the tournament project.
--
-- Put your SQL 'create table' statements in this file; also 'create view'
-- statements if you choose to use it.
--
-- You can write comments in this file by starting them with two dashes, like
-- these lines here.

-- Players table
CREATE TABLE players (
  id        SERIAL,
  username  TEXT,
  email     TEXT,
  firstname TEXT,
  lastname  TEXT,
  created   TIMESTAMP
);

-- Tournaments table, which will support multiple tournaments
CREATE TABLE tournaments (
  id      SERIAL,
  title   TEXT,
  t_date  DATE,
  t_time  TIME,
  created TIMESTAMP
);

-- ENUM for match results
CREATE TYPE match_result AS ENUM ('win', 'loss', 'draw', 'bye');

-- Matches table
CREATE TABLE matches (
  id            SERIAL,
  tournament_id SERIAL,
  player_id     SERIAL,
  created       TIMESTAMP,
  result        match_result
);

-- View to get Player count
CREATE VIEW view_player_count AS
  SELECT COUNT(*)
  FROM players
