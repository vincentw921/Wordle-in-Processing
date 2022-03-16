public enum ButtonType {
  RETRY,
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
    if(active) {
      noFill();
      stroke(correctColor);
      strokeWeight(3);
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
    } else if(bType == ButtonType.GRAPH) {
      if (dist(mouseX, mouseY, x,y) <= r) {
        active = !active;
        graph.show = active;
      }
    }
  }
}
