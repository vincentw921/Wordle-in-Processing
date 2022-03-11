class TextBox {
  int startFrame, t, x, y, w, h;
  String msg;
  
  void textBox(String msg, int x, int y, int w, int h) {
    fill(255, 255, 255, 210);
    noStroke();
    rect(x, y, w, h, 10);
    textFont(text);
    fill(0);
    textAlign(CENTER);
    text(msg, (2 * x + w) / 2, y + 0.6 * h);
  }
  void TextBox(){
    this.textBox("No message", 150, height / 3, width - 300, 100);
  }
}
