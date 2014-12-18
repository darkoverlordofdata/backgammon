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


class CheckerRenderSystem extends Artemis.VoidEntitySystem {

  BaseLevel level;
  int ig = 0;
  int pc = 0;
  bool started = false;
  int paused = 0;
  int player = -1;
  BgmMatch match;
  String title;

  Phaser.Text desc;

  List points = [[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0], // White
                [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0]]; // Red


  List<String> files = [
      "Hayashi-TJ_5_point_match_2014-11-03_1414994215.txt",
      "kitaji-TJ_5_point_match_2014-11-03_1414994046.txt",
      "michy-Henrik_11_point_match_2014-11-02_1415106962.txt",
      "Robin_Swaffield-Michael_Dyett_17_point_match_10-15-2014_1413453261_1413735530.txt"
  ];
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

  CheckerRenderSystem(this.level);


  void initialize() {

    if (DEBUG) print("CheckerRenderSystem::initialize");
    Artemis.GroupManager groupManager = level.artemis.getManager(new Artemis.GroupManager().runtimeType);

    Artemis.ComponentMapper<Sprite> spriteMapper = new Artemis.ComponentMapper<Sprite>(Sprite, level.artemis);
    Artemis.ComponentMapper<Number> numberMapper = new Artemis.ComponentMapper<Number>(Number, level.artemis);

    Phaser.Group pips = level.game.add.group();

    groupManager.getEntities(GROUP_CHECKERS).forEach((entity) {

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

    String file = files[level.random.nextInt(4)];
    title = file
    .replaceAll(new RegExp(r"\.txt$"), "")
    .replaceAll(new RegExp(r"_\d+$"), "")
    .replaceAll(new RegExp(r"_\d+$"), "")
    .replaceAll("_", " ")
    .trim();


    print("FILE = |$file|");
    print("title = |$title|");

    HttpRequest.getString("packages/backgammon/res/matches/$file")
    .then((String data) {

      var normal = new Phaser.TextStyle(font: "12pt Play", fill: "#000");
      match = new BgmMatch();
      match.parse(data);

      document.title = "${match.variation} - [$title]";
      level.game.add
//        ..text(0, 0, "${m.event} - ${m.eventDate}", new Phaser.TextStyle(font: "16pt Play", fill: "#000"))
        //..text(05, 570, "${title}", new Phaser.TextStyle(font: "10pt Play", fill: "#000"))
        ..text(COL24, 15, match.player1, normal)
        ..text(COL24, 570, match.player2, normal);

      desc = level.game.add.text(0, 0, "", normal);

      ig = 0; // Game counter
      pc = 0; // Turn counter
      paused = 0;
      player = 0;
      started = true;
    });
  }

  void processSystem() {
    if (!started) return;
    if (paused > 0) {
      paused--;
      return;
    }

    document.title = "${match.variation} - [$title] ${ig+1}/${match.games.length}";

    /**
     * Next Game?
     */
    if (pc >= match.games[ig].turns.length) {
      ig++;
      pc = 0;
      player = 0;
    }

    /**
     * All Done?
     */
    if (ig >= match.games.length) {
      started = false;
      print("DONE");
      started = false;
      return;
    }

    /**
     * Display the turn
     */
    BgmTurn turn = match.games[ig].turns[pc][player];
//    print("player $player => $turn");

    String s = "Player: ${player+1} Roll: ${turn.die1}/${turn.die2} Move: ${turn.move}";
    desc.text = s.padRight(80);
    desc.updateText();
    if (turn.die1 | turn.die2 != 0) {


    }


    /**
     * Next Move...
     */
    player++;
    if (player == 2) {
      player = 0;
      pc++;
    }
    paused = 100;
  }
}
