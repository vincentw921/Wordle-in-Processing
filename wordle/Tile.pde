public enum State {
  NOT_GUESSED,
  GUESSING,
  GUESSED,
  CORRECT_LETTER,
  CORRECT_PLACE;
}

class Tile {
  color c;
  int x,y;
  char ch;
  
  State STATE;
  //STATE: 0 = not yet used, 1= currently being used, 2= already used
  
  Tile(int x, int y) {
    this.x = x;
    this.y = y;
    c = color(100);
    STATE = State.NOT_GUESSED;
    ch = ' ';
  }
  
  void display() {
    //first displays the boxes (TO ADD: THE CHECK GUESS FUNCTION)
    
    strokeWeight(3);
    if(STATE == State.NOT_GUESSED){
      stroke(100);
      c = color(200);
    } else if(STATE == State.GUESSED){
      strokeWeight(4);
      stroke(255);
      c = color(150);
    } else if (STATE == State.CORRECT_LETTER) {
      c = color(255,255,0);
    } else if (STATE == State.CORRECT_PLACE) {
      c = color(0,255,0);
    } else {
      stroke(0);
      strokeWeight(4);
    }
    fill(c);
    rect(x,y,tileWidth, tileHeight);
    
    //Then displays the characters
    textFont(createFont("Calisto MT", tileHeight - 10));
    textAlign(LEFT);
    if(STATE != State.NOT_GUESSED){
      if(STATE == State.GUESSING){
        fill(0);
      } else if(STATE == State.GUESSED) {
        fill(0);
      }
      text(ch, x + tileWidth / 4, y + tileHeight - 15);
    }
  }
}
