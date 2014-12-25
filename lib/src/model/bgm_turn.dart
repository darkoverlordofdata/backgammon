/**
 *--------------------------------------------------------------------+
 * bgm_turn.dart
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
