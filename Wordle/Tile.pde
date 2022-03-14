public enum TileState {
  NOT_GUESSED,
  GUESSING,
  SELECTED,
  GUESSED,
  CORRECT_LETTER,
  CORRECT_PLACE;
}

public class Tile {
  int startFrame, x, y, side;
  float animateTime;
  boolean animate;
  char ch;
  color c;
  TileState tState;

  public Tile(int x, int y, int side) {
    this.x = x;
    this.y = y;
    this.side = side;
    startFrame = 0;
    animateTime = 0;
    animate = false;
    tState = TileState.NOT_GUESSED;
    ch = ' ';
  }

  void display() {
    strokeWeight(3);
    stroke(60);
    //displays boxes
    if (frameCount < startFrame && animate) { //before animation starts, just draw the GUESSSING state tile
      fill(bgColor);
      stroke(88);
      square(x, y, side);
      fill(255);
      textFont(createFont("Arial Bold", side * 0.5));
      textAlign(CENTER);
      text(ch, x + side * 0.5, y + side * 0.7);
    } else if (frameCount >= startFrame && frameCount < startFrame + animateTime) { //during animation, change tile size based on frameCount
      if (animateTime + startFrame <= frameCount) { //if frameCount past animateTime, end the animation and reset the time values to placeholding values
        startFrame = 0;
        animateTime = 0;
        return;
      }
      if (side - (2 * (frameCount - startFrame) * (side / animateTime)) >= 0) { //Side is flipping from black to colored
        fill(bgColor);
        stroke(88);
        rect(x, y + (frameCount - startFrame) * (side / animateTime), side, side - (2 * (frameCount - startFrame) * (side / animateTime))); //height goes from side to 0 in snimateTime - startFrame / 2 frames
      } else {  //color the tile accordingly
        if (tState == TileState.GUESSED) {
          c = incorrectColor;
        } else if (tState == TileState.CORRECT_LETTER) {
          stroke(closeColor);
          c = closeColor;
        } else if (tState == TileState.CORRECT_PLACE) {
          stroke(correctColor);
          c = correctColor;
        }
        fill(c);
        rect(x, (y + 0.5 * side) + (frameCount - (startFrame + 0.5 * animateTime)) * (side / animateTime), side, side - (2 * (frameCount - startFrame) * (side / animateTime))); //height goes from side to 0 in snimateTime - startFrame / 2 frames
      }
      return;
    } else { //If animation is over/not initiated, color accordingly
      if (tState == TileState.NOT_GUESSED) {
        c = bgColor;
      } else if (tState == TileState.GUESSED) {
        c = incorrectColor;
      } else if (tState == TileState.GUESSING) {
        stroke(88);
        c = bgColor;
      } else if (tState == TileState.CORRECT_LETTER) {
        stroke(closeColor);
        c = closeColor;
      } else if (tState == TileState.CORRECT_PLACE) {
        stroke(correctColor);
        c = correctColor;
      }
      fill(c);
      square(x, y, side);

      //Then displays the characters
      textFont(createFont("Arial Bold", side * 0.5));
      textAlign(CENTER);
      if (tState != TileState.NOT_GUESSED) {
        fill(255);
        text(ch, x + side * 0.5, y + side * 0.7);
      }
    }
  }
  void animateStart(int startFrame, float animateTime) {
    animate = true;
    this.animateTime = animateTime;
    this.startFrame = startFrame;
  }
}
