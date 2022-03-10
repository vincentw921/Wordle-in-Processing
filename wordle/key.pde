class Key {
  int x,y,w,h;
  char k;
  public Key(int x, int y, int w, int h, char k) {
    this.k = k;
    this.x = x;
    this.y = y;
    this.w = w;
    this.h = h;
  }
  
  void display() {
    rect(x,y,w,h);
    text(k,x,y);
  }
  
  boolean isPressed() {
    boolean mouseBetween = mouseX < x + w && mouseX > x && mouseY > y && mouseY < y + h;
    if (mousePressed && mouseBetween) {
      return true;
    }
    return false;
  }
}
