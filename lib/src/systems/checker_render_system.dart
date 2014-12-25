part of backgammon;

const int TEXT_TOP = 15;
const int TEXT_BOTTOM = 570;
const int TOP = 39;
const int BOTTOM = 513;
const int CENTER = 275;
const int PIP_SIZE = 42;
const int POINT_OFF = 0;
const int POINT_BAR = 25;
const int COL0 = 397;
const int COL1 = 727;
const int COL2 = 672;
const int COL3 = 617;
const int COL4 = 562;
const int COL5 = 507;
const int COL6 = 452;
const int COL7 = 342;
const int COL8 = 287;
const int COL9 = 232;
const int COL10 = 177;
const int COL11 = 122;
const int COL12 = 67;
const int COL13 = 67;
const int COL14 = 122;
const int COL15 = 177;
const int COL16 = 232;
const int COL17 = 287;
const int COL18 = 342;
const int COL19 = 452;
const int COL20 = 507;
const int COL21 = 562;
const int COL22 = 617;
const int COL23 = 672;
const int COL24 = 727;
const int COL25 = 0;


class CheckerRenderSystem extends Artemis.VoidEntitySystem {

  BaseLevel level;
  Context context;


  CheckerRenderSystem(this.level);

  /**
   * set up the backgammon board for a new game
   */
  void initialize() {

    if (DEBUG) print("CheckerRenderSystem::initialize");

    context = level.context;

    Artemis.GroupManager groupManager = level.artemis.getManager(new Artemis.GroupManager().runtimeType);

    Artemis.ComponentMapper<Sprite> spriteMapper = new Artemis.ComponentMapper<Sprite>(Sprite, level.artemis);
    Artemis.ComponentMapper<Number> numberMapper = new Artemis.ComponentMapper<Number>(Number, level.artemis);

    List<Phaser.Group> pips = [level.game.add.group(), level.game.add.group()];

    groupManager.getEntities(GROUP_CHECKERS).forEach((entity) {

      Sprite sprite = spriteMapper.get(entity);
      Number number = numberMapper.get(entity);

      int player = sprite.frame & 1; //  white | red
      int point = number.value; //  1..24

      sprite.x = context.pos[player][point].x;
      switch(context.pos[player][point].y) {

        case TOP:
          sprite.y = context.pos[player][point].y + (context.board[player][point].length*PIP_SIZE);
          break;

        case BOTTOM:
          sprite.y = context.pos[player][point].y - (context.board[player][point].length*PIP_SIZE);
          break;
      }
      context.board[player][point].add(pips[player].create(sprite.x, sprite.y, sprite.key, sprite.frame));

    });

  }

  /**
   * update the board
   */
  void processSystem() {}
}
