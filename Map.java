import java.io.*;
import processing.core.*;

class Map implements Serializable {
  private static final long serialVersionUID = 8985682531940289659L;
  int mapWidth, mapHeight;
  Tile[][] tiles;

  Map(int mapWidth, int mapHeight, float learnRate) {
    this.mapWidth = mapWidth;
    this.mapHeight = mapHeight;

    tiles = new Tile[mapWidth][mapHeight];

    for (int i = 0; i < mapHeight; i++) {
      for (int k = 0; k < mapWidth; k++) {
        tiles[i][k] = new Tile(learnRate);
      }
    }
  }
}
