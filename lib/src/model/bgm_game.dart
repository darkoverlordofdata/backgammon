/**
 *--------------------------------------------------------------------+
 * bgm_game.dart
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

