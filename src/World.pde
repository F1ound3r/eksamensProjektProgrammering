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

  World(String inputType) { // Constructor that takes the objects ty
    health = 10;
    type = inputType;
    if (inputType == "sky") {
      worldColor = color(38, 184, 250);
      passable = true;
    } else if (inputType == "ground") {
      worldColor = color(124, 100, 0);
      passable = false;
    } else if (inputType == "grass") {
      worldColor = color(65, 210, 10);
      passable = false;
    } else if (inputType == "goal") {
      worldColor = color(255, 255, 0);
      passable = false;
    }
  }
  void beenHit(String inputType) {
    // Firstly checks if the original type was a goal, because that needs to be noted.
    if (type == "goal") {
      amountOfGoalsLeft -= 1;
    }
    // When that has been noted the changing of the type can resume.
    // New if statement because the code above has to be run every time if its a goal, and the code below.

    if (type != "sky") { // Making sure sky objects are not made to sky objects again. 
    // Also implemented the posibility to have different kinds of ammo that regenerate soil again. 
    // Thats the reason for checking the inputType and not just making it sky.
      type = inputType;
      if (inputType == "sky") {
        worldColor = color(38, 184, 250);
        passable = true;
      }
      // Make else if statements here to spawn other objects. 
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
}
