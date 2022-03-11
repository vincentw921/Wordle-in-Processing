public enum TileState {
  NOT_GUESSED,
  GUESSING,
  SELECTED,
  GUESSED,
  CORRECT_LETTER,
  CORRECT_PLACE;
}

class Tile {
  color c;
  int x, y, side;
  char ch;
  TileState STATE;
  //HashMap<TileState, color> tileColor = new HashMap<TileState, color>();
  public Tile(int x, int y, int side) {
    this.x = x;
    this.y = y;
    this.side = side;
    STATE = TileState.NOT_GUESSED;
    ch = ' ';
  }

  void display() {
    strokeWeight(3);
    stroke(60);
    //displays boxes
    if (STATE == TileState.NOT_GUESSED) {
      c = bgColor;
    } else if (STATE == TileState.GUESSED) {
      c = incorrectColor;
    } else if (STATE == TileState.GUESSING) {
      stroke(88);
      c = bgColor;
    } else if (STATE == TileState.SELECTED) {
      stroke(127, 127, 0);
      c = color(80);
    } else if (STATE == TileState.CORRECT_LETTER) {
      stroke(closeColor);
      c = closeColor;
      
    } else if (STATE == TileState.CORRECT_PLACE) {
      stroke(correctColor);
      c = correctColor;
    }
    fill(c);
    square(x, y, side);

    //Then displays the characters
    textFont(createFont("Arial Bold", side * 0.5));
    textAlign(CENTER);
    if (STATE != TileState.NOT_GUESSED) {
      fill(255);
      text(ch, x + side * 0.5, y + side * 0.7);
    }
  }
}
