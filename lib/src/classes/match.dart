/**
 *--------------------------------------------------------------------+
 * match.dart
 *--------------------------------------------------------------------+
 * Copyright DarkOverlordOfData (c) 2014
 *--------------------------------------------------------------------+
 *
 * This file is a part of Backgammon
 *
 * Backgammon is free software; you can copy, modify, and distribute
 * it under the terms of the GPLv3 License
 *
 *--------------------------------------------------------------------+
 *
 */
part of backgammon;

/**
 * Data Model of a Backgammon Match
 *
 * parses/creates a transcript of the match
 *
 */


/**
 * RegExp: Parse document structure
 */
RegExp rxHeader     = new RegExp(r';\s+\[(.*)\s+\"(.*)\"\]');
RegExp rxPoints     = new RegExp(r'(\d+) point match');
RegExp rxGame       = new RegExp(r'Game (\d+)');
RegExp rxPlayers    = new RegExp(r'\s*(.*)\s*:\s*(.*)\s\s\s+(.*)\s*:\s*(.*)');
RegExp rxTwoRolls   = new RegExp(r'(\d+)\)\s*(.*)\s\s\s+(.*)');
RegExp rxOneRoll    = new RegExp(r'(\d+)\)(.*)');
RegExp rxComment    = new RegExp(r'\s+(.*)');
RegExp rxRoll       = new RegExp(r'([1-6])-?([1-6])\s*:\s*(.*)');
RegExp rxTrim       = new RegExp(r'\s+$');
RegExp rxSpaces     = new RegExp(r'\s+');

/**
 * RegExp: Parse turn
 */
RegExp rxDoubles    = new RegExp(r'Doubles\s+=>\s+(\d+)');
RegExp rxTakes      = new RegExp(r'Takes');
RegExp rxNoMove     = new RegExp(r'Cannot\s+Move');
RegExp rxWtf        = new RegExp(r'\?\?\?\?');
RegExp rxWins       = new RegExp(r'Wins\s+(\d+)\s+point');
RegExp rxMoves      = new RegExp(r'(([^\s]+)\s+)*');

/**
 * RegExp: Parse move
 */
RegExp rxMoveBP     = new RegExp(r'(Bar)\/(\d+)');            //  Bar/Point
RegExp rxMoveBPH    = new RegExp(r'(Bar)\/(\d+)\*');          //  Bar/Point*
RegExp rxMovePP     = new RegExp(r'(\d+)\/(\d+)');            //  Point/Point
RegExp rxMovePPH    = new RegExp(r'(\d+)\/(\d+)\*');          //  Point/Point*
RegExp rxMovePPT    = new RegExp(r'(\d+)\/(\d+)\((\d)\)');    //  Point/Point(times)
RegExp rxMovePPHT   = new RegExp(r'(\d+)\/(\d+)\*\((\d)\)');  //  Point/Point*(times)
RegExp rxMovePOff   = new RegExp(r'(\d+)\/Off');              //  Point/Off

/**
 * Backgammon Move
 */
class BgmMove {
  bool hit = false;   // Was it a hit?
  bool bar = false;   // Move from the bar?
  bool off = false;   // Move off the board?
  int source = 0;     // from point
  int dest = 0;       // to point
  int times = 1;      // repeated # of times

}

/**
 * Backgammon Turn
 */
class BgmTurn {

  bool bDoubles = false;
  bool bTakes = false;
  bool bCantMove = false;
  bool bWtf = false;
  bool bWins = false;
  bool bMove = false;

  int die1 = 0;
  int die2 = 0;
  int double = 0;
  int points = 0;
  String move = "";

