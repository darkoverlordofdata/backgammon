part of backgammon;

class Count extends Artemis.ComponentPoolable {
  int value;

  Count._();
  factory Count([value = true]) {
    Count count = new Artemis.Poolable.of(Count, _constructor);
    count.value = value;
    return count;
  }
  static Count _constructor() => new Count._();
}

