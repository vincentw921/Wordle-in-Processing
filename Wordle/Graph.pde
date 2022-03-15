public class Graph {
  
  void createGraph() {
    int x1 = 50;
    int x2 = width - 50;
    int y1 = height / 20 + 300;
    int y2 = 90 + (6 * (tileSideLength + padding));
    fill(255);
    rect(x1,y1,x2-x1,y2-y1,10);
    
    int w = (x2 - x1) / 6;
    int h = (y2 - y1) / (maxWins() / 5 + 1);
    fill(255);
    for (int i = 0; i < (maxWins() / 5 + 1); i++) {
      text(i * 5, x1 - 20, y2 - h * i);
    }
    for (int i = 1; i <= 6; i++) {
      fill(255);
      text(i, x1 + w * i - w / 2, y2 + 20);
      fill(0);
      noStroke();
      rect(x1 + w * (i-1), y2, w, -h * numWins[i - 1] / 5.);
    }
  }
  
  private int maxWins() {
    int max = 0;
    for (int i = 0; i < numWins.length; i++) {
      max = max(max,numWins[i]);
    }
    return max;
  }
}
