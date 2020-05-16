import java.io.*;
import processing.core.*;

class  Tile implements Serializable {
  private static final long serialVersionUID = -2502417782988682763L;
  float upChance, downChance, leftChance, rightChance;
  float learnRate;
  Tile(float learnRate) {
    upChance = 2500;
    downChance = 2500;
    leftChance = 2500;
    rightChance = 2500;
    this.learnRate = learnRate*100;
  }

  float getUp() { 
    return upChance;
  }
  float getDown() { 
    return downChance;
  }
  float getLeft() { 
    return leftChance;
  }
  float getRight() { 
    return rightChance;
  }

  void increaseUpChance() {
    //System.out.print("has chance of going up from " + upChance);
    if (upChance < 10000) {
      upChance+=learnRate;
      downChance-=learnRate/3;
      leftChance-=learnRate/3;
      rightChance-=learnRate/3;
    }
    //System.out.print(" to " + upChance);
    //System.out.println();
  }

  void increaseDownChance() {
    //System.out.print("has chance of going up from " + downChance);
    if (downChance < 10000) {
      upChance-=learnRate/3;
      downChance+=learnRate;
      leftChance-=learnRate/3;
      rightChance-=learnRate/3;
    }
    //System.out.print(" to " + downChance);
    //System.out.println();
  }

  void increaseLeftChance() {
    //System.out.print("has chance of going up from " + leftChance);
    if (leftChance < 10000) {
      upChance-=learnRate/3;
      downChance-=learnRate/3;
      leftChance+=learnRate;
      rightChance-=learnRate/3;
    }
    // System.out.print(" to " + leftChance);
    //  System.out.println();
  }

  void increaseRightChance() {
    //  System.out.print("has chance of going up from " + rightChance);
    if (rightChance < 10000) {
      upChance-=learnRate/3;
      downChance-=learnRate/3;
      leftChance-=learnRate/3;
      rightChance+=learnRate;
    }
    //  System.out.print(" to " + rightChance);
    //  System.out.println();
  }
}
