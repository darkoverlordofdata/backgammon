part of backgammon;

//EntityProcessingSystem

class StringRenderSystem extends Artemis.VoidEntitySystem {

  BaseLevel level;

  StringRenderSystem(this.level);


  void initialize() {
    if (DEBUG) print("StringRenderSystem::initialize");
    Artemis.GroupManager groupManager = level.artemis.getManager(new Artemis.GroupManager().runtimeType);
    Artemis.ComponentMapper<Position> positionMapper = new Artemis.ComponentMapper<Position>(Position, level.artemis);
    Artemis.ComponentMapper<Text> textMapper = new Artemis.ComponentMapper<Text>(Text, level.artemis);

    groupManager.getEntities(GROUP_STRINGS).forEach((entity) {
      Position position = positionMapper.get(entity);
      Text text = textMapper.get(entity);
      var style = new Phaser.TextStyle(font: text.font, fill: text.fill);
      level.game.add.text(position.x, position.y, text.value, style);

    });
  }

  void processSystem() {
  }
}
