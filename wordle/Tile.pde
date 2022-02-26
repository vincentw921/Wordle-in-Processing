class Tile {
  color c;
  int x,y,STATE;
  //eventually use STATE to see if box is clicked on, 0 = not yet used, 1= currently being used, 2= already used
  Tile(int x, int y) {
    this.x = x;
    this.y = y;
    c = color(100);
    STATE = 0;
  }
  void display() { //should not change the previously displayed boxes
    noFill();
    strokeWeight(3);
    if(STATE == 0){
      stroke(100);
    } else if(STATE == 1){
      stroke(255);
    } else {
      return;
    }
    rect(x,y,tileWidth, tileHeight);
  }
}
