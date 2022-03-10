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
  Tile(int x, int y, int side) {
    this.x = x;
    this.y = y;
    this.side = side;
    STATE = TileState.NOT_GUESSED;
    ch = ' ';
  }

  void display() {
    strokeWeight(3);
    //displays boxes
    if (STATE == TileState.NOT_GUESSED) {
      stroke(100);
      c = color(40);
    } else if (STATE == TileState.GUESSED) {
      stroke(150);
      c = color(100);
    } else if (STATE == TileState.GUESSING) {
      stroke(150);
      c = color(80);
    } else if (STATE == TileState.SELECTED) {
      stroke(127, 127, 0);
      c = color(80);
    } else if (STATE == TileState.CORRECT_LETTER) {
      stroke(255);
      c = color(120, 120, 0);
    } else if (STATE == TileState.CORRECT_PLACE) {
      stroke(255);
      c = color(0, 120, 0);
    }
    fill(c);
    square(x, y, side);

    //Then displays the characters
    textFont(createFont("Calisto MT", side * 0.8));
    textAlign(CENTER);
    if (STATE != TileState.NOT_GUESSED) {
      fill(255);
      text(ch, x + side * 0.5, y + side * 0.8);
    }
  }
}
