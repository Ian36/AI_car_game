import java.io.*;

//AI self learning car game. The objective of the game is to reach from the
//start point to the end point. There are several variables to adjust which
//will determine how well the machine will develop the map. Tweaking these
//variables will determine the accurancy and efficiency of this program.
//The main variables are:

//epochSize - This variable determines the number of cars per test. Increasing
//this will allow for a larger sample of data per test, however it will require
//more memory per test.

//learnRate - This variable determines the rate at which the map will learn. A
//more accurate result can be achieved by decreasing the learn rate, however this
//will require more tests to train the map. A higher learn rate will train the map
//faster, however it may result in inaccurate results. It is best to find a
//balance of both.

//driveDistance - The distance of each step for the car. Only use a distance that is
//a factor of the distance between the start and end point (i.e if the distance 
//between start and end point is 100, suitable driveDistance includes: 1, 2, 4, 5, 10,
//and so on).

//endTime - The variable determines to time in milliseconds for each test. A longer 
//timeframe will train the map much quicker, however, it may produce inaccurate results.
//The car travels one driveDistance per millisecond. In order for the game to be possible,
//use a minimum time of the distance between the start and end point (i.e if the distance 
//between start and end point is 100, a minimum endTime would be 100 for the game to be
//possible).

//The tests will autosave at every 100 runs and files can be found in the processing
//directory called Map.txt and RunCount.txt

//SETTINGS
//Start and end points
final int startX = 100;
final int startY = 400;
final int endX = 700;
final int endY = 400;

//Map dimensions
final int mapWidth = 800;
final int mapHeight = 800;

//Test settings (adjust these to get the most accurate and efficient results)
final int epochSize = 100; //Number of cars per test
final float learnRate = 0.1; //percentage rate at which the program learns
final int driveDistance = 10; //distance per step
final int endTime = 62; //Time of each test

////////////////////////////////////////////////////

int time, run;
int hitCount = 0;
Point startPoint, endPoint;
Map map;
Car[] cars;

void settings() {
  size(mapWidth, mapHeight);
}

void setup() {
  endPoint  = new Point(endX, endY);
  startPoint  = new Point(startX, startY);
  run = 1;
  time = 0;
  try {
    loadMap();
  } 
  catch(FileNotFoundException e) {
    System.out.println(e + "\nCreating new map...");
    map = new Map(mapWidth, mapHeight, learnRate);
  }
  catch(IOException e) {
    System.out.println(e + "\nCreating new map...");
    map = new Map(mapWidth, mapHeight, learnRate);
  }
  catch(ClassNotFoundException e) {
    System.out.println(e + "\nCreating new map...");
    map = new Map(mapWidth, mapHeight, learnRate);
  }
  
  cars = new Car[epochSize];
  for (int i = 0; i < cars.length; i++) {
    cars[i] = new Car(randomColor(), startX, startY);
  }
}

void draw() {
  background(255);
  drawInfo();
  fill(255);
  fill(color(255, 0, 0));
  startPoint.drawPoint();
  fill(color(0, 255, 0));
  endPoint.drawPoint();
  for (Car car : cars) {
    if (car.active) {
      car.drive(calculateDirection(map, car.pos));
      if (car.pos.xPos == endX && car.pos.yPos == endY) {
        car.active = false;
        System.out.println("Made it");
        hitCount++;
      }
    }
    car.drawCar();
  }

  //for (int i = 0; i < mapHeight; i++) {
  //  for (int k = 0; k < mapWidth; k++) {
  //    if (map.tiles[i][k].rightChance > map.tiles[i][k].leftChance && map.tiles[i][k].rightChance > map.tiles[i][k].upChance &&map.tiles[i][k].rightChance > map.tiles[i][k].downChance) {
  //      fill(0, 255, 0);
  //      ellipseMode(CENTER);
  //      ellipse(i, k, 5, 5);
  //    }
  //  }
  //}

  if (time == endTime) {
    if (hitCount > 0) {
      System.out.println("Hit Count: " + hitCount);
    }
    updateTileChance();
    resetAllCarPositions();
    time = 0;
    run++;
    hitCount = 0;
  }
  try {
    if (run % 100 == 0 && time == 0) {
      saveMap();
    }
  } 
  catch(FileNotFoundException e) {
    System.out.println(e);
  }
  catch(IOException e) {
    System.out.println(e);
  }
  catch(ClassNotFoundException e) {
    System.out.println(e);
  }
}

void saveMap() throws FileNotFoundException, IOException, ClassNotFoundException {
  System.out.println("AutoSaving map at run: " + run);
  ObjectOutputStream out = new ObjectOutputStream(new FileOutputStream("Map.txt"));
  out.writeObject(map);
  out.close();

  DataOutputStream dos = new DataOutputStream(new FileOutputStream("RunCount.txt"));
  dos.writeInt(run);
  dos.close();
  System.out.println("Save map at run: " + run + " complete");

}

void loadMap() throws FileNotFoundException, IOException, ClassNotFoundException {
  System.out.println("Loading map...");
  ObjectInputStream in = new ObjectInputStream(new FileInputStream("Map.txt"));
  map = (Map)in.readObject();
  in.close();
  
  System.out.println("Loading run...");
  DataInputStream dis = new DataInputStream(new FileInputStream("RunCount.txt"));
  run = dis.readInt();
  dis.close();
}

//boolean hasCrashed(Car car) {
//  if (car.pos.xPos - driveDistance < 0 ||
//    car.pos.xPos + driveDistance >= map.mapWidth ||
//    car.pos.yPos - driveDistance < 0 ||
//    car.pos.yPos + driveDistance >= map.mapHeight) {
//    car.active = false;
//  }
//  return !car.active;
//}

