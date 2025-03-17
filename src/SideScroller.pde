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
WorldObject exit;
boolean[] downKeys = new boolean[256];
boolean[] downCodedKeys = new boolean[256];

void setup() {
  size(640, 400);
  //size(800, 600);
  //size(1280, 960);
  //size(1440, 900);
  //size(1600, 900);
  //size(1680, 1050);
  //size(1920, 1080);
  //fullScreen();
  background(0);
  fill(255);
  stroke(255);
  worldOne = new World[64][40];  //x , y
  println("Dungeon size is: " + worldOne.length + " in x direction &: " + worldOne[0].length + " in y direction");

  int[] seed = new int[32];
  for (int i = 0; i < seed.length; i++) {
    seed[i] = int(random(255));
  }

  int[] heightMap = calculateRoundKey256(seed);



  println(seed);
  println(heightMap);
  // Koordinatsystemet starter øverst til venstre i (0,0).
  // Højden af spillet er 40.

  int prevXPos = 0;
  int[] xPosHeight = new int[64];

  for (int xPos = 0; xPos < 64; xPos++) {
    // Finder summen.
    int sum = heightMap[xPos] + heightMap[xPos + 1] + heightMap[xPos + 2] + heightMap[xPos + 3];

    // Finder højden med xor.
    prevXPos ^= sum;

    // Finder den største bit i prevXPos og dette bruges til at beregne højden af denne x-pos.
    xPosHeight[xPos] = findMostSignificantBit(prevXPos)*2;
  }
  /*
  Heightmap bliver brugt til at bestemme hvor højt terrain skal være. Det bliver lavet ved at tage summen af fire indexes i heightMap arrayet, og xor dem
   med den tidligere x-pos. På den måde fås pænt terrain. Dette ganges med 2 for at lave højere bakker.
   */

  for (int xPos = 0; xPos < 64; xPos++) {
    int meanXPosHeight;

    if ( xPos == 0) {
      meanXPosHeight = int((xPosHeight[xPos] + xPosHeight[xPos + 1])/2);
    } else if (xPos == 63) {
      meanXPosHeight = int((xPosHeight[xPos - 1] + xPosHeight[xPos])/2);
    } else {
      meanXPosHeight = int((xPosHeight[xPos-1] + xPosHeight[xPos] + xPosHeight[xPos + 1])/3);
    }
    
    for (int yPos = 0; yPos < 40; yPos++) {

      if (yPos > meanXPosHeight) {
        worldOne[xPos][(yPos-40)*-1-1] = new World("sky");
      } else if (yPos < meanXPosHeight) {
        worldOne[xPos][(yPos-40)*-1-1] = new World("ground");
      } else {
        worldOne[xPos][(yPos-40)*-1-1] = new World("grass");
      }
    }
  }
  for (int xline = squaresize; xline<width; xline+=squaresize) {

    line(xline, 0, xline, height);
  }
  for (int yline = squaresize; yline<height; yline+=squaresize) {
    line(0, yline, width, yline);
  }

  frameRate(10);
  println("Finished setup @: " + millis());
}

void draw() {
  if (player.place.y<worldOne[0].length-1) {
    if (player.falling(worldOne[int(player.place.x)][int(player.place.y+1)].passable)) {
      player.action(false);
    } else {
      player.action(true);
    }
  } else {
    player.health = 0;
  }
  if (player.isDead()) {
    background(255, 0, 0);
  } else {
    for (int xdir = 0; xdir<worldOne.length; xdir++) {
      for (int ydir = 0; ydir<worldOne[0].length; ydir++) {
        worldOne[xdir][ydir].draw(xdir, ydir, squaresize);
        if (ydir+1 < worldOne[0].length) {

          if (worldOne[xdir][ydir].falling(worldOne[xdir][ydir+1].passable)) {
            worldOne[xdir][ydir].falling(true);
          } else {
            worldOne[xdir][ydir].falling(false);
          }
        }
        worldOne[xdir][ydir].draw();
      }
    }
    player.draw();
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
