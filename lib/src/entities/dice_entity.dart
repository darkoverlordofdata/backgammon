part of backgammon;

const String GROUP_DICE      = "DICE";

class DiceEntity extends AbstractEntity {

  DiceEntity(entities, int player, int count, String key)
  : super(entities) {

    Artemis.Entity die = level.artemis.createEntity();
    int x = (player == 0) ? COL15+(count*64)-12 : COL21+(count*64)-12;


    die
    ..addComponent(new Sprite(x, 270, key, player * 7))
    ..addComponent(new Player(player))
    ..addComponent(new Count(count))
    ..addComponent(new Number(1))
    ..addToWorld();
    groupManager.add(die, GROUP_DICE);

  }

}