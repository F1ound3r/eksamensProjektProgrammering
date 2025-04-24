// SideScroller by haje-aatg (Hans-ChristianBJensen)
// An assignment template for a 2D array containing objects
// Contains no comments, since the student needs to make these
//
// Link: https://github.com/haje-aatg/2DTemplateSideScroller

class Player extends WorldObject {

  int xPos = int(random(4, 59)); // Spawns the player in a random position.
  int yPos = 20; // Spawns the player well above the surface.
  float angle = 85.0/360*2*PI;
  boolean shootingDirection = false; // Sets the shooting direction to right.

  float g = 10; // Gravity
  float v0 = 40; // The intial speed
  ArrayList<PVector> projectilePositions = new ArrayList<PVector>();

  Player() { // Player constructor.
    super(); // Runs the WorldObject constructor. 
    worldObjectColor = color(255, 0, 0);
  }
  
  void draw() {
    float y;

    if (angle < 1.53) {
      for (int i = 0; i < 5; i += 1) {

        y = (-g)/(2*pow(v0, 2)*pow(cos(angle), 2))*pow(i, 2)+tan(angle)*i;

        y = round(y / 10.0) * 10;

        y *= -1;

        fill(0);

        draw(i*10+xPos*10, y+yPos*10);
      }
    } else if (angle > 1.60) {

      for (int i = 0; i > -5; i -= 1) {

        y = (-g)/(2*pow(v0, 2)*pow(cos(angle), 2))*pow(i, 2)+tan(angle)*i;

        y *= -1;

        y = round(y / 10.0) * 10;

        //println(angle);

        //println(y);
        draw(i*10+xPos*10, y+yPos*10);
      }
    } else {
      println("Something is very wrong in drawing intial shot");
    }


    fill(worldObjectColor);
    if (worldOne[player.xPos][player.yPos].type != "sky") {
      player.yPos -= 1;
    }
    square(player.xPos*squaresize, player.yPos*squaresize, squaresize);
  }
  void draw(float x, float y) {
    fill(0);
    square(x, y, 10);
  }
  void shoot() {
    //https://u490079.mono.net/upl/website/about-us111/Formelsamlingtildetskrkast11.pdf
    int x = 0;
    float y = 0;

    while (x < 64) {
      if (x+xPos < 64 && !shootingDirection || -x+xPos > -1 && shootingDirection) {

        y = (-g)/(2*pow(v0, 2)*pow(cos(angle), 2))*pow(x, 2)+abs(tan(angle))*x;

        y = round(y / 10.0) * 10;

        int yIndex = (int) y;
        y *= -1;

        yIndex = yIndex/10;

        if (!shootingDirection) {
          projectilePositions.add(new PVector(x*10+xPos*10, (39-yIndex)*10-(40-yPos)*10));
          try {
            if (worldOne[x + xPos][39-yIndex-(40-yPos)].type != "sky") {
              //if (worldOne[x + xPos][39-yIndex-(40-yPos)].type == "ground" || worldOne[x + xPos][39-yIndex-(40-yPos)].type == "grass") {
              break;
            }
          }
          catch (Exception e) {
            println(e);
            break;
          }
        } else if (shootingDirection) {
          //projectilePositions.add(new PVector((64-x*10+xPos*10-65), (39-yIndex)*10-(40-yPos)*10));
          projectilePositions.add(new PVector(((-x+xPos)*10), ((39-yIndex)-(40-yPos))*10));
          try {
            if (worldOne[-x + xPos][39-yIndex-(40-yPos)].type != "sky") {
              break;
            }
          }
          catch (Exception e) {
            println(e);

            break;
          }
        } else {
          println("something went very wrong with shootingDirection boolean.");
        }
      }
      x++;
    }
  }
  void action(boolean availableToDoAction) {

    if (downKeys[32]) { // 32 = Space
      if (availableToDoAction == true) {
        projectilePositions.clear(); // Ryd tidligere projektiler
        shoot();
      } 
    }

    if (downCodedKeys[38]) { // 38 = up arrow.
      angle += 0.01;

      if (angle > 1.52 && angle < 1.54) {
        angle = 1.62;
        shootingDirection = true;
      }
    }
    if (downCodedKeys[40]) { // 40 = down arrow.
      angle -= 0.01;

      if (angle > 1.58 && angle < 1.63) {
        angle = 1.52;
        shootingDirection = false;
      }
    }
    if (downCodedKeys[37]) { // 37 = left arrow. Therefore moves left
      if (player.xPos-1 >= 0) {
        if (worldOne[player.xPos-1][player.yPos].passable) {
          player.xPos -= 1;
        } else if (worldOne[player.xPos-1][player.yPos-1].passable) {
          player.xPos -= 1;
          player.yPos -= 1;
        }
      }
    }
    if (downCodedKeys[39]) { // 39 = right arrow. Therefore moves right.
      if (player.xPos < worldOne.length-1) {
        if (worldOne[player.xPos+1][player.yPos].passable) {
          player.xPos += 1;
        } else if (worldOne[player.xPos+1][player.yPos-1].passable) {
          player.xPos += 1;
          player.yPos -= 1;
        }
      }
    }
  }
}