  /**
   * New Turn
   *
   * @param die1  die 1 throw
   * @param die2  die 2 throw
   * @param move  raw move data
   *
   */
  BgmTurn(this.die1, this.die2, this.move) {

    Match match;

    if (rxDoubles.hasMatch(move)) {
      /**
       * Player Doubled
       */
      match = rxDoubles.firstMatch(move);
      double = int.parse(match[1]);
      bDoubles = true;
    } else if (rxTakes.hasMatch(move)) {
      /**
       * Player Takes
       */
      bTakes = true;
    } else if (rxNoMove.hasMatch(move)) {
      /**
       * Player Can't Move
       */
      bCantMove = true;
    } else if (rxWtf.hasMatch(move)) {
      /**
       * ???
       */
      bWtf = true;
    } else if (rxWins.hasMatch(move)) {
      /**
       * Player Wins
       */
      match = rxWins.firstMatch(move);
      points = int.parse(match[1]);
      bWins = true;
    } else if (rxMoves.hasMatch(move)) {
      /**
       * Valid Move
       */
      move = move.replaceAll(rxTrim, "");
      List<String> moves = move.split(rxSpaces);
      moves.forEach((move) {
        if (rxMovePPHT.hasMatch(move)) {
          //  Point/Point*(times)
          match = rxMovePPHT.firstMatch(move);
          print("move ${match[1]} to ${match[2]} and hit x ${match[3]}");

        } else if (rxMovePPT.hasMatch(move)) {
          //  Point/Point(times)
          match = rxMovePPT.firstMatch(move);
          print("move ${match[1]} to ${match[2]} x ${match[3]}");

        } else if (rxMoveBPH.hasMatch(move)) {
          //  Bar/Point
          match = rxMoveBPH.firstMatch(move);
          print("move bar to ${match[2]} and hit");

        } else if (rxMoveBP.hasMatch(move)) {
          //  Bar/Point*
          match = rxMoveBP.firstMatch(move);
          print("move bar to ${match[2]}");

        } else if (rxMovePPH.hasMatch(move)) {
          //  Point/Point*
          match = rxMovePPH.firstMatch(move);
          print("move ${match[1]} to ${match[2]} and hit");

        } else if (rxMovePP.hasMatch(move)) {
          //  Point/Point
          match = rxMovePP.firstMatch(move);
          print("move ${match[1]} to ${match[2]}");

        } else if (rxMovePOff.hasMatch(move)) {
          //  Point/Off
          match = rxMovePOff.firstMatch(move);
          print("move ${match[1]} off");

        } else {
          print(move);
        }
      });
      bMove = true;
    }

  }

  /**
   * toString
   */
  String toString() {
    if (die1 == 0)
      return "$move";
    else
      return "$die1$die2: $move";
  }
}

/**
 * Backgammon Game
 */
class BgmGame {
  int id  = 0;
  String player1 = "";
  int score1 = 0;
  String player2 = "";
  int score2 = 0;
  String comment = "";
  List turns;

  BgmGame(this.id, this.player1, this.score1, this.player2, this.score2) {
    turns = [];
  }

  /**
   * toString
   */
  String toString() {
    String str = """
 Game $id
 $player1 : $score1        $player2 : $score2
""";

    for (int it = 0; it < turns.length; it++) {
      BgmTurn t1 = turns[it][0];
      BgmTurn t2 = turns[it][1];
      if (t2 == null) {
        str += " $it) $t1\n";
      } else {
        String ix = "${it+1}";
        if (it < 9) ix = " "+ix;
        if (t1 == null)
          str += " $ix)            $t2\n";
        else
          str += " $ix) $t1        $t2\n";
      }
    }
    str += "$comment\n";
    return str;
  }
}

/**
 * Backgammon Match
 */
class BgmMatch {

  String site = "";
  String matchId = "";
  String event = "";
  String round = "";
  String player1 = "";
  String elo1 = "";
  String player2 = "";
  String elo2 = "";
  String eventDate = "";
  String eventTime = "";
  String variation = "Backgammon";
  bool unrated = true;
  bool jacobyRule = false;
  bool crawfordRule = false;
  int cubeLimit = 1024;
  String transcriber = "";
  int pointMatch = 0;
  List<BgmGame> games;

