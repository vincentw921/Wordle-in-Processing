public enum ButtonType {
  RETRY,
  HARD,
  PRACTICE,
  GRAPH;
}

class Button { //radial button
  PImage button;
  float x, y, r;
  boolean selected, active;
  ButtonType bType;

  Button(String image, ButtonType type, float x, float y, float r) {
    button = loadImage(image);
    button.resize(int(2 * r), int(2 * r));
    this.x = x;
    this.y = y;
    this.r = r;
    selected = false;
    active = false;
    bType = type;
  }

  void display() {
    stroke(120);
    strokeWeight(1);
    fill(buttonBaseColor);
    circle(x, y, r*2);
    image(button, x - r, y - r);
    if (selected) {
      noStroke();
      fill(0, 0, 0, 120);
      circle(x, y, r*2);
    }
    if (active) {
      noFill();
      if (bType == ButtonType.GRAPH) stroke(correctColor);
      if (bType == ButtonType.HARD) stroke(closeColor);
      if (bType == ButtonType.PRACTICE) stroke(165, 30, 40);
      strokeWeight(5);
      circle(x, y, r*2);
    }
  }

  void checkHeld() {
    if (dist(mouseX, mouseY, x, y) <= r && mousePressed) selected = true;
  }

  void checkClicked() {
    selected = false;
    if (bType == ButtonType.RETRY) {
      if (dist(mouseX, mouseY, x, y) <= r) {
        setup();
      }
    } else if (bType == ButtonType.GRAPH) {
      if (dist(mouseX, mouseY, x, y) <= r) {

        active = !active;
        graph.show = active;
      }
    } else if (bType == ButtonType.HARD) {
      if (dist(mouseX, mouseY, x, y) <= r) {
        active = !active;
        hardMode = active;
        String mode = hardMode ? "Hard mode activated" : "Hard mode disabled";
        modeText = new TextBox(mode, 150, height / 5, width - 300, 100);
        modeText.displayStart(frameRate * 0.7, frameRate * 0.25);
      }
    } else if (bType == ButtonType.PRACTICE) {
      if (dist(mouseX, mouseY, x, y) <= r) {
        if(gState != GameState.ONGOING) return;
        active = !active;
        practiceMode = active;
        //reset answer & tiles
        guessNum = 0;
        charNum = 0;
        ans = !practiceMode ? dailyWord : answerWords[int(random(answerWords.length))];
        for(Tile[] tRow : tiles) for(Tile t : tRow){
          t.startFrame = 0;
          t.animateTime = 0;
          t.animate = false;
          t.tState = TileState.NOT_GUESSED;
          t.ch = ' ';
        }
        for(Key k : keyboard){
          k.c = keyColor;
          k.kState = KeyState.NOT_GUESSED;
        }
        practiceText = new TextBox(practiceMode ? "Practice mode activated" : "Practice mode disabled", 150, height / 5, width - 300, 100);
        practiceText.displayStart(frameRate * 0.7, frameRate * 0.25);
      }
    }
  }
}
