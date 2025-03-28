// SideScroller by haje-aatg (Hans-ChristianBJensen)
// An assignment template for a 2D array containing objects
// Contains no comments, since the student needs to make these
//
// Link: https://github.com/haje-aatg/2DTemplateSideScroller

class Player extends WorldObject {

  int xPos = int(random(4, 59));
  int yPos = 20;
  float angle = 85.0/360*2*PI;
  boolean shootingDirection = false;


  float g = 10; //Tyngdekraften
  float v0 = 40; //Initialhastigheden
  ArrayList<PVector> projectilePositions = new ArrayList<PVector>();
  ArrayList<PVector> projectileTrails = new ArrayList<PVector>();
  boolean isShooting = false;

  Player() {
    super();
    worldObjectColor = color(255, 0, 0);
  }
  Player(boolean tempblocked) {
    super(tempblocked);
    worldObjectColor = color(255, 0, 0);
  }
  void moveForward() {
    print(place + " : " + direction);
    if (int(place.y+direction.y)>0 && int(place.x+direction.x)>0) {
      place.add(direction);
      println(" .Now: " + place);
    }
  }
  void draw() {
    float y0 = 0;
    float y;

    if (angle < 1.53) {
      for (int i = 0; i < 5; i += 1) {

        y = (-g)/(2*pow(v0, 2)*pow(cos(angle), 2))*pow(i, 2)+tan(angle)*i+y0;

        y = round(y / 10.0) * 10;

        y *= -1;

        fill(0);

        draw(i*10+xPos*10, y+yPos*10);
      }
    } else if (angle > 1.60) {
      for (int i = 0; i > -5; i -= 1) {

        y = (-g)/(2*pow(v0, 2)*pow(cos(angle), 2))*pow(i, 2)+tan(angle)*i+y0;

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
    int x = 0;
    float y = 0;

    while (x < 64) {
      if (x+xPos < 64 && x+xPos > 0) {

        y = (-g)/(2*pow(v0, 2)*pow(cos(angle), 2))*pow(x, 2)+abs(tan(angle))*x;

        y = round(y / 10.0) * 10;

        int yIndex = (int) y;
        y *= -1;

        yIndex = yIndex/10;

        if (!shootingDirection) {
          projectilePositions.add(new PVector(x*10+xPos*10, (39-yIndex)*10-(40-yPos)*10));
          if (worldOne[x + xPos][39-yIndex-(40-yPos)].type == "ground" || worldOne[x + xPos][39-yIndex-(40-yPos)].type == "grass") {
            break;
          }
        } else if (shootingDirection) {
          projectilePositions.add(new PVector((64-x*10+xPos*10-65), (39-yIndex)*10-(40-yPos)*10));
          if (worldOne[64-(x + xPos)][39-yIndex-(40-yPos)].type == "ground" || worldOne[64-(x + xPos)][39-yIndex-(40-yPos)].type == "grass") {
            break;
          }
        } else {
          println("something went very wrong with shootingDirection boolean.");
        }

        /*
        try {
         //println("worldOne[x + xPos][39-yIndex-(40-yPos)].type: " + (worldOne[x + xPos][39-yIndex-(40-yPos)].type));
         if (worldOne[x + xPos][39-yIndex-(40-yPos)].type == "ground" || worldOne[x + xPos][39-yIndex-(40-yPos)].type == "grass") {
         break;
         }
         }
         catch (Exception e) {
         println(e);
         }
         */
      }
      x++;
    }
  }
  void action(boolean availableToDoAction) {

    if (downKeys[32]) { // Shoot
      if (availableToDoAction == true && !isShooting) {
        //https://u490079.mono.net/upl/website/about-us111/Formelsamlingtildetskrkast11.pdf

        float y = 0;

        isShooting = true;
        projectilePositions.clear(); // Ryd tidligere projektiler

        shoot();
      } else {
        isShooting = false;
      }
    }



    if (downCodedKeys[38]) {
      angle += 0.01;

      if (angle > 1.52 && angle < 1.54) {
        angle = 1.61;
        shootingDirection = true;
      }
    }
    if (downCodedKeys[40]) {
      angle -= 0.01;

      if (angle > 1.58 && angle < 1.63) {
        angle = 1.52;
        shootingDirection = false;
      }
    }
    if (downCodedKeys[37]) { //Move left
      if (player.xPos-1 >= 0) {
        if (worldOne[player.xPos-1][player.yPos].passable) {
          player.xPos -= 1;
        } else if (worldOne[player.xPos-1][player.yPos-1].passable) {
          player.xPos -= 1;
          player.yPos -= 1;
        }
      }
    }
    if (downCodedKeys[39]) { // Move right
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
