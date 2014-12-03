part of backgammon;

const String GROUP_PIPS      = "PIPS";

class PipEntity extends AbstractEntity {

  PipEntity(entities, int color, int point, String key)
  : super(entities) {

    Artemis.Entity pip = level.artemis.createEntity();
    pip
    ..addComponent(new Sprite(0, 0, key, color & 1))
    ..addComponent(new Number(point))
    ..addToWorld();
    groupManager.add(pip, GROUP_PIPS);

  }

}