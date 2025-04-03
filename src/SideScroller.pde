/*

 Koden er bygget op med udgangspunkt i taget kode fra:
 
 SideScroller by haje-aatg (Hans-ChristianBJensen)
 An assignment template for a 2D array containing objects
 Contains no comments, since the student needs to make these
 
 Link: https://github.com/haje-aatg/2DTemplateSideScroller
 
 Til dette er der skrevet egen kode, og brugt noget kode fra SOP. Dette kode ligger i seedGenerator, og er også krediteret.
 
 */

World[][] worldOne;
Player player = new Player();
int squaresize = 10;
boolean[] downKeys = new boolean[256];
boolean[] downCodedKeys = new boolean[256];
int amountOfGoalsLeft = 3; // Between 1 and 6. If any other number there can appear spawn bugs. 


void setup() {
  // Højden af spillet er 40.
  // Bredden er 64, da seedet bliver udvidet til 256 bits, og dermed 256/4 = 64
  size(640, 400);
  background(0);
  //fill(255);
  //stroke(255); //Hvide outlines
  noStroke(); // Fjerner outlines fra squares.

  // Koordinatsystemet starter øverst til venstre i (0,0).


  worldOne = new World[64][40];  //x , y
  println("World size is: " + worldOne.length + " in x direction &: " + worldOne[0].length + " in y direction");

  int[] seed = new int[32];
  for (int i = 0; i < seed.length; i++) {
    seed[i] = int(random(255));
  }
  int[] initialHeightMap = calculateRoundKey256(seed);

  int prevXPos = 0;
  int[] xPosHeight = new int[64];

  for (int xPos = 0; xPos < 64; xPos++) {
    // Finder summen.
    int sum = initialHeightMap[xPos] + initialHeightMap[xPos + 1] + initialHeightMap[xPos + 2] + initialHeightMap[xPos + 3];

    // Finder højden med xor.
    prevXPos ^= sum;

    // Finder den største bit i prevXPos og dette bruges til at beregne højden af denne x-pos.
    xPosHeight[xPos] = findMostSignificantBit(prevXPos)*2;
  }
  /*
  initialHeightMap bliver brugt til at bestemme hvor højt terrain skal være. Det bliver lavet ved at tage summen af fire indexes i initialHeightMap arrayet, og xor dem
   med den tidligere x-pos. På den måde fås pænt terrain. Dette ganges med 2 for at lave højere bakker.
   */

  float twoOutWeight = 0.2;
  float oneOutWeight = 0.8;
  int[] heightMap = new int[64];
  
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
  int spawnWidth = totalSpawnWidth/amountOfGoalsLeft;
  
  for (int i = 0; i < amountOfGoalsLeft; i++){
   
   int randomXValue = 2+int(random(i*spawnWidth,(i+1)*spawnWidth));
   int randomYValue = 38-int(random(1,heightMap[randomXValue]));
   
   worldOne[randomXValue][randomYValue] = new World("goal");
  }

  /*
for (int xline = squaresize; xline<width; xline+=squaresize) {
   line(xline, 0, xline, height);
   }
   for (int yline = squaresize; yline<height; yline+=squaresize) {
   line(0, yline, width, yline);
   }
   */

  frameRate(10);
  println("Finished setup @: " + millis());
}

void draw() {
  if (player.yPos<worldOne[0].length-1) {
    if (worldOne[player.xPos][player.yPos+1].type == "sky") {
      player.action(false);
      player.yPos = player.yPos+1;
    } else {
      player.action(true);
    }
  } else {
    player.health = 0;
  }
  if (player.isDead()) {
    // Skal ændres.
    background(255, 0, 0);
  } else {

    for (int xPos = 0; xPos < worldOne.length; xPos++) {
      for (int yPos = 0; yPos < worldOne[0].length; yPos++) {
        worldOne[xPos][yPos].draw(xPos, yPos, squaresize);
      }
    }

    if (player.projectilePositions.size() > 0) {
      if (player.projectilePositions.size() == 1) {

        int hitX = int(player.projectilePositions.get(0).x/10);
        int hitY = int(player.projectilePositions.get(0).y/10);

        // Sætter dem ved siden af til at være sky for at vise at noget er gået i stykker.
        println("hitting");
        println(hitX);
        println(hitY);
        
        if (hitX > 63 && hitX < -1) {


          if (hitY < 39) {
            println(worldOne[hitX][hitY].type);
          }
        }

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

        player.projectilePositions.clear();
      } else {
        //println("Topelse");
        //println(player.projectilePositions.size());
        fill(0);
        for (PVector pos : player.projectilePositions) {
          //println(pos);
        }
        player.draw(player.projectilePositions.get(0).x, player.projectilePositions.get(0).y);
        //println(player.projectilePositions.get(0).x);
        //println(player.projectilePositions.get(0).y);
        //println(player.projectilePositions.size());
        player.projectilePositions.remove(0);
        //println(player.projectilePositions.size());
      }
    }

    if (player.isShooting) {
      fill(0);

      //player.projectilePositions.remove(0);

      //for (PVector pos : player.projectilePositions) {
      //println(pos.x + " : " + pos.y);
      //  player.draw(pos.x, pos.y); // tegn firkant
      //}
    }
    player.draw();
  }
  if (amountOfGoalsLeft == 0){
   println("YOU WIN :D"); 
  }
}

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
