part of backgammon;

class Bounce extends Artemis.ComponentPoolable {
  num x, y;

  Bounce._();
  factory Bounce([num x = 0, num y = 0]) {
    Bounce bounce = new Artemis.Poolable.of(Bounce, _constructor);
    bounce.x = x;
    bounce.y = y;
    return bounce;
  }
  static Bounce _constructor() => new Bounce._();
}

