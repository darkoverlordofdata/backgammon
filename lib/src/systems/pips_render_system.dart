part of backgammon;
const int BOTTOM = 513;
const int TOP = 39;
const int PIP_SIZE = 42;
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


class PipsRenderSystem extends Artemis.VoidEntitySystem {

  BaseLevel level;
  
  List points = [[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0], // White
                [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0]]; // Red


  List pos = [[
  /**
   *  White
   */
      new Point(COL24, BOTTOM),
      new Point(COL23, BOTTOM),
      new Point(COL22, BOTTOM),
      new Point(COL21, BOTTOM),
      new Point(COL20, BOTTOM),
      new Point(COL19, BOTTOM),
      new Point(COL18, BOTTOM),
      new Point(COL17, BOTTOM),
      new Point(COL16, BOTTOM),
      new Point(COL15, BOTTOM),
      new Point(COL14, BOTTOM),
      new Point(COL13, BOTTOM),
      new Point(COL12, TOP),
      new Point(COL11, TOP),
      new Point(COL10, TOP),
      new Point(COL9, TOP),
      new Point(COL8, TOP),
      new Point(COL7, TOP),
      new Point(COL6, TOP),
      new Point(COL5, TOP),
      new Point(COL4, TOP),
      new Point(COL3, TOP),
      new Point(COL2, TOP),
      new Point(COL1, TOP)
  ],[
  /**
   *  Red
   */
      new Point(COL1, TOP),
      new Point(COL2, TOP),
      new Point(COL3, TOP),
      new Point(COL4, TOP),
      new Point(COL5, TOP),
      new Point(COL6, TOP),
      new Point(COL7, TOP),
      new Point(COL8, TOP),
      new Point(COL9, TOP),
      new Point(COL10, TOP),
      new Point(COL11, TOP),
      new Point(COL12, TOP),
      new Point(COL13, BOTTOM),
      new Point(COL14, BOTTOM),
      new Point(COL15, BOTTOM),
      new Point(COL16, BOTTOM),
      new Point(COL17, BOTTOM),
      new Point(COL18, BOTTOM),
      new Point(COL19, BOTTOM),
      new Point(COL20, BOTTOM),
      new Point(COL21, BOTTOM),
      new Point(COL22, BOTTOM),
      new Point(COL23, BOTTOM),
      new Point(COL24, BOTTOM)
  ]];

  PipsRenderSystem(this.level);


  void initialize() {

    if (DEBUG) print("StarsRenderSystem::initialize");
    Artemis.GroupManager groupManager = level.artemis.getManager(new Artemis.GroupManager().runtimeType);

    Artemis.ComponentMapper<Sprite> spriteMapper = new Artemis.ComponentMapper<Sprite>(Sprite, level.artemis);
    Artemis.ComponentMapper<Number> numberMapper = new Artemis.ComponentMapper<Number>(Number, level.artemis);

    Phaser.Group pips = level.game.add.group();

    groupManager.getEntities(GROUP_PIPS).forEach((entity) {

      Sprite sprite = spriteMapper.get(entity);
      Number number = numberMapper.get(entity);

      int color = sprite.frame & 1; //  white | red
      int point = number.value - 1; //  0..23

      sprite.x = pos[color][point].x;
      switch(pos[color][point].y) {

        case TOP:
          sprite.y = pos[color][point].y + (points[color][point]*PIP_SIZE);
          break;

        case BOTTOM:
          sprite.y = pos[color][point].y - (points[color][point]*PIP_SIZE);
          break;
      }
      points[color][point]++;

      pips.create(sprite.x, sprite.y, sprite.key, sprite.frame);

    });
  }

  void processSystem() {
  }
}
