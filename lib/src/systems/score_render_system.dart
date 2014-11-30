part of backgammon;


class ScoreRenderSystem extends Artemis.VoidEntitySystem {

  static const SFX_COUNT = 19;

  BaseLevel level;
  Position position;
  Text text;
  Count score;
  List<Phaser.Sound> bonus = [];
  Phaser.Text scoreText;
  bool isCocoon = window.navigator.appVersion.contains("CocoonJS");

  /**
   * Color and position cycles for points popup
   */
  int counter = 0;
  List colors = ["#ff0", "#f0f", "#0ff"];
  List cols = [30, 105, 180];
  List rows = [250, 150, 250];


  ScoreRenderSystem(this.level);

  void initialize() {
    if (DEBUG) print("ScoreRenderSystem::initialize");

    Artemis.ComponentMapper<Position> positionMapper = new Artemis.ComponentMapper<Position>(Position, level.artemis);
    Artemis.ComponentMapper<Count> countMapper = new Artemis.ComponentMapper<Count>(Count, level.artemis);
    Artemis.ComponentMapper<Text> textMapper = new Artemis.ComponentMapper<Text>(Text, level.artemis);

    Artemis.TagManager tagManager = level.artemis.getManager(Artemis.TagManager);
    Artemis.Entity entity = tagManager.getEntity(TAG_SCORE);

    position = positionMapper.get(entity);
    text = textMapper.get(entity);
    score = countMapper.get(entity);
    var style = new Phaser.TextStyle(font: text.font, fill: text.fill);
    scoreText = level.add.text(position.x, position.y, "${text.value}: 0", style);

    for (var i=1; i<=SFX_COUNT+1; i++) {
      bonus.add(level.add.audio("bonus$i"));
    }
    level.game.sound.volume = 0.05; //parent.soundfx;
    level.context.scored.add(updateScore);
  }

  /**
   * Signaled event Update Score
   *
   * Receives the number of points just added to the score
   *
   * return none
   */
  updateScore(int points) {

    scoreText.text = "${text.value}: ${level.context.score}";
    scoreText.updateText();

    // make a popup with the points
    var scoreStyle = new Phaser.TextStyle(font: "bold 120px Courier New, Courier",fill: colors[counter], align: "center");
    Phaser.Text popup = level.add.text(cols[counter], rows[counter], "$points", scoreStyle);
    counter += 1;
    if (counter > 2) counter = 0;

    if (!isCocoon) bonus[points % SFX_COUNT].play();
    const int speed = 1000;
    level.add.tween(popup)
    .to({'alpha': 1}, (speed*0.75).toInt(), Phaser.Easing.Linear.None, true)
    .to({'alpha': 0}, (speed*0.25).toInt(), Phaser.Easing.Linear.None, true);

    new async.Timer(const Duration(milliseconds: speed),
        () => level.world.remove(popup));

  }

  void processSystem() {

  }
}
