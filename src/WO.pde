// SideScroller by haje-aatg (Hans-ChristianBJensen)
// An assignment template for a 2D array containing objects
// Contains no comments, since the student needs to make these
//
// Link: https://github.com/haje-aatg/2DTemplateSideScroller

class WorldObject {
  byte squaresize, health; // Only needs to be a byte because it will not exceed 255. 
  PVector place = new PVector(1, 1);
  PVector direction = new PVector(1, 0);  //float xdir, ydir;
  boolean passable, destructible;
  color worldObjectColor;

  WorldObject() {
    squaresize = 10;
    health = byte(random(10, 20));
  }
 
  boolean isDead() {
    if (health>0) {
      return false;
    } else {
      return true;
    }
  }
}
