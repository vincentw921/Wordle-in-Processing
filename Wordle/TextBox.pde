class TextBox {
  //startFrame = starting framecount, t = # frames to show
  int startFrame, x, y, w, h;
  float showTime, fadeTime;
  String msg;
  boolean show;
  color c, textC;
  PFont font;

  boolean isTimer;
  String timerStr;

  public TextBox(String msg, int x, int y, int w, int h) {
    startFrame = 0;
    this.msg = msg;
    this.x = x;
    this.y = y;
    this.w  = w;
    this.h = h;
    isTimer = false;
    show = false;
    font = text;
    timerStr = "";
  }

  //frameTime is number of frames to show, fadeTime is number of frames to fade away for
  void displayStart(float showTime, float fadeTime) {
    c = color(255, 255, 255, 220);
    textC = color(0, 0, 0, 255);
    startFrame = frameCount;
    this.fadeTime = fadeTime;
    this.showTime = showTime;
    show = true;
  }

  void display() {
    if (!show) return;
    color currC = c;
    color currTextC = textC;
    if (startFrame + showTime < frameCount && startFrame + showTime + fadeTime > frameCount) { //fading time
      currC = color(red(c), blue(c), green(c), (((startFrame + showTime + fadeTime) - frameCount) * alpha(c)) / fadeTime);
      currTextC = color(red(textC), green(textC), blue(textC), (((startFrame + showTime + fadeTime) - frameCount) * alpha(textC)) / fadeTime);
    }
    if (startFrame + showTime + fadeTime <= frameCount) { //past fading time, so stop display
      show = false;
      return;
    }
    fill(currC);
    noStroke();
    rect(x, y, w, h, 10);
    textFont(font);
    fill(currTextC);
    textAlign(CENTER);
    text(msg, (2 * x + w) / 2, y + 50);
    if (isTimer) {
      textFont(createFont("Arial Bold", 140));
      text(timerStr, (2 * x + w) / 2, y + 110);
    }
  }
  public TextBox() {
    this("No message", 300, height / 3, width - 300, 100);
  }
}
