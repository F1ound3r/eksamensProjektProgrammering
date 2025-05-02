/*
 The code is build from:
 
 SideScroller by haje-aatg (Hans-ChristianBJensen)
 An assignment template for a 2D array containing objects
 Contains no comments, since the student needs to make these
 
 Link: https://github.com/haje-aatg/2DTemplateSideScroller
 
 There has also been written own code, and used some code from SOP. That code is in the file seedGenerator, and is also credited in that file.
 */
/*
The keybinds are the arrow keys, page up + page down and the spacebar.
 */

World[][] worldOne;
Player player;
int squaresize, amountOfGoalsLeft;
boolean[] downKeys = new boolean[256];
boolean[] downCodedKeys = new boolean[256];


void setup() {
  // The hegith of the game is 40 pixels.
  // The width of the game is 64 pixels, because the seed is expanded to 256 bits and 256/4 = 64.

  // Initialize the program
  size(640, 400);
  background(0);
  frameRate(15);
  squaresize = 10;
  noStroke(); // Removes the outlines from squares.
  amountOfGoalsLeft = 3; // Between 1 and 6. If any other number there can appear spawn bugs. IE goals can spawn atop of eachother and its not possible to win.
  // Koordinatsystemet starter øverst til venstre i (0,0).
  worldOne = new World[64][40];  //x , y
  player = new Player();

  // Generating the 32 random numbers for the seed.
  // If wanting to optimize these bits of code they could easily be bits instead of integers. IE they are only 0-255.
  int[] seed = new int[32];
  for (int i = 0; i < seed.length; i++) {
    seed[i] = int(random(255));
  }
  // Expanding the seed to get the initial heightmap.
  // Uses the AES256 key expansion to expand the random numbers.
  int[] initialHeightMap = calculateRoundKey256(seed);


  // The height at every x-value is calculated by taking the sums of 4 numbers from the extended seed, then xors with the previous number and the height becomes the
  // most significant bit in number.
  int prevXPos = 0;
  int[] xPosHeight = new int[64];
  for (int xPos = 0; xPos < 64; xPos++) {
    // Finds the sum
    int sum = initialHeightMap[xPos] + initialHeightMap[xPos + 1] + initialHeightMap[xPos + 2] + initialHeightMap[xPos + 3];

    // Finds the new number.
    prevXPos ^= sum;

    // Finds the most significant bit in prevXPos and this is used to calculate the height of x-pos.
    xPosHeight[xPos] = findMostSignificantBit(prevXPos)*2;
  }

  // Though the terrain is really rugged and needs some smoothing out.
  // Therefore a weighted average is made from the two before and the two after the x-value.

  // The two weighted values:
  float twoOutWeight = 0.2;
  float oneOutWeight = 0.8;

  // The new heightMap.
  int[] heightMap = new int[64];


  // Iterate though all x-values and calculate the new heightMap.
  for (int xPos = 0; xPos < 64; xPos++) {
    int meanXPosHeight;

    if ( xPos == 0) {
      meanXPosHeight = int((xPosHeight[xPos] + xPosHeight[xPos + 1]*oneOutWeight + xPosHeight[xPos + 2]*twoOutWeight)/3);
    } else if (xPos == 1) {
      meanXPosHeight = int((xPosHeight[xPos- 1]*oneOutWeight + xPosHeight[xPos] + xPosHeight[xPos + 1]*oneOutWeight + xPosHeight[xPos + 2]*twoOutWeight)/4);
    } else if (xPos == 62) {
      meanXPosHeight = int((xPosHeight[xPos - 2]*twoOutWeight + xPosHeight[xPos - 1]*oneOutWeight + xPosHeight[xPos] + xPosHeight[xPos + 1]*oneOutWeight)/4);
    } else if (xPos == 63) {
      meanXPosHeight = int((xPosHeight[xPos - 2]*twoOutWeight + xPosHeight[xPos - 1]*oneOutWeight + xPosHeight[xPos])/3);
    } else {
      meanXPosHeight = int((xPosHeight[xPos - 2]*twoOutWeight + xPosHeight[xPos - 1]*oneOutWeight + xPosHeight[xPos] + xPosHeight[xPos + 1]*oneOutWeight + xPosHeight[xPos + 2]*twoOutWeight)/5);
    }

    heightMap[xPos] = meanXPosHeight;

    // While the heightmap is being made, the terrain is also getting built.
    // It looks at the height at the specific x-value and sets the pixel to sky if the y-value is greater than the height.
    // If the y-value is equal to the height then the pixel becomes grass, and if the y-value is less than the height the pixel becomes ground.

    for (int yPos = 0; yPos < 40; yPos++) {
      if (yPos > meanXPosHeight) {
        worldOne[xPos][(yPos-40)*-1-1] = new World("sky");
      } else if (yPos < meanXPosHeight) {
        worldOne[xPos][(yPos-40)*-1-1] = new World("ground");
      } else {
        heightMap[xPos] = meanXPosHeight;
        worldOne[xPos][(yPos-40)*-1-1] = new World("grass");
      }
    }
  }

  // Goal spawning code:
  // There has been subtracted 2 pixels from each side. Therefore the total width of the spawning area is 60.

  int totalSpawnWidth = 60;

  // This needs to be split into equal sizes.
  int spawnWidth = totalSpawnWidth/amountOfGoalsLeft; //Therefore the number between 1 and 6 mentioned in setup because those numbers divide 60 cleanly.

  // Creates a goal in the selected chunk randomly.
  for (int i = 0; i < amountOfGoalsLeft; i++) {

    int randomXValue = 2+int(random(i*spawnWidth, (i+1)*spawnWidth));
    int randomYValue = 38-int(random(1, heightMap[randomXValue]));

    worldOne[randomXValue][randomYValue] = new World("goal");
  }
  println("Finished setup @: " + millis());
}

