class Tile {
  color c;
  int x,y,STATE;
  char ch;
  //STATE: 0 = not yet used, 1= currently being used, 2= already used
  
  Tile(int x, int y) {
    this.x = x;
    this.y = y;
    c = color(100);
    STATE = 0;
    ch = ' ';
  }
  
  void display() {
    //first displays the boxes (TO ADD: THE CHECK GUESS FUNCTION)
    
    strokeWeight(3);
    if(STATE == 0){
      stroke(100);
      c = color(200);
    } else if(STATE == 1){
      strokeWeight(4);
      stroke(255);
      c = color(150);
    } else {
      stroke(0);
      strokeWeight(4);
    }
    fill(c);
    rect(x,y,tileWidth, tileHeight);
    
    //Then displays the characters
    textFont(createFont("Calisto MT", tileHeight - 10));
    textAlign(LEFT);
    if(STATE > 0){
      if(STATE == 1){
        fill(0);
      } else if(STATE == 2){
        fill(0);
      }
      text(ch, x + tileWidth / 4, y + tileHeight - 15);
    }
  }
}
