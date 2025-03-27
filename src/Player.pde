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

            y = (-g)/(2*pow(v0, 2)*pow(cos(angle), 2))*pow(x, 2)+abs(tan(angle))*x;

            y = round(y / 10.0) * 10;

            y *= -1;

            println("top");
            println("40-yPos: " + (40-yPos));
            println("y: " + y);

            int yIndex = (int) y;
            //yIndex *= -1;
            yIndex = yIndex/10;

            for (int i = 39; i >= 0; i--) {
              println(x+xPos);
              println(yIndex);
              println(40-yPos);
              println(39-yIndex-(40-yPos));

              if (worldOne[x + xPos][i].type == "sky") {
                if (yIndex > i) {
                  projectilePositions.add(new PVector(x*10+xPos*10, y+yPos*10-(i+1)*10));
                  println("yippie1");
                  break;
                } else {
                  projectilePositions.add(new PVector(x*10+xPos*10, y+yPos*10));
                }
              }
            }
          }
          x++;
        }
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
/*
while (x < 64) {
          if (x+xPos < 64) {
            println("top");
            println("40-yPos: " + (40-yPos));
            println("y: " + y);
            //println("heightMap: " + heightMap[x+xPos]);



            

            y = (-g)/(2*pow(v0, 2)*pow(cos(angle), 2))*pow(x, 2)+abs(tan(angle))*x;

            println("round");
            println("y: " + y);
            y = round(y / 10.0) * 10;
            println("y: " + y);

            y *= -1;

            println("testing");
            println("y: " + y);
            int yIndex = (int) y;
            yIndex *= -1;
            yIndex = yIndex /10;
            println("yIndex: " + yIndex);
            println("40-yIndex: " + (40-yIndex));
            println("39-yIndex: " + (39-yIndex));

            println("x+xPos: " + (x+xPos));
            println("[39-yIndex-(40-yPos): " + (39-yIndex-(40-yPos)));
            try {
              println("try");
              println(worldOne[x + xPos][39-yIndex-(40-yPos)].type);
            }
            catch (Exception e) {
              e.printStackTrace();
              yIndex = -40+yPos; // Taget 39 = 39-yIndex-(40-yPos) og isoleret for yIndex.
              println("exception");
              println("yindex: " + yIndex);
              println(yPos);
              println(39-yIndex-(40-yPos));


              for (int i = 39; i >= 0; i--) {
                if (worldOne[x + xPos][39-yIndex-(40-yPos)].type == "ground" || worldOne[x + xPos][39-yIndex-(40-yPos)].type == "grass") {
                } else {
                  println("output: " + (yIndex*10+yPos*10-(i+1)*10));
                  println("push1");
                  projectilePositions.add(new PVector(x*10+xPos*10, y+yPos*10-(i+1)*10));
                  println("yippie1");
                  break;
                }
              }
              println("yippie2");
              break;
            }


            if (worldOne[x + xPos][39-yIndex-(40-yPos)].type == "ground" || worldOne[x + xPos][39-yIndex-(40-yPos)].type == "grass") {
              //extraYIndex = 0;


              println("stof");
              for (int i = 39; i > -1; i--) {
                if (worldOne[x + xPos][39-yIndex-(40-yPos)].type == "ground" || worldOne[x + xPos][39-yIndex-(40-yPos)].type == "grass") {
                } else {
                  println("output: " + (yIndex*10+yPos*10-(i+1)*10));
                  println("push2");
                  projectilePositions.add(new PVector(x*10+xPos*10, y+yPos*10-i*10-10));
                  println("yippie3");
                  break;
                }
              }

              println("push3");
              println("output: " + (y+yPos*10));
              projectilePositions.add(new PVector(x*10+xPos*10, y+yPos*10));

              break;
            }
          }
          println("push4");
          println("output: " + (y+yPos*10-extraYIndex*10));
          projectilePositions.add(new PVector(x*10+xPos*10, y+yPos*10));

          x++;
        }
*/
