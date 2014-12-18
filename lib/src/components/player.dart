part of backgammon;

class Player extends Artemis.ComponentPoolable {
  int value;

  Player._();
  factory Player([value = true]) {
    Player player = new Artemis.Poolable.of(Player, _constructor);
    player.value = value;
    return player;
  }
  static Player _constructor() => new Player._();
}

