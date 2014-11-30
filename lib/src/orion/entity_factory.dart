part of backgammon;

class EntityFactory  {

  BaseLevel level;
  Artemis.GroupManager groupManager;
  Artemis.TagManager tagManager;

  EntityFactory(this.level) {

    tagManager = new Artemis.TagManager();
    level.artemis.addManager(tagManager);

    groupManager = new Artemis.GroupManager();
    level.artemis.addManager(groupManager);

  }

  ButtonEntity button(int x, int y, String key, String state)
    => new ButtonEntity(this, x, y, key, state);

  GemEntity gem(int x, int y, String key, int range)
    => new GemEntity(this, x, y, key, range);

  ImageEntity image(int x, int y, String key, [double opacity=1])
    => new ImageEntity(this, x, y, key, opacity);

  InputEntity input(int x, int y, String key, String action)
    => new InputEntity(this, x, y, key, action);

  LegendEntity legend(int x, int y, String key, int frame, double opacity)
    => new LegendEntity(this, x, y, key, frame, opacity);

  PlayerEntity player(int x, int y, String key, Map cells)
    => new PlayerEntity(this, x, y, key, cells);

  ScoreEntity score(int x, int y, String text, String font, String fill)
    => new ScoreEntity(this, x, y, text, font, fill);

  StringEntity string(int x, int y, String name, String font, String fill)
    => new StringEntity(this, x, y, name, font, fill);

  /**
   * Mirrors aren't stable in compiled js,
   * so we do this the old-fashioned way.
   */
  AbstractEntity invoke(String methodName, List args) {
    switch(methodName) {
      case 'button':      return Function.apply(button, args);
      case 'gem':        return Function.apply(gem, args);
      case 'image':       return Function.apply(image, args);
      case 'input':       return Function.apply(input, args);
      case 'legend':      return Function.apply(legend, args);
      case 'player':      return Function.apply(player, args);
      case 'score':       return Function.apply(score, args);
      case 'string':      return Function.apply(string, args);
      default:            return null;
    }
  }

}