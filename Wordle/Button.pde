class Button{ //radial button
  PImage button;
  float x, y, r;
  boolean selected;
  color baseColor;
  color selectedColor;
  
  Button(String image, float x, float y, float r){
    button = loadImage(image);
    button.resize(int(2 * r), int(2 * r));
    this.x = x;
    this.y = y;
    this.r = r;
    selected = false;
    baseColor = color(200);
    selectedColor = color(160);
  }
  
  void display(){
    stroke(120);
    strokeWeight(1);
    if(selected){
      fill(selectedColor);
    } else {
      fill(baseColor);
    }
    circle(x, y, r*2);
    image(button, x - r, y - r);
  }
  
  void checkHeld(){
    if(dist(mouseX, mouseY, x, y) <= r && mousePressed) selected = true;
  }
  void checkClicked(){
    selected = false;
    if(dist(mouseX, mouseY, x, y) <= r){
      setup();
    }
  }
}
