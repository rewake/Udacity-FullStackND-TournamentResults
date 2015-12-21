-- Table definitions for the tournament project.
--
-- Put your SQL 'create table' statements in this file; also 'create view'
-- statements if you choose to use it.
--
-- You can write comments in this file by starting them with two dashes, like
-- these lines here.


-- Drop tournament DB if it exists
DROP DATABASE IF EXISTS tournament;
CREATE DATABASE tournament;
\c tournament;

-- Players table
-- NOTE: I stared off with fields for user details, but left them inactive
-- as the instructions indicate to not have any unused columns.
CREATE TABLE players (
  id       SERIAL PRIMARY KEY,
  name     TEXT,
  --email    TEXT UNIQUE,
  --username TEXT UNIQUE,
  created  TIMESTAMP
);

-- Create unique indexes
--CREATE UNIQUE INDEX ON players (lower(email));
--CREATE UNIQUE INDEX ON players (lower(username));

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

-- View to get swiss pairings
/*
Note to instructor - since this course was about RDBMS queries I figured
I'd push myself a bit to try and come up with a query that handles most of
my logic instead of relying on python.

This query calculates the number of winning matches for each player, and orders
the results by number of wins. That result set is then split into odd and even
rows and lastly pairs those rows together to create a match based on points.
This query also handles odd numbers of players as listed in the extra credit section.
 */
CREATE VIEW view_swiss_pairings AS
  SELECT
    id1, name1, id2, name2
  FROM (
    SELECT * FROM (
      SELECT *, row_number() OVER () AS rownum FROM (
        SELECT * FROM (
          SELECT
            row_number() OVER ( ORDER BY SUM(COALESCE(result, 0)) DESC ) AS row_num1,
            players.id AS id1,
            NAME AS name1
          FROM players LEFT JOIN matches
          ON players.id = matches.player_id
          GROUP BY players.id
          ORDER BY SUM(COALESCE(result, 0)) DESC
        ) odd_rows_inner
        WHERE mod(row_num1, 2)=1
      ) odd_rows
    ) player1
    LEFT JOIN (
      SELECT * FROM (
        SELECT *, row_number() OVER () AS rownum FROM (
          SELECT
            row_number() OVER ( ORDER BY SUM(COALESCE(result, 0)) DESC ) AS row_num2,
            players.id AS id2,
            NAME AS name2
          FROM players LEFT JOIN matches
          ON players.id = matches.player_id
          GROUP BY players.id
          ORDER BY SUM(COALESCE(result, 0)) DESC
        ) even_rows_inner
        WHERE mod(row_num2, 2)=0
      ) even_rows
    ) player2 ON (player1.rownum=player2.rownum)
  ) paired_players;

-- Insert default tournament to satisfy tests and single tournaments
INSERT INTO
  tournaments
  (id, title, t_date, t_time, created)
VALUES
  (0, 'Default Tournament', '2016-01-01', '12:00', NOW());


-- Insert test data
/*
INSERT INTO players (id, name) VALUES
  (27, 'Twlilight Sparkle'),
  (28, 'Fluttershy'),
  (29, 'Applejack'),
  (30, 'Pinkie Pie');

INSERT INTO matches (tournament_id, player_id, result) VALUES
  (0, 27, 1),
  (0, 28, 0),
  (0, 30, 1),
  (0, 29, 0);
*/