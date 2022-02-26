class Tile {
  color c;
  int x,y;
  
  Tile(int x, int y) {
    this.x = x;
    this.y = y;
    c = color(100);
  }
  void display() {
    noStroke();
    fill(c);
    //square(x,y,tileWidth);
  }
}
