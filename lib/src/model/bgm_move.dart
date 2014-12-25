/**
 *--------------------------------------------------------------------+
 * bgm_move.dart
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

