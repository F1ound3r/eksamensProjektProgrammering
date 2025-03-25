//  SideScroller by haje-aatg (Hans-ChristianBJensen)
// An assignment template for a 2D array containing objects
// Contains no comments, since the student needs to make these
//
// Link: https://github.com/haje-aatg/2DTemplateSideScroller

class World {
  byte health;
  boolean passable, destructible;
  color worldColor;
  String type;
  PVector place = new PVector(1, 1);

  World() {
    health = 10;
    passable = boolean(round(random(0, 1)));
    if (passable == false) {
      destructible = random(0, 100)>15 ? true : false;

      worldColor = color(214, 146, 43);
    } else {
      worldColor = color(38, 184, 250);
      destructible=false;
    }
  }
  World(String inputType){
   health = 10;
   type = inputType;
   if (inputType == "sky"){
     worldColor = color(38, 184, 250);
     passable = true;
   } else if (inputType == "ground"){
     worldColor = color(124,100,0);
     passable = false;
   } else if (inputType == "grass"){
    worldColor = color(65,210,10); 
    passable = false;
   }
   
  }
  World(int wHeight, int bHeight) {
    health = 10;
    
    passable = false;
    destructible = false;
    worldColor = color(214*(int(destructible)+1)/2, 146, 43);
    
    /*
    if (bHeight<wHeight*0.1) {
      passable = true;
      destructible=false;
      worldColor = color(38, 184, 250);
    } else {
      if (random(0, 100)<40) {
        passable = false;
        destructible = random(0, 100)>15 ? true : false;
        worldColor = color(214*(int(destructible)+1)/2, 146, 43);
      } else {
        passable = true;
        destructible=false;
        worldColor = color(38, 184, 250);
      }
    }
    */
  }
  World(boolean tempblocked) {
    health = 10;
    passable = tempblocked;
    destructible = tempblocked;
  }
  void beenHit(String inputType){
    type = inputType;
   if (inputType == "sky"){
     worldColor = color(38, 184, 250);
     passable = true;
   } else if (inputType == "ground"){
     worldColor = color(124,100,0);
     passable = false;
   } else if (inputType == "grass"){
    worldColor = color(65,210,10); 
    passable = false;
   }
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
  void draw(int tempXdir, int tempYdir, int tempSquaresize) {
    //fill(worldColor, 255*(10-(health%10)));
    fill(worldColor);
    square(tempXdir*tempSquaresize, tempYdir*tempSquaresize, tempSquaresize);
  }
  void draw() {
    fill(worldColor);
    square(place.x*squaresize, place.y*squaresize, squaresize);
  }
  void attacked(byte tdamage) {
    if (destructible) {
      health-=tdamage;
    }
    if (isDead()) {
      passable = true;
      destructible=false;
      worldColor = color(38, 184, 250);
    }
    println("Attacked World. Destructible: "+destructible+". Health left: " + health);
  }
  boolean isDead() {
    if (health>0) {
      return false;
    } else {
      return true;
    }
  }
}
