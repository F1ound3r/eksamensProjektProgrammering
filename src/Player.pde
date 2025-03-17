// SideScroller by haje-aatg (Hans-ChristianBJensen)
// An assignment template for a 2D array containing objects
// Contains no comments, since the student needs to make these
//
// Link: https://github.com/haje-aatg/2DTemplateSideScroller

class Player extends WorldObject {

  int xPos = int(random(4, 59));
  int yPos = 20;

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
  void action(boolean tJump) {
    /*for (int index =50; index<100; index++) {//downCodedKeys.length
     //println(index + " : " + downCodedKeys[index]);
     println(index + " : " + downKeys[index]);
     }*/
    PVector sumDirection = new PVector(0, 0);
    if (downCodedKeys[38]) {
      player.yPos -= 1;
    }
    if (downCodedKeys[40] ) {
      direction = new PVector(0, 1);
      sumDirection.add(direction);
    }
    if (downCodedKeys[37]) {
      if (player.xPos-1 >= 0) {

        //if (worldOne[player.xPos-1][player.yPos].passable){
        player.xPos -= 1;
        //}
      }
    }
    if (downCodedKeys[39]) {
      if (player.xPos < worldOne.length-1){
       player.xPos += 1; 
      }
    }
    if (sumDirection.mag()>0) {
      direction=sumDirection;
    }
    if (downCodedKeys[69]) {
      if (int(place.x+direction.x) >= 0 && int(place.x+direction.x) <= worldOne.length-1 && int(place.y+direction.y) <= worldOne[0].length-1) {
        print("Attacking! " + direction);
        worldOne[int(place.x+direction.x)][int(place.y+direction.y)].attacked(byte(1));
      }
    }
  }
}