  /**
   * Parse source file for Backgammon Match
   */
  parse(String source) {

    List<String> src;   // Source string array
    int line;           // Source line no
    int game;           // current game #
    Match match;        // RegExp firstMatch result
    Match roll1;        // Dice roll match
    Match roll2;        // Dice roll match
    BgmTurn turn1;      // Turn data
    BgmTurn turn2;      // Turn data


    games = [];
    src = source.split("\n");
    line = 0;

    while (src[line].length > 0) {
      /**
       * Parse header elements
       * ex: ; [Player 2 "kitaji"]
       */
      if (rxHeader.hasMatch(src[line])) {
        match = rxHeader.firstMatch(src[line]);
        switch (match[1]) {
          case "Crawford":
            crawfordRule = (match[2] == "On");
            break;
          case "CubeLimit":
            cubeLimit = int.parse(match[2]);
            break;
          case "Event":
            event = match[2];
            break;
          case "EventDate":
            eventDate = match[2];
            break;
          case "EventTime":
            eventTime = match[2];
            break;
          case "Match ID":
            matchId = match[2];
            break;
          case "Player 1":
            player1 = match[2];
            break;
          case "Player 1 Elo":
            elo1 = match[2];
            break;
          case "Player 2":
            player2 = match[2];
            break;
          case "Player 2 Elo":
            elo2 = match[2];
            break;
          case "Site":
            site = match[2];
            break;
          case "Unrated":
            unrated = (match[2] == "On");
            break;
          case "Variation":
            variation = match[2];
            break;
        }
      } else {
        throw new Exception("Invalid match header");
      }
      line++;
      if (line >= src.length) break;
    }

    line++;
    if (rxPoints.hasMatch(src[line])) {
      match = rxPoints.firstMatch(src[line]);
      pointMatch = int.parse(match[1]);
    }

    /**
     * Parse each game
     */
    while (line < src.length) {
      /**
       * Skip to Game #
       */
      while (!rxGame.hasMatch(src[line])) {
        line++;
      }

      /**
       * Parse Game Number
       */
      match = rxGame.firstMatch(src[line]);
      line++;
      game = int.parse(match[1]);

      /**
       * Parse Players
       */
      if (rxPlayers.hasMatch(src[line])) {
        match = rxPlayers.firstMatch(src[line]);
        line++;
        games.add(new BgmGame(games.length+1, match[1], int.parse(match[2]), match[3], int.parse(match[4])));

        /**
         * Parse turns until the next game
         */
        while (line < src.length && !rxGame.hasMatch(src[line])) {

          if (rxTwoRolls.hasMatch(src[line])) {
            match = rxTwoRolls.firstMatch(src[line]);

            /**
             * Both players rolled on this turn
             *
             * Player 1
             */
            if (rxRoll.hasMatch(match[2])) {
              roll1 = rxRoll.firstMatch(match[2]);
              turn1 = new BgmTurn(int.parse(roll1[1]), int.parse(roll1[2]), roll1[3]);
            } else {
              turn1 = new BgmTurn(0, 0, match[2]);
            }

            /**
             * Player 2
             */
            if (rxRoll.hasMatch(match[3])) {
              roll2 = rxRoll.firstMatch(match[3]);
              turn2 = new BgmTurn(int.parse(roll2[1]), int.parse(roll2[2]), roll2[3]);
            } else {
              turn2 = new BgmTurn(0, 0, match[3]);
            }
            games[game - 1].turns.add([turn1, turn2]);

            
          } else if (rxOneRoll.hasMatch(src[line])) {
            match = rxOneRoll.firstMatch(src[line]);

            /**
             * Player 1 only
             */
            if (rxRoll.hasMatch(match[2])) {
              roll1 = rxRoll.firstMatch(match[2]);
              turn1 = new BgmTurn(int.parse(roll1[1]), int.parse(roll1[2]), roll1[3]);
            } else {
              turn1 = new BgmTurn(0, 0, match[2]);
            }
            games[game - 1].turns.add([turn1, null]);

            
          } else if (rxComment.hasMatch(src[line])) {
            match = rxComment.firstMatch(src[line]);

            /**
             * Just a comment - Win | Doubles | Takes
             */
            games[game - 1].comment = match[1];
          }
          line++;
        }
      }
    }
  }

  /**
   * toString
   */
  String toString() {

    String str = """
; [Site "$site"]
; [Match ID "$matchId"]
; [Player 1 "$player1"]
; [Player 2 "$player2"]
; [Player 1 Elo "$elo1"]
; [Player 2 Elo "$elo2"]
; [EventDate "$eventDate"]
; [EventTime "$eventTime"]
; [Variation "$variation"]
; [Unrated "${unrated ? "On" : "Off"}"]
; [Crawford "${crawfordRule ? "On" : "Off"}"]
; [CubeLimit "$cubeLimit"]

$pointMatch point match

""";
    for (int ig = 0; ig < games.length; ig++) {
      str+="${games[ig]}\n";
    }

    return str;
  }
}