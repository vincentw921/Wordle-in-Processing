public enum KeyState{
  NOT_GUESSED,
  GUESSED,
  CORRECT_LETTER,
  CORRECT_PLACE;
}

class Key {
  int x, y, w, h;
  String k;
  KeyState kState;
  public Key(int x, int y, int w, int h, String k) {
    this.k = k;
    this.x = x;
    this.y = y;
    this.w = w;
    this.h = h;
    kState = KeyState.NOT_GUESSED;
  }
  public Key(int x, int y, int s, String k) {
    this(x, y, s, s, k);
  }
  
  void display() {
    noStroke();
    fill(keyColor);
    rect(x, y, w, h, 6);
    fill(255);
    textAlign(CENTER);
    textFont(createFont("Arial Bold", h * 0.24));
    if(k.equals(qwerty[27])){
      text("BACK", x + 0.5 * w, y + 0.5 * h);
      text("SPACE", x + 0.5 * w, y + 0.75 * h);
      return;
    }
    text(k.toUpperCase(),x + 0.5 * w,y + 0.6 * h);
  }
  
  boolean isPressed() { //only gets called if mouse is already clicked
    return  mouseX < x + w && mouseX > x && mouseY > y && mouseY < y + h;
  }
}
