part of backgammon;

class State extends Artemis.ComponentPoolable {
  String name;

  State._();
  factory State(name) {
    State state = new Artemis.Poolable.of(State, _constructor);
    state.name = name;
    return state;
  }
  static State _constructor() => new State._();
}

