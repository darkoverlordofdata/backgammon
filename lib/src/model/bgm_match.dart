/**
 *--------------------------------------------------------------------+
 * bgm_match.dart
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