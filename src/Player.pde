// SideScroller by haje-aatg (Hans-ChristianBJensen)
// An assignment template for a 2D array containing objects
// Contains no comments, since the student needs to make these
//
// Link: https://github.com/haje-aatg/2DTemplateSideScroller

class Player extends WorldObject {

  int xPos = int(random(4, 59));
  int yPos = 20;
  float angle = 85.0/360*2*PI;



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

    

    if (abs(angle) < PI/2) {
      for (int i = 0; i < 5; i += 1) {

        y = (-g)/(2*pow(v0, 2)*pow(cos(angle), 2))*pow(i, 2)+tan(angle)*i+y0;

        y = round(y / 10.0) * 10;

        y *= -1;


        fill(0);
        //println(angle);
        //println(y);
        draw(i*10+xPos*10, y+yPos*10);
      }
    } else if (abs(angle) > PI*1.5) {

      angle = -PI*0.5;
    } else if (abs(angle) > PI/2) {
      for (int i = 0; i > -5; i -= 1) {

        y = (-g)/(2*pow(v0, 2)*pow(cos(angle), 2))*pow(i, 2)+tan(angle)*i+y0;

        y *= -1;

        y = round(y / 10.0) * 10;

        //println(angle);

        //println(y);
        draw(i*10+xPos*10, y+yPos*10);
      }
    }


    fill(worldObjectColor);
    if (worldOne[player.xPos][player.yPos].type != "sky") {
      player.yPos -= 1;
    }
    square(player.xPos*squaresize, player.yPos*squaresize, squaresize);
  }
  void draw(float x, float y) {
    square(x, y, 10);
  }
  void action(boolean availableToDoAction) {

    if (downKeys[32]) { // Shoot
      if (availableToDoAction == true && !isShooting) {
        //https://u490079.mono.net/upl/website/about-us111/Formelsamlingtildetskrkast11.pdf

        float y = 0;

        isShooting = true;
        projectilePositions.clear(); // Ryd tidligere projektiler
        int x = 0;
        while (x < 64) {

          if (x+xPos < 64) {
            println("top");
            println(40-yPos);
            println(y);
            println(heightMap[x+xPos]);

            if (y > heightMap[x+xPos]-1) {
              break;
            }

            y = (-g)/(2*pow(v0, 2)*pow(cos(angle), 2))*pow(x, 2)+abs(tan(angle))*x;

            y = round(y / 10.0) * 10;

            y *= -1;
          }


          projectilePositions.add(new PVector(x*10+xPos*10, y+yPos*10));

          x++;
        }
        /*
        for (int i = 0; i < 40; i += 1) {
         
         y = (-g)/(2*pow(v0, 2)*pow(cos(angle), 2))*pow(i, 2)+abs(tan(angle))*i+y0;
         
         y *= -1;
         
         projectilePositions.add(new PVector(i*10+xPos*10+10/2, y+yPos*10+10/2));
         }
         */
      } else {
        isShooting = false;
      }
    }
    if (downCodedKeys[38]) {
      angle += 0.01;
    }
    if (downCodedKeys[40]) {
      angle -= 0.01;
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
