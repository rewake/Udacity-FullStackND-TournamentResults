-- Table definitions for the tournament project.
--
-- Put your SQL 'create table' statements in this file; also 'create view'
-- statements if you choose to use it.
--
-- You can write comments in this file by starting them with two dashes, like
-- these lines here.

-- Players table
CREATE TABLE players (
  id       SERIAL PRIMARY KEY,
  name     TEXT,
  email    TEXT UNIQUE,
  username TEXT UNIQUE,
  created  TIMESTAMP
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
  result        SMALLINT DEFAULT 0,
  created       TIMESTAMP
);

-- View to get Player count
CREATE VIEW view_player_count AS
  SELECT COUNT(*)
  FROM players;

-- View for player standings
CREATE VIEW view_player_standings AS
  SELECT
    players.id,
    name,
    COALESCE(SUM(result), 0) AS wins,
    COUNT(matches.result)    AS matches
  FROM players
    LEFT OUTER JOIN matches ON players.id = matches.player_id
  GROUP BY players.id;

-- Insert default tournament to satisfy tests
INSERT INTO
  tournaments
  (id, title, t_date, t_time, created)
VALUES
  (0, 'Default Tournament', '2016-01-01', '12:00', NOW());


-- Insert test data
insert into players (id, name)values
(27, 'Twlilight Sparkle'),
(28, 'Fluttershy'),
(29, 'Applejack'),
(30, 'Pinkie Pie');

insert into matches (tournament_id, player_id, result) values
(0, 27, 1),
(0, 28, 0),
(0, 30, 1),
(0, 29, 0);