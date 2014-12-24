part of backgammon;
/**
 * Manage score and preferences
 */

class Context {

  static const String PFX = "com.darkoverlordofdata.backgammon";

  static const VOLUME_ON  = 0.05;
  static const VOLUME_OFF = 0.00;

  bool _sfx = false;
  bool _music = false;
  int _score = 0;
  int _legend = 0;
  List<List<int>> _die = [[0,0],[0,0]];
  Phaser.Signal _scored = null;
  Phaser.Signal _pegged = null;
  Phaser.Signal _action = null;
  Phaser.TextStyle _normal = null;
  BaseLevel _level;
  BgmMatch _match;
  int game = 0;
  int turn = 0;
  int player = 0;
  bool isRolling = false;
  bool isRunning = false;
  String title = '';

  /**
   * Initialize persisted options
   */
  Context(this._level) {
    _level.game.sound.volume = this.volume;

    _scored = new Phaser.Signal();
    _pegged = new Phaser.Signal();
    _action = new Phaser.Signal();
    _normal = new Phaser.TextStyle(font: "12pt Play", fill: "#000");
    _match  = new BgmMatch();
    _sfx    = (window.localStorage["${PFX}_sfx"] == "true");
    _music  = (window.localStorage["${PFX}_music"] == "true");
  }

  BaseLevel get level => _level;
  Phaser.Signal get scored => _scored;
  Phaser.Signal get pegged => _pegged;
  Phaser.Signal get action => _action;
  Phaser.TextStyle get normal => _normal;
  BgmMatch get match => _match;
  bool get sfx => _sfx;
  bool get music => _music;
  double get volume => (_sfx) ? VOLUME_ON: VOLUME_OFF;
  int get score => _score;
  int get legend => _legend;

  set legend(int value) {
    _legend = value;
    pegged.dispatch(_legend);

  }

  /**
   * dice
   */
  int getDie(int die) => _die[player][die];
  void setDie(int die1, int die2) {
    _die[player][0] = die1;
    _die[player][1] = die2;
  }
  /**
   * Update the score, fire signal
   */
  void updateScore(int points) {
    _score += points;
    scored.dispatch(points);
  }


  /**
   * Get game preference
   */
  bool getPreference(String id) {
    switch(id) {
      case 'sfx': return _sfx;
      case 'music': return _music;
    }
    return false;
  }

  /**
   * Set game preference
   */
  setPreference(String id, bool value) {

    switch(id) {

      case 'sfx':
        window.localStorage["${PFX}_${id}"] = value.toString();
        _sfx = value;
        break;

      case 'music':
        window.localStorage["${PFX}_${id}"] = value.toString();
        _music = value;
        break;
    }
  }



}

