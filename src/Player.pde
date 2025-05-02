// SideScroller by haje-aatg (Hans-ChristianBJensen)
// An assignment template for a 2D array containing objects
// Contains no comments, since the student needs to make these
//
// Link: https://github.com/haje-aatg/2DTemplateSideScroller

class Player extends World {

  int xPos, yPos, g, v0;
  float angle;
  boolean shootingDirection = false; // Sets the shooting direction to right.

  ArrayList<PVector> projectilePositions = new ArrayList<PVector>(); // Arraylist to store where the projectile is going.


  Player() { // Player constructor.

    super("player"); // Calling the world constructor to create the player.

    xPos = int(random(4, 59)); // Spawns the player in a random position.
    yPos = 20; // Spawns the player well above the surface.
    g = 10; // Gravity
    v0 = 40; // The initial speed
    angle = 85.0/360*2*PI;
  }

  void draw() { // Player draw function.
    float y;

    if (angle < PI/2) { // Showing the first 5 positions of the shot to the right.
      for (int i = 0; i < 5; i += 1) {

        y = (-g)/(2*pow(v0, 2)*pow(cos(angle), 2))*pow(i, 2)+tan(angle)*i; // Calculating the parabola.

        // The pixel size is 10. So divided by 10 round to that number and the multiply.
        // If it was y = round(y) 93.3 would become 93 and not 90. Therefore 93.3/10.0 = 9.33 would be rounded to 9 and then 90.  
        y = round(y / 10.0) * 10; // Rounding to the nearest pixel.

        y *= -1; // Inverting the shot because the y-axis is inverted.

        fill(0);

        draw(i*10+xPos*10, y+yPos*10);
      }
    } else if (angle > PI/2) { // Showing the first 5 positions of the shot to the left.

      for (int i = 0; i > -5; i -= 1) {

        y = (-g)/(2*pow(v0, 2)*pow(cos(angle), 2))*pow(i, 2)+tan(angle)*i; // Calculating the parabola.

        y *= -1; // Inverting the shot because the y-axis is inverted.

        y = round(y / 10.0) * 10; // Rounding to the nearest pixel.
        
        draw(i*10+xPos*10, y+yPos*10);
      }
    }

    // Draw the player.
    fill(worldColor);
    square(player.xPos*squaresize, player.yPos*squaresize, squaresize);

    // Drawing information about the intial speed and the angle to the player.
    fill(0);
    textAlign(LEFT, TOP);
    textSize(20);
    text("The angle is: " + int(angle*180/PI), 10, 10);
    text("The intial speed is: " + v0, 10, 30);
  }

  void draw(float x, float y) { // Function to draw the projectiles.
    fill(0);
    square(x, y, 10);
  }

  void shoot() { // The shooting function.
    //https://u490079.mono.net/upl/website/about-us111/Formelsamlingtildetskrkast11.pdf

    int x = 0;
    float y = 0;

    while (x < 64) { // While on the screen.
      if (x+xPos < 64 && !shootingDirection || -x+xPos > -1 && shootingDirection) { // While the shot is still on the screen.

        y = (-g)/(2*pow(v0, 2)*pow(cos(angle), 2))*pow(x, 2)+abs(tan(angle))*x; // Calculating the parabola.

        y = round(y / 10.0) * 10; // Rounding to the nearest pixel.

        int yIndex = (int) y;
        y *= -1; // Inverting the shot because the y-axis is inverted.

        yIndex = yIndex/10; // Determining how many pixels the shot has moved down.

        if (!shootingDirection) { // If shooting right.
          projectilePositions.add(new PVector(x*10+xPos*10, (39-yIndex)*10-(40-yPos)*10));
          try { // If the player shoots all the ground away there will come an array index out of bounds which has to be worked around.
            if (worldOne[x + xPos][39-yIndex-(40-yPos)].type != "sky") {
              break;
            }
          }
          catch (Exception e) {
            break;
          }
        } else if (shootingDirection) {
          projectilePositions.add(new PVector(((-x+xPos)*10), ((39-yIndex)-(40-yPos))*10));
          try { // If the player shoots all the ground away there will come an array index out of bounds which has to be worked around.
            if (worldOne[-x + xPos][39-yIndex-(40-yPos)].type != "sky") {
              break;
            }
          }
          catch (Exception e) {
            break;
          }
        } else { // In case the shooting boolean becomes null.
          println("something went very wrong with shootingDirection boolean.");
        }
      }
      x++;
    }
  }
  void action(boolean availableToDoAction) {

    if (downKeys[32]) { // 32 = Space
      if (availableToDoAction == true) {
        projectilePositions.clear(); // Makes sure the arraylist is empty before making the shooting calculations.
        shoot();
      }
    }

    if (downCodedKeys[38]) { // 38 = up arrow.

      angle += 0.01; // Increase the angle.

      if (angle > 1.52 && angle < 1.54) { // If the angle becomes to high change the shooting direction to left(true).
        angle = 1.62;
        shootingDirection = true;
      }
    }
    if (downCodedKeys[40]) { // 40 = down arrow.

      angle -= 0.01; // Decrease the angle.

      if (angle > 1.58 && angle < 1.63) { // If the angle becomes to high change the shooting direction to right(false).
        angle = 1.52;
        shootingDirection = false;
      }
    }
    if (downCodedKeys[37]) { // 37 = left arrow. Therefore moves left
      if (player.xPos-1 >= 0) {
        if (worldOne[player.xPos-1][player.yPos].passable) { // Checks for sky to the left.
          player.xPos -= 1;
        } else if (worldOne[player.xPos-1][player.yPos-1].passable) { // If there is something to the left. Check if there is sky above that, and move up there it not.
          player.xPos -= 1;
          player.yPos -= 1;
        }
      }
    }
    if (downCodedKeys[39]) { // 39 = right arrow. Therefore moves right.
      if (player.xPos < worldOne.length-1) {
        if (worldOne[player.xPos+1][player.yPos].passable) { // Checks for sky to the right.
          player.xPos += 1;
        } else if (worldOne[player.xPos+1][player.yPos-1].passable) { // If there is something to the right. Check if there is sky above that, and move up there if not.
          player.xPos += 1;
          player.yPos -= 1;
        }
      }
    }
    if (downCodedKeys[33]) { // Page up.
      if (v0 > 20) {
        v0 -= 1; // Decrease the initial speed.
      }
    }
    if (downCodedKeys[34]) { // Page down.
      if (v0 < 70) {
        v0 += 1; // Increase the initial speed. 
      }
    }
  }

  boolean isDead() {
    if (health>0) {
      return false;
    } else {
      return true;
    }
  }
}
