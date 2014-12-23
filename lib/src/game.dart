/**
 *--------------------------------------------------------------------+
 * Game.dart
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

class Game extends Dilithium {

  Li2Template template;

  games.GamesApi api;
  plus.Person person;

  /**
   * == New Game ==
   *   * Set the screen dimensions
   *   * Configure the game states
   *   * Start the game
   *
   * returns this
   */
  Game(Li2Config config, this.template): super(config) {

    print("Class Game initialized");
    game.scale.fullScreenScaleMode = Phaser.ScaleManager.EXACT_FIT;
  }

  /**
   * Login callback - set environment and player
   */
  connect(games.GamesApi api, plus.Person person) {
    this.api = api;
    this.person = person;
    print("Name = ${person.name.givenName}");
    api.leaderboards.get('CgkIgNTS-coHEAIQCA').then((games.Leaderboard l) {
      print(l.name);
    });


  }

  /**
   * Define each of the game states
   */
  Phaser.State levels() {

    game.state.add('game', new BaseLevel('game', config));
    game.state.add('credits', new BaseLevel('credits', config));
    game.state.add('gameover', new BaseLevel('gameover', config));
    game.state.add('preferences', new BaseLevel('preferences', config));

    window.document.getElementById("logo").hidden = true;
    return new BaseLevel('main', config);

  }
}
