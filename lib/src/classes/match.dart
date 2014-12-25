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
                                      //  Turn Status Flags
const int TURN_MOVE         = 1;      // a valid move
const int TURN_DOUBLE       = 2;      // player doubles
const int TURN_TAKE         = 4;      // accepts double
const int TURN_DROP         = 8;      // declines double
const int TURN_CANT         = 16;     // can't move
const int TURN_WTF          = 32;     // can't move?
const int TURN_WINS         = 64;     // WIN!

/** 
 * RegExp: Parse document structure
 */
RegExp rxHeader     = new RegExp(r';\s+\[(.*)\s+\"(.*)\"\]');
RegExp rxMatch      = new RegExp(r'(\d+) point match');
RegExp rxGame       = new RegExp(r'Game (\d+)');
RegExp rxPlayers    = new RegExp(r'\s*(.*)\s*:\s*(.*)\s\s\s+(.*)\s*:\s*(.*)');
RegExp rxTwoRolls   = new RegExp(r"(\d+)\)\s+([1-6])-?([1-6]):\s+(.*)([1-6])-?([1-6]):\s+(.*)");
RegExp rxPlayer1    = new RegExp(r"(\d+)\)\s+([1-6])-?([1-6]):\s+(.*)");
RegExp rxPlayer2    = new RegExp(r"(\d+)\)\s\s\s+([1-6])-?([1-6]):\s+(.*)");
RegExp rxDbleTake   = new RegExp(r"(\d+)\)\s+(Doubles\s+=>\s+\d+)\s+(Takes)");
RegExp rxDbleDrop   = new RegExp(r"(\d+)\)\s+(Doubles\s+=>\s+\d+)\s+(Drops)");
RegExp rxMoveDble   = new RegExp(r"(\d+)\)\s+([1-6])-?([1-6]):\s+(.*)\s+(Doubles\s+=>\s+\d+)");
RegExp rxTakesMove  = new RegExp(r"(\d+)\)\s+(Takes)\s+([1-6])-?([1-6]):\s+(.*)");
RegExp rxDropsWins  = new RegExp(r"(\d+)\)\s+(Drops)\s+(Wins\s+\d+)\spoint");
RegExp rxWins2      = new RegExp(r"\s\s\s\s\s\s\s\s\s\s\s+(Wins\s+\d+\spoint)");
RegExp rxWins1      = new RegExp(r"\s+(Wins\s+\d+\spoint)");
RegExp rxCannot1    = new RegExp(r"(\d+)\)\s+([1-6])-?([1-6]):\s+(Cannot\s+Move)(.*)");
RegExp rxCannot2    = new RegExp(r"(\d+)\)\s+([1-6])-?([1-6]):\s+(\?+)(.*)");

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
RegExp rxPasses     = new RegExp(r'Passes');
RegExp rxNoMove     = new RegExp(r'Cannot\s+Move');
RegExp rxWtf        = new RegExp(r'\?+');
RegExp rxPoints     = new RegExp(r'Wins\s+(\d+)\s+point');
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
  bool blot = false;  // Was it a hit?
  bool bar = false;   // Move from the bar?
  bool off = false;   // Move off the board?
  int source = 0;     // from point
  int dest = 0;       // to point
  int times = 1;      // repeated # of times

  /**
   * Parse the raw move data
   */
  BgmMove(String move) {

    Match match;

    if (rxMovePPHT.hasMatch(move)) {
      /**
       * Point/Point*(times)
       */
      match = rxMovePPHT.firstMatch(move);
      blot = true;
      source = int.parse(match[1]);
      dest = int.parse(match[2]);
      times = int.parse(match[3]);

    } else if (rxMovePPT.hasMatch(move)) {
      /**
       * Point/Point(times)
       */
      match = rxMovePPT.firstMatch(move);
      source = int.parse(match[1]);
      dest = int.parse(match[2]);
      times = int.parse(match[3]);

    } else if (rxMoveBPH.hasMatch(move)) {
      /**
       * Bar/Point
       */
      match = rxMoveBPH.firstMatch(move);
      blot = true;
      source = 25;
      dest = int.parse(match[2]);

    } else if (rxMoveBP.hasMatch(move)) {
      /**
       * Bar/Point*
       */
      match = rxMoveBP.firstMatch(move);
      source = 25;
      dest = int.parse(match[2]);

    } else if (rxMovePPH.hasMatch(move)) {
      /**
       * Point/Point*
       */
      match = rxMovePPH.firstMatch(move);
      blot = true;
      source = int.parse(match[1]);
      dest = int.parse(match[2]);

    } else if (rxMovePP.hasMatch(move)) {
      /**
       * Point/Point
       */
      match = rxMovePP.firstMatch(move);
      source = int.parse(match[1]);
      dest = int.parse(match[2]);

    } else if (rxMovePOff.hasMatch(move)) {
      /**
       * Point/Off
       */
      match = rxMovePOff.firstMatch(move);
      source = int.parse(match[1]);
      dest = 0;

    }
  }

}

