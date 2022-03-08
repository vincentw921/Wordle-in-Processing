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
  int x, y;
  char ch;
  TileState STATE;

  Tile(int x, int y) {
    this.x = x;
    this.y = y;
    c = color(100);
    STATE = TileState.NOT_GUESSED;
    ch = ' ';
  }

  void display() {
    //displays boxes
    strokeWeight(3);
    if (STATE == TileState.NOT_GUESSED) {
      stroke(100);
      c = color(200);
    } else if (STATE == TileState.GUESSED) {
      strokeWeight(4);
      stroke(0);
      c = color(100);
    } else if (STATE == TileState.GUESSING) {
      strokeWeight(4);
      stroke(255);
      c = bgcolor;
    } else if (STATE == TileState.SELECTED) {
      strokeWeight(4);
      stroke(color(255, 255, 0));
      c = bgcolor;
    } else if (STATE == TileState.CORRECT_LETTER) {
      strokeWeight(4);
      stroke(0);
      c = color(255, 255, 0);
    } else if (STATE == TileState.CORRECT_PLACE) {
      strokeWeight(4);
      stroke(0);
      c = color(0, 255, 0);
    }
    fill(c);
    rect(x, y, tileWidth, tileHeight);

    //Then displays the characters
    textFont(createFont("Calisto MT", tileHeight * 0.8));
    textAlign(CENTER);
    if (STATE != TileState.NOT_GUESSED) {
      fill(0);
      text(ch, x + tileWidth * 0.5, y + tileHeight * 0.8);
    }
  }
}
