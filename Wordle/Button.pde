class Button{ //radial button
  PImage button;
  float x, y, r;
  boolean selected;
  color baseColor;
  color selectedColor;
  
  Button(float x, float y, float r){
    this.x = x;
    this.y = y;
    this.r = r;
    selected = false;
    baseColor = color(200);
    selectedColor = color(160);
  }
  void display(){
    stroke(0);
    strokeWeight(1);
    if(selected){
      fill(selectedColor);
    } else {
      fill(baseColor);
    }
    circle(x, y, r*2);
  }
  void checkClicked(){
    if(dist(mouseX, mouseY, x, y) <= r){
      
    }
  }
}
