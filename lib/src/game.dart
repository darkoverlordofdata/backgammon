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

const LEADER1 = 'CgkIgNTS-coHEAIQCA';

class Game extends Li2.Dilithium {

  Li2.Template template;
  Games.GamesApi api;
  Plus.Person person;

  /**
   * == New Game ==
   *   * Set the screen dimensions
   *   * Configure the game states
   *   * Login to Game Services
   *   * Start the game
   *
   */
  Game(Li2.Config config, this.template): super(config) {
    print("Class Game initialized");
  }

  /**
   * Login callback - set environment and player
   */
  connect(Games.GamesApi api, Plus.Person person) {
    this.api = api;
    this.person = person;
    print("Name = ${person.name.givenName}");
    api.leaderboards.get(LEADER1).then((Games.Leaderboard l) {
      print("Leaderboard ${l.name}");
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
