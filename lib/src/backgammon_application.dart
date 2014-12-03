/**
 *--------------------------------------------------------------------+
 * BackgammonApplication.dart
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

class BackgammonApplication {

  /**
   * == start game ==
   *
   *   * Hide the logo
   *   * Using game configuration
   *   * Start a game instance
   */
  BackgammonApplication() {

    BgmMatch b = new BgmMatch();
    b.parse(m1);
    print(b);

    Dilithium.using("packages/backgammon/res")
    .then((config) {
      config.preferences = translatePreferences(config);
      HttpRequest.getString("packages/backgammon/res/${config.preferences['template']}")
      .then((template) {
        new Game(config, new Li2Template(template));
      });
    });
  }


  /**
   *  translate the preferences strings
   */
  translatePreferences(config) {

    List categories = [];
    for (var c in config.preferences['categories']) {
      List preferences = [];
      for (var p in c['preferences']) {
        var p1 = {};
        p1['key'] = config.xlate(p['key']);
        p1['type'] = config.xlate(p['type']);
        p1['title'] = config.xlate(p['title']);
        p1['summary'] = config.xlate(p['summary']);
        p1['defaultValue'] = config.xlate(p['defaultValue']);
        if (p1['type'] == 'ListPreference') {
          p1['entries'] = config.xlate(p['entries']);
          p1['entryValues'] = config.xlate(p['entryValues']);
        }
        preferences.add(p1);
      }
      categories.add({'title': config.xlate(c['title']), 'preferences': preferences});
    }
    return {
        'id':           config.preferences['id'],
        'icon':         config.preferences['icon'],
        'template':     config.preferences['template'],
        'title':        config.xlate(config.preferences['title']),
        'categories':   categories
    };
  }

  String m1 = """
; [Site ""]
; [Match ID "-424620746"]
; [Event "Osaka Regular Meeting"]
; [Player 1 "TJ"]
; [Player 2 "kitaji"]
; [Player 1 Elo "1600.00/0"]
; [Player 2 Elo "1600.00/0"]
; [EventDate "2014.11.02"]
; [EventTime "00.00"]
; [Variation "Backgammon"]
; [Unrated "Off"]
; [Crawford "On"]
; [CubeLimit "1024"]

5 point match

 Game 1
 kitaji : 0                            TJ : 0
  1)                                   41: 24/23 13/9
  2) 65: 24/13                         61: 13/7 8/7
  3) 32: 13/8                          43: 24/20 23/20
  4) 41: 24/23 8/4                     31: 13/9
  5) 44: 13/9(2) 6/2(2)                62: 13/11 13/7
  6) 43: 8/4 6/3                       62: 11/5 7/5
  7) 65: 9/4 9/3                        Doubles => 2
  8)  Takes                            33: 9/3 6/3(2)
  9) 21: 23/21 4/3                     66: 20/8(2)
 10) 21: 8/7 8/6                       65: 9/3 8/3
 11) 64: 13/9 13/7                     31: 8/5 3/2
 12) 61: 13/7 6/5                      61: 8/7 8/2
 13) 32: 9/6 7/5                       54: 7/2 5/1
 14) 55: 21/6 7/2                      41: 7/6 7/3
 15) 65: 7/2 6/Off                     62: 6/Off 2/Off
 16) 43: 4/Off 3/Off                   32: 3/Off 2/Off
 17) 53: 5/Off 3/Off                   41: 5/Off
 18)  Doubles => 4                      Takes
 19) 62: 6/Off 2/Off                   31: 3/Off 1/Off
 20) 65: 6/Off 5/Off                   55: 6/1(3) 5/Off
 21) 54: 6/1 4/Off                     52: 3/Off 2/Off
 22) 31: 3/Off 1/Off                   32: 3/1 3/Off
 23) 41: 2/1 2/Off                     51: 1/Off(2)
 24) 65: 2/Off 1/Off
      Wins 4 point



 Game 2
 kitaji : 4                            TJ : 0
  1) 42: 8/4 6/4                       21: 24/23 13/11
  2) 62: 24/18 6/4                     31: 8/5 6/5
  3) 62: 24/18 13/11                   22: 24/22 13/11 6/4(2)
  4) 61: 11/5 6/5                      32: 13/8
  5) 61: 13/6                          65: 22/11
  6) 11: 6/3 4/3                       63: 11/2
  7) 54: 13/4                          62: 8/6 8/2
  8) 64: 13/9 8/2*                     62: Bar/23* 23/17*
  9) 22: Cannot Move                   51: 17/16* 13/8
 10) 33: Bar/22(3) 13/10               21: 16/15* 13/11
 11) 32: Bar/22 4/2                    44: 15/11 8/4(2) 6/2
 12) 32: 18/13                         62: 11/5 4/2
 13) 53: 13/5                          51: 11/6 2/1
 14) 11: 18/17 5/2                     64: 11/7 11/5
 15) 32: 17/12                         43: 7/Off
 16) 32: 12/7                          64: 6/Off 4/Off
 17) 65: 22/17 22/16                   41: 5/Off
 18) 65: 16/5                          42: 6/4 6/2
 19) 52: 17/12 7/5                     61: 5/Off 1/Off
 20) 51: 12/6                          11: 5/4(2) 2/Off
 21) 64: 22/12                         21: 2/1 2/Off
 22) 32: 12/7                          42: 4/Off 2/Off
 23) 41: 22/18 7/6                     31: 4/Off
 24) 66: 18/Off 6/Off                  51: 4/Off 1/Off
 25) 53: ????                           Wins 1 point



 Game 3
 kitaji : 4                            TJ : 1
  1)                                   62: 24/18 13/11
  2) 62: 13/11 13/7*                    Doubles => 2
  3)  Takes                            41: Bar/21 6/5
  4) 42: 8/4* 6/4                      11: Bar/24 8/7(2) 6/5
  5) 55: 13/3 8/3 7/2                  43: 24/17*
  6) 54: Bar/21 13/8*                  33: Cannot Move
  7) 53: 24/21 13/8                    52: Bar/23* 13/8
  8) 63: Bar/16                        41: 24/23 13/9*
  9) 22: Bar/21 24/22 6/4              33: 23/20(2) 11/8 9/6
 10) 51: 22/16                         54: 13/8 13/9*
 11) 32: Bar/23 11/8                   31: 9/5
 12) 62: 23/15                         65: 8/2 6/1
 13) 31: 6/2                           53: 6/1 5/2
 14) 61: 21/15 4/3                     55: 20/15(2) 8/3(2)
 15) 32: 8/6 8/5                       53: 15/7
 16) 43: 21/17* 8/5                    54: Cannot Move
 17) 32: 15/10*                        61: Bar/24
 18) 54: 21/16 6/2                     55: Cannot Move
 19) 54: 17/12 10/6                    52: Cannot Move
 20) 52: 6/1* 3/1                      41: Cannot Move
 21) 63: 16/10 12/9                    31: Cannot Move
 22) 42: 10/6 9/7                      41: Cannot Move
 23) 62: 15/9 7/5                      33: Cannot Move
 24) 54: 9/Off                         42: Cannot Move
 25) 62: 6/Off 5/3                     52: Cannot Move
 26) 63: 6/3 6/Off                     53: Cannot Move
 27) 65: 5/Off(2)                      62: Bar/19
 28) 41: 4/3 4/Off                     33: Cannot Move
 29) 61: 3/2 3/Off                     44: ????
      Wins 2 point and the match




  """;
}