void updateTileChance() {
  Car bestCar = null;
  float shortestDistance = Float.MAX_VALUE;
  for (Car car : cars) {
    //System.out.println("Distance of car to point: " + dist(car.pos.xPos, car.pos.yPos, endX, endY));
    if (dist(car.pos.xPos, car.pos.yPos, endX, endY) < shortestDistance) {
      bestCar = car;
      shortestDistance = dist(car.pos.xPos, car.pos.yPos, endX, endY);
    }
  }
  System.out.println("Run: " + run);
  System.out.println("Best car position: " + bestCar.pos.xPos + " " + bestCar.pos.yPos);
  System.out.println("Distance to endpoint: " + dist(bestCar.pos.xPos, bestCar.pos.yPos, endX, endY));


  for (int i = 0; i < bestCar.route.size(); i++) {
    //    System.out.println("Tile " + bestCar.route.get(i).xPos + " " + bestCar.route.get(i).yPos);
    if (bestCar.direction.get(i).equals("up")) {
      map.tiles[bestCar.route.get(i).xPos][bestCar.route.get(i).yPos].increaseUpChance();
    }
    if (bestCar.direction.get(i).equals("down")) {
      map.tiles[bestCar.route.get(i).xPos][bestCar.route.get(i).yPos].increaseDownChance();
    }
    if (bestCar.direction.get(i).equals("left")) {
      map.tiles[bestCar.route.get(i).xPos][bestCar.route.get(i).yPos].increaseLeftChance();
    }
    if (bestCar.direction.get(i).equals("right")) {
      map.tiles[bestCar.route.get(i).xPos][bestCar.route.get(i).yPos].increaseRightChance();
    }
  }
}

void drawInfo() {
  fill(0);
  textFont(createFont("Arial", 16, true));       
  text("Run: " + run, 50, 50);
  text("Time(ms): " + time, 50, 75);

  //System.out.println("Run: " + run);
  //System.out.println("Time(ms): " + time);

  time++;
}

void resetAllCarPositions() {
  for (int i = 0; i < cars.length; i++) {
    cars[i].setPos(startX, startY);
    cars[i].active = true;
    cars[i].direction.clear();
    cars[i].route.clear();
  }
}

color randomColor() {
  return color(random(0, 255), random(0, 255), random(0, 255));
}

String calculateDirection(Map map, Point currentPos) { 
  //System.out.println("Calculating direction for point " + currentPos.xPos + " " +currentPos.yPos);
  float upThreshold = 
    map.tiles[currentPos.xPos][currentPos.yPos].getUp();

  float downThreshold = 
    map.tiles[currentPos.xPos][currentPos.yPos].getUp() + 
    map.tiles[currentPos.xPos][currentPos.yPos].getDown();

  float leftThreshold = 
    map.tiles[currentPos.xPos][currentPos.yPos].getUp()+
    map.tiles[currentPos.xPos][currentPos.yPos].getDown()+
    map.tiles[currentPos.xPos][currentPos.yPos].getLeft();


  //System.out.println(upThreshold + " " + downThreshold + " " + leftThreshold);
  float direction = random(10000);
  // System.out.println("Number is: " + direction);
  if (direction < upThreshold) {
    return "up";
  }
  if (direction >= upThreshold && direction < downThreshold) {
    return "down";
  }
  if (direction >= downThreshold && direction < leftThreshold) {
    return "left";
  } else {
    return "right";
  }
}

class Car {
  boolean active;
  color c;
  Point pos;
  ArrayList<String> direction = new ArrayList<String>();
  ArrayList<Point> route = new ArrayList<Point>();

  Car(color tempC, int xPos, int yPos) {
    active = true;
    c = tempC;
    this.pos = new Point(xPos, yPos);
  }

  void drawCar() {
    stroke(0);
    fill(c);
    rectMode(CENTER);
    rect(pos.xPos, pos.yPos, 10, 10);
  }

  void drive(String direction) {

    if (direction.equals("up") && (pos.yPos-driveDistance) >= 0) { 
      //System.out.println("We are going up");
      this.route.add(new Point(pos.xPos, pos.yPos));
      this.direction.add(direction);
      pos.yPos-=driveDistance;
    }
    if (direction.equals("down") && (pos.yPos+driveDistance) < map.mapHeight) { 
      //System.out.println("We are going down");
      this.route.add(new Point(pos.xPos, pos.yPos));
      this.direction.add(direction);
      pos.yPos+=driveDistance;
    }
    if (direction.equals("left") && (pos.xPos-driveDistance) >= 0) { 
      //System.out.println("We are going left");
      this.route.add(new Point(pos.xPos, pos.yPos));
      this.direction.add(direction);
      pos.xPos-=driveDistance;
    }
    if (direction.equals("right") && (pos.xPos+driveDistance) < map.mapWidth) { 
      //System.out.println("We are going right");
      this.route.add(new Point(pos.xPos, pos.yPos));
      this.direction.add(direction);
      pos.xPos+=driveDistance;
    }
    //System.out.println("New Position: " + pos.xPos + " " + pos.yPos);
  }

  void setPos(int xPos, int yPos) {
    this.pos.xPos = xPos;
    this.pos.yPos = yPos;
  }
}

class Point {
  int xPos, yPos;

  Point(int xPos, int yPos) {
    this.xPos = xPos;
    this.yPos = yPos;
  }

  float getXPos() {
    return xPos;
  }

  float getYPos() {
    return yPos;
  }

  void setXPos(int xPos) {
    this.xPos = xPos;
  }

  void setYPos(int yPos) {
    this.yPos = yPos;
  }

  void drawPoint() {
    point(xPos, yPos);
    ellipseMode(CENTER);
    ellipse(xPos, yPos, 20, 20);
  }
}
