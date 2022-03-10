public enum KeyState{
  NOT_GUESSED,
  GUESSED,
  CORRECT_LETTER,
  CORRECT_PLACE;
}

class Key {
  int x, y, w, h;
  char k;
  KeyState kState;
  public Key(int x, int y, int w, int h, char k) {
    this.k = k;
    this.x = x;
    this.y = y;
    this.w = w;
    this.h = h;
    kState = KeyState.NOT_GUESSED;
  }
  public Key(int x, int y, int s, char k) {
    this(x, y, s, s, k);
  }
  
  void display() {
    rect(x, y, w, h);
    text(k,x,y);
  }
  
  boolean isPressed() {
    return mousePressed && (mouseX < x + w && mouseX > x && mouseY > y && mouseY < y + h);
  }
}
