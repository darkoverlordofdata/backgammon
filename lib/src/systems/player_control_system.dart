part of backgammon;

class PlayerControlSystem extends Artemis.VoidEntitySystem {

  BaseLevel level;
  List<List<Phaser.Sprite>> die = [[],[]];
  List<List<Phaser.Sprite>> pip = [[],[]];
  int rate = 0;

  PlayerControlSystem(this.level);


  /**
   * Initialize player control
   */
  void initialize() {
    if (DEBUG) print("PlayerControlSystem::initialize");

    Artemis.GroupManager groupManager = level.artemis.getManager(new Artemis.GroupManager().runtimeType);
    Artemis.ComponentMapper<Sprite> spriteMapper = new Artemis.ComponentMapper<Sprite>(Sprite, level.artemis);
    Artemis.ComponentMapper<Player> playerMapper = new Artemis.ComponentMapper<Player>(Player, level.artemis);
    Artemis.ComponentMapper<Count> countMapper = new Artemis.ComponentMapper<Count>(Count, level.artemis);
    Artemis.ComponentMapper<Number> numberMapper = new Artemis.ComponentMapper<Number>(Number, level.artemis);

    groupManager.getEntities(GROUP_DICE).forEach((entity) {

      Sprite sprite = spriteMapper.get(entity);
      Player player = playerMapper.get(entity);
      Count count = countMapper.get(entity);
      Number number = numberMapper.get(entity);

      Phaser.Sprite s = level.add.sprite(sprite.x, sprite.y, sprite.key, player.value * 7);
      s.alpha = 0;
      die[player.value].add(s);

      s = level.add.sprite(sprite.x, sprite.y, sprite.key, player.value * 7 + level.random.nextInt(6)+1);
      s.alpha = 0;
      pip[player.value].add(s);

    });


  }

  void processSystem() {

    rate = (rate+1)%10;
    if (rate != 0) return;


    int player = level.context.player;
    int other = (player+1)&1;

    /**
     * Hide the other players dice
     */
    die[other][0].alpha = 0;
    die[other][1].alpha = 0;
    pip[other][0].alpha = 0;
    pip[other][1].alpha = 0;

    if (level.context.getDie(player, 0) == 0) {
      /**
       * Hide the players dice
       */
      die[player][0].alpha = 0;
      die[player][1].alpha = 0;
      pip[player][0].alpha = 0;
      pip[player][1].alpha = 0;
    } else {
      /**
       * Show the players dice
       */
      die[player][0].alpha = 1;
      die[player][1].alpha = 1;
      pip[player][0].alpha = 1;
      pip[player][1].alpha = 1;
      if (level.context.rolling) {
        pip[player][0].frame = level.random.nextInt(6)+1;
        pip[player][1].frame = level.random.nextInt(6)+1;
      } else {
        pip[player][0].frame = level.context.getDie(player, 0);
        pip[player][1].frame = level.context.getDie(player, 1);
      }
    }
  }
}
