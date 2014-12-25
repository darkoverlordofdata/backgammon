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

