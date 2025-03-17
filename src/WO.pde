//  SideScroller by haje-aatg (Hans-ChristianBJensen)
// An assignment template for a 2D array containing objects
// Contains no comments, since the student needs to make these
// 
// Link: https://github.com/haje-aatg/2DTemplateSideScroller

class WorldObject {
  byte squaresize, health;
  //boolean running = true;
  PVector place = new PVector(1, 1);
  PVector direction = new PVector(1, 0);  //float xdir, ydir;
  boolean passable, destructible;
  color worldObjectColor;

  WorldObject() {
    squaresize = 10;
    health = byte(random(10, 20));
    passable = boolean(round(random(0, 1)));
    
    
    
    if (passable == false) {
      worldObjectColor = color(214, 146, 43);
      destructible = boolean(round(random(0, 1)));
    } else {
      worldObjectColor = color(38, 184, 250);
      destructible=false;
    }
  }
  WorldObject(boolean tempblocked) {
    squaresize = 10;
    health = byte(random(10, 20));
    passable = tempblocked;
    destructible = tempblocked;
  }
  WorldObject(boolean tempblocked,PVector tempPlace, color tempWorldObjectColor) {
    squaresize = 10;
    health = byte(random(10, 20));
    place = tempPlace;
    worldObjectColor = tempWorldObjectColor;
    passable = tempblocked;
    destructible = tempblocked;
  }
  boolean falling(boolean tpassable) {
    //println(tpassable);
    if (tpassable) {
      place.add(new PVector(0, 1));
      return true;
    } else {
      return false;
    }
  }
  void draw() {
    fill(worldObjectColor);
    square(place.x*squaresize, place.y*squaresize, squaresize);
  }
  void attacked(byte tdamage) {
    if (destructible) {
      health-=tdamage;
    }
    println("Attacked WO. Health left: " + health);
  }
  boolean isDead() {
    if (health>0) {
      return false;
    } else {
      return true;
    }
  }
}