/**
 * Backgammon Turn
 */
class BgmTurn {

  int status = 0;         //  TURN_* Flag
  int die1 = 0;           //  die 1 value
  int die2 = 0;           //  die 2 value
  int stakes = 0;         //  doubling cube value
  int points = 0;         //  winning point value
  String move = "";       //  raw move text
  List<BgmMove> moves;    //  parsed list of moves

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
    moves = [];
    if (rxDoubles.hasMatch(move)) {
      /**
       * Player Doubled
       */
      match = rxDoubles.firstMatch(move);
      stakes = int.parse(match[1]);
      if ([2, 4, 8, 16, 32, 64].indexOf(stakes) == -1) {
        throw new Exception("Invalid Stakes value [$stakes]");
      }
      status = TURN_DOUBLE;
    } else if (rxTakes.hasMatch(move)) {
      /**
       * Player Takes Double
       */
      status = TURN_TAKE;
    } else if (rxPasses.hasMatch(move)) {
      /**
       * Player Passes Double
       */
      status = TURN_DROP;
    } else if (rxNoMove.hasMatch(move)) {
      /**
       * Player Can't Move
       */
      status = TURN_CANT;
    } else if (rxWtf.hasMatch(move)) {
      /**
       * ???
       */
      status = TURN_CANT;
    } else if (rxPoints.hasMatch(move)) {
      /**
       * Player Wins
       */
      match = rxPoints.firstMatch(move);
      points = int.parse(match[1]);
      status = TURN_WINS;
    } else if (rxMoves.hasMatch(move)) {
      /**
       * Valid Move
       */
      move = move.replaceAll(rxTrim, "");
      move.split(rxSpaces).forEach((move)
        => moves.add(new BgmMove(move)));
      status = TURN_MOVE;
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
    List<String> patch; // patch for rxTwoRolls

    games = [];
    if (source.indexOf("\r\n") != -1) {
      src = source.split("\r\n");
    } else {
      src = source.split("\n");
    }
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
        if (src[line].length > 1) {
          throw new Exception("Invalid match header");
        }
      }
      line++;
      if (line >= src.length) break;
    }

    line++;
    if (rxMatch.hasMatch(src[line])) {
      match = rxMatch.firstMatch(src[line]);
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

            /**
             * Both players rolled and made a move
             */
            match = rxTwoRolls.firstMatch(src[line]);
            turn1 = new BgmTurn(int.parse(match[2]), int.parse(match[3]), match[4]);
            turn2 = new BgmTurn(int.parse(match[5]), int.parse(match[6]), match[7]);
//            print("A:turn1 ${turn1}");
//            print("A:turn2 ${turn2}");
            games[game - 1].turns.add([turn1, turn2]);


          } else if (rxCannot1.hasMatch(src[line])) {

            /**
             * Player 1 can't move
             */
            match = rxCannot1.firstMatch(src[line]);
            turn1 = new BgmTurn(int.parse(match[2]), int.parse(match[3]), match[4]);
            turn2 = new BgmTurn(0, 0, match[5]);
//            print("K:turn1 ${turn1}");
//            print("K:turn2 ${turn2}");
            games[game - 1].turns.add([turn1, turn2]);

          } else if (rxPlayer2.hasMatch(src[line])) {

            /**
             * Only the 2nd player rolls & moves
             */
            match = rxPlayer2.firstMatch(src[line]);
            turn1 = new BgmTurn(0, 0, '');
            turn2 = new BgmTurn(int.parse(match[2]), int.parse(match[3]), match[4]);
//            print("B:turn2 ${turn2}");
            games[game - 1].turns.add([turn1, turn2]);

          } else if (rxPlayer1.hasMatch(src[line])) {

            /**
             * Only the 1st player roles & moves
             */
            match = rxPlayer1.firstMatch(src[line]);
            turn1 = new BgmTurn(int.parse(match[2]), int.parse(match[3]), match[4]);
            turn2 = new BgmTurn(0, 0, '');
//            print("C:turn1 ${turn1}");
            games[game - 1].turns.add([turn1, turn2]);

          } else if (rxDbleTake.hasMatch(src[line])) {

            /**
             * Player1 Doubles, Player2 Accepts
             */
            match = rxDbleTake.firstMatch(src[line]);
            turn1 = new BgmTurn(0, 0, match[2]);
            turn2 = new BgmTurn(0, 0, match[3]);
//            print("D:turn1 ${turn1}");
//            print("D:turn2 ${turn2}");
            games[game - 1].turns.add([turn1, turn2]);

          } else if (rxDbleDrop.hasMatch(src[line])) {

            /**
             * Player1 Doubles, Player2 Declines
             */
            match = rxDbleDrop.firstMatch(src[line]);
            turn1 = new BgmTurn(0, 0, match[2]);
            turn2 = new BgmTurn(0, 0, match[3]);
//            print("E:turn1 ${turn1}");
//            print("E:turn2 ${turn2}");
            games[game - 1].turns.add([turn1, turn2]);

          } else if (rxMoveDble.hasMatch(src[line])) {

            /**
             * Player1 Moves, Player2 Doubles
             */
            match = rxMoveDble.firstMatch(src[line]);
            turn1 = new BgmTurn(int.parse(match[2]), int.parse(match[3]), match[4]);
            turn2 = new BgmTurn(0, 0, match[5]);
//            print("F:turn1 ${turn1}");
//            print("F:turn2 ${turn2}");
            games[game - 1].turns.add([turn1, turn2]);

          } else if (rxTakesMove.hasMatch(src[line])) {

            /**
             * Player1 Accepts Double, Player2 Moves
             */
            match = rxTakesMove.firstMatch(src[line]);
            turn1 = new BgmTurn(0, 0, match[2]);
            turn2 = new BgmTurn(int.parse(match[3]), int.parse(match[4]), match[5]);
//            print("G:turn1 ${turn1}");
//            print("G:turn2 ${turn2}");
            games[game - 1].turns.add([turn1, turn2]);

          } else if (rxDropsWins.hasMatch(src[line])) {

            /**
             * Player1 Declines Double, Player2 Wins
             */
            match = rxDropsWins.firstMatch(src[line]);
            turn1 = new BgmTurn(0, 0, match[2]);
            turn2 = new BgmTurn(0, 0, match[3]);
//            print("H:turn1 ${turn1}");
//            print("H:turn2 ${turn2}");
            games[game - 1].turns.add([turn1, turn2]);

          } else if (rxWins2.hasMatch(src[line])) {

            /**
             * Player1 Wins, Player2 Declines
             */
            print("I:src ${src[line]}");
            match = rxWins2.firstMatch(src[line]);
            turn1 = new BgmTurn(0, 0, '');
            turn2 = new BgmTurn(0, 0, match[1]);
//            print("I:turn1 ${turn1}");
            games[game - 1].turns.add([turn1, turn2]);

          } else if (rxWins1.hasMatch(src[line])) {

            /**
             * Player1 Wins, Player2 Declines
             */
//            print("J:src ${src[line]}");
            match = rxWins1.firstMatch(src[line]);
            turn1 = new BgmTurn(0, 0, match[1]);
            turn2 = new BgmTurn(0, 0, '');
//            print("J:turn1 ${turn1}");
            games[game - 1].turns.add([turn1, turn2]);

          } else {

            if (src[line].length != 0) {
//              print("NO MATCH");
//              print(src[line].length);
            }

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