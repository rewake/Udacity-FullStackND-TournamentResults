#!/usr/bin/env python
# 
# tournament.py -- implementation of a Swiss-system tournament
#

import psycopg2


def connect():
    """Connect to the PostgreSQL database.  Returns a database connection."""
    return psycopg2.connect("dbname=tournament")


def deleteMatches():
    """Remove all the match records from the database."""
    conn = connect()
    c = conn.cursor()
    c.execute("DELETE FROM matches")
    conn.commit()
    c.close()


def deletePlayers():
    """Remove all the player records from the database."""
    conn = connect()
    c = conn.cursor()
    c.execute("DELETE FROM players")
    conn.commit()
    c.close()


def countPlayers():
    """Returns the number of players currently registered."""
    conn = connect()
    c = conn.cursor()
    c.execute("SELECT * FROM view_player_count")
    playerCount = c.fetchone()
    c.close()

    '''TODO: test this return data'''
    return playerCount[0]


def registerPlayer(name, email=None, username=None):
    """Adds a player to the tournament database.
  
    The database assigns a unique serial id number for the player.  (This
    should be handled by your SQL database schema, not in your Python code.)
  
    Args:
      name: the player's full name (need not be unique).
      email: the player's email address
      username: a username for the player
    """
    conn = connect()
    c = conn.cursor()
    c.execute("INSERT INTO players (name, email, username, created) VALUES (%s, %s, %s, NOW())",
              (name, email, username))
    conn.commit()
    c.close()


def playerStandings():
    """Returns a list of the players and their win records, sorted by wins.

    The first entry in the list should be the player in first place, or a player
    tied for first place if there is currently a tie.

    Returns:
      A list of tuples, each of which contains (id, name, wins, matches):
        id: the player's unique id (assigned by the database)
        name: the player's full name (as registered)
        wins: the number of matches the player has won
        matches: the number of matches the player has played
    """
    conn = connect()
    c = conn.cursor()
    c.execute("SELECT * FROM view_player_standings")
    standings = []
    for row in c.fetchall():
        standings.append(row)
    c.close()
    return standings


def reportMatch(winner, loser, tournament_id=0):
    """Records the outcome of a single match between two players.

    Args:
      winner:  the id number of the player who won
      loser:  the id number of the player who lost
      match_id: the id number of the match
    """
    conn = connect()
    c = conn.cursor()

    ''' TODO: finish insert & consider byes, etc '''
    c.execute("INSERT INTO matches (tournament_id, player_id, result, created) VALUES "
              "(%s, %s, 1, NOW()), (%s, %s, 0, NOW())",
              (tournament_id, winner, tournament_id, loser))
    conn.commit()


def swissPairings():
    """Returns a list of pairs of players for the next round of a match.
  
    Assuming that there are an even number of players registered, each player
    appears exactly once in the pairings.  Each player is paired with another
    player with an equal or nearly-equal win record, that is, a player adjacent
    to him or her in the standings.
  
    Returns:
      A list of tuples, each of which contains (id1, name1, id2, name2)
        id1: the first player's unique id
        name1: the first player's name
        id2: the second player's unique id
        name2: the second player's name
    """
    conn = connect()
    c = conn.cursor()
    c.execute('select * from view_swiss_pairings')
    pairings = []
    for row in c.fetchall():
        pairings.append(row)
    c.close()
    return pairings


def createTournament():
    return "WORK ON THIS!"


def deleteTournament():
    return "WORK ON THIS!"
