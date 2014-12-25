part of backgammon;

class PlayerControlSystem extends Artemis.VoidEntitySystem {

  static const REPLAY_DELAY = 500;
  
  BaseLevel level;
  Context context;
  List<List<Phaser.Sprite>> die = [[],[]];
  List<List<Phaser.Sprite>> pip = [[],[]];
  int rate = 0;
  int wait = 0;
  int rolling = 0;
  int domove = 400;
  Phaser.Text desc;

  /**
   * pre-recorded matches
   */
  List<String> files = [
      "Hayashi-TJ_5_point_match_2014-11-03.txt",
      "kitaji-TJ_5_point_match_2014-11-03.txt",
      "michy-Henrik_11_point_match_2014-11-02.txt",
      "Robin_Swaffield-Michael_Dyett_17_point_match_10-15-2014.txt"
  ];


  PlayerControlSystem(this.level);


  /**
   * create the dice
   */
  void initialize() {
    if (DEBUG) print("PlayerControlSystem::initialize");

    context = level.context;

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

      Phaser.Sprite s;

      /**
       * Blank die background
       */
      s = level.add.sprite(sprite.x, sprite.y, sprite.key, player.value * 7);
      s.alpha = 0;
      die[player.value].add(s);

      /**
       * just the dots
       */
      s = level.add.sprite(sprite.x, sprite.y, sprite.key, player.value * 7 + level.random.nextInt(6)+1);
      s.alpha = 0;
      pip[player.value].add(s);

    });
    desc = level.game.add.text(0, 0, "", context.normal);
//    String file = files[level.random.nextInt(4)];
    String file = files[3];
    context.title = file.replaceAll(new RegExp(r"\.txt$"), "").replaceAll("_", " ");

    HttpRequest.getString("packages/backgammon/res/matches/$file")
    .then((String data) {

      /**
       * Pre-recorded match
       */
      context.match.parse(data);

      document.title = "${context.match.variation} - [${context.title}]";
      level.game.add
        ..text(COL24, TEXT_TOP, context.match.player1, context.normal)
        ..text(COL24, TEXT_BOTTOM, context.match.player2, context.normal);

    });

    level.context.action.add(onClick);
  }

  /**
   * Button onclick event
   */
  onClick(String name) {
    switch(name) {

    /**
     * Start new game
     */
      case 'start':
        wait = 0;
        context.game = 0;
        context.turn = 0;
        context.player = (context.match.games[context.game].turns[0][0].die1 != 0) ? 0 : 1;
        context.isRunning = true;
        break;

    /**
     * Next move
     */
      case 'next':
        wait = 0;
        context.isRunning = true;
        break;
    }
  }

  /**
   * Process the players turn
   */
  void processSystem() {
    if (!context.isRunning) return;

    int player = context.player;
    int other = (player+1)&1;
    Phaser.Sprite checker;

    wait = (wait+1)%REPLAY_DELAY;

    if (wait == 1) {
      if (context.turn < context.match.games[context.game].turns.length) {

        document.title = "${context.match.variation} - [${context.title}] ${context.game + 1}/${context.match.games.length}";
        /**
         * Display this turn
         */
        BgmTurn turn = context.match.games[context.game].turns[context.turn][context.player];
        desc.text = "Player: ${context.player} Roll: ${turn.die1}/${turn.die2} Move: ${turn.move}".padRight(80);
        desc.updateText();
        context.isRolling = true;
        context.setDie(turn.die1, turn.die2);
        rolling = level.random.nextInt(REPLAY_DELAY * .2) + 20;

        /**
         * Hide the other players dice
         */
        die[other][0].alpha = 0;
        die[other][1].alpha = 0;
        pip[other][0].alpha = 0;
        pip[other][1].alpha = 0;
        if (context.getDie(0) == 0) {
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
        }
      }
    }

    if (wait < rolling) {
      /**
       * Rolling the die...
       */
      pip[player][0].frame = level.random.nextInt(6)+1;
      pip[player][1].frame = level.random.nextInt(6)+1;
    } else if (wait == rolling) {
      /**
       * Now think...
       */
      context.isRolling = false;
      pip[player][0].frame = context.getDie(0);
      pip[player][1].frame = context.getDie(1);
    } else if (wait == domove) {
      /**
       * Play the move
       */
      BgmTurn turn = context.match.games[context.game].turns[context.turn][context.player];
      if (turn != null) {

        turn.moves.forEach((BgmMove move) {
          window.console.log(move);
          if (move.blot) {
            /**
             * We hit the other player!
             */
            checker = context.board[other][25-move.dest].removeLast();
            context.board[other][POINT_BAR].add(checker);
            checker.alpha = 0;
          }

          checker = context.board[player][move.source].removeLast();
          checker.x = context.pos[player][move.dest].x;
          switch(context.pos[player][move.dest].y) {

            case TOP:
              checker.y = context.pos[player][move.dest].y + (context.board[player][move.dest].length*PIP_SIZE);
              break;

            case BOTTOM:
              checker.y = context.pos[player][move.dest].y - (context.board[player][move.dest].length*PIP_SIZE);
              break;
          }

          context.board[player][move.dest].add(checker);


        });
      }
    }

    if (wait == 0) {

      context.isRunning = false;
      /**
       * Next Game?
       */
      if (context.turn >= context.match.games[context.game].turns.length) {
        context.game++;
        if (context.game >= context.match.games.length) {
          context.isRunning = false;
          print("DONE");
          return;
        }
        context.turn = 0;
        context.player = (context.match.games[context.game].turns[0][0].die1 != 0) ? 0 : 1;
      }
      /**
       * Next player/turn
       */
      if (context.player == 0) {
        context.player = 1;
      } else {
        context.player = 0;
        context.turn++;
      }

    }
  }
}
