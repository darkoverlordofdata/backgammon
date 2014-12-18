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
  BackgammonApplication(GameLogin login) {


    Dilithium.using("packages/backgammon/res")
    .then((config) {
      config.preferences = translatePreferences(config);
      HttpRequest.getString("packages/backgammon/res/${config.preferences['template']}")
      .then((template) {
        login.connect(new Game(config, new Li2Template(template)));
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


}