part of backgammon;

class Sprite extends Artemis.ComponentPoolable {

  num x;
  num y;
  String key;
  var frame;

  Sprite._();
  factory Sprite(num x, num y, String key, [frame]) {
    Sprite sprite = new Artemis.Poolable.of(Sprite, _constructor);
    sprite.x = x;
    sprite.y = y;
    sprite.key = key;
    sprite.frame = frame;
    return sprite;
  }
  static Sprite _constructor() => new Sprite._();
}