void draw() {
  // Making sure the player is not out of the map. (The bottom).
  if (player.yPos<worldOne[0].length-1) {
    // If the player is flying move the player down.
    if (worldOne[player.xPos][player.yPos+1].type == "sky") {
      player.action(false); // Make sure the player cannot shoot.
      player.yPos = player.yPos+1; //Move the player down.
    }
  } else {
    // If the player is not in the map. Kill the player.
    player.health = 0;
  }
  if (player.isDead()) {
    // Make the background red to show that the player is dead. Also write that in text.
    background(255, 0, 0);
    fill(255);
    textAlign(CENTER);
    textSize(40);
    text("You died, try again", width/2, height/2);
    textSize(20);
    text("Womp Womp :(", width/2, height/2 + 40);
  } else {
    // If the player is not dead. Draw every pixel of the world.
    for (int xPos = 0; xPos < worldOne.length; xPos++) {
      for (int yPos = 0; yPos < worldOne[0].length; yPos++) {
        worldOne[xPos][yPos].draw(xPos, yPos, squaresize);
      }
    }
    // If the player has shot there are projectiles in the projectilePosisions arraylist and it therefore has to be drawn.
    if (player.projectilePositions.size() > 0) {
      player.action(false);
      if (player.projectilePositions.size() == 1) { // If its the last pixel in the shot it is going to be hitting the ground.
        // Draw the last bullet before removing the terrain.
        player.draw(player.projectilePositions.get(0).x, player.projectilePositions.get(0).y);

        // Get the coordinates of where the shots hits.
        int hitX = int(player.projectilePositions.get(0).x/10);
        int hitY = int(player.projectilePositions.get(0).y/10);

        // Takes the eight pixels around the pixel that has been hit and turns them into sky
        for (int x = -1; x < 2; x++) {
          for (int y = -1; y < 2; y++) {
            if (hitY+y > 39) {
            } else {
              if (hitX+x < 63 && hitX+x > 0) {
                worldOne[hitX+x][hitY+y].beenHit("sky");
              }
            }
          }
        }
        // Clear the arraylist because the last pixel in the shot has been drawn.
        player.projectilePositions.clear();
        player.action(true);
      } else { // If the bullet pixel is not the last pixel in the arraylist and therefore just showing the bullet path.

        // Draw the bullet pixel
        player.draw(player.projectilePositions.get(0).x, player.projectilePositions.get(0).y);
        // Remove the first index in the arraylist. 
        player.projectilePositions.remove(0);
      }
    } else {
     player.action(true); 
    }
    
    player.draw();
  }
  // The win condition
  if (amountOfGoalsLeft == 0) {
    background(255, 255, 0);
    textAlign(CENTER);
    fill(0);
    textSize(40);
    text("You have won the game", width/2, height/2);
    textSize(20);
    text("Well done :D", width/2, height/2 + 40);
  }
}


// HAJE code for checking what key on the keyboard is pressed.
void keyPressed() {
  if (key == CODED) {
    //print("Code: " + keyCode + ". ");
    if (keyCode<256) {
      downCodedKeys[keyCode] = true;
    }
  } else {
    //print("Key: " + (int)key + ". ");
    if (key<256) {
      downKeys[key] = true;
    }
  }
}
void keyReleased() {
  if (key == CODED) {
    //print("LiftCode: " + keyCode + ". ");
    if (keyCode<256) {
      downCodedKeys[keyCode] = false;
    }
  } else {
    //print("LiftKey: " + (int)key + ". ");
    if (key<256) {
      downKeys[key] = false;
    }
  }
}
