public class Graph {

  int x1, y1, x2, y2;
  boolean show, mDown;

  Graph(int x1, int x2, int y1, int y2) {
    this.x1 = x1; //left side x
    this.x2 = x2; //right side x
    this.y1 = y1; //top side x
    this.y2 = y2; //bottom side x
    show = true;
    mDown = false;
  }

  void createGraph() {
    //enables 
    if (mousePressed) {
      mDown = true;
    }
    if (!mousePressed && mDown) {
      mDown = false;
      show = !show;
      return;
    }
    if (!show) return;
    textAlign(CENTER);
    fill(graphColor);
    stroke(graphBorderColor);
    rect(x1, y1, x2-x1, y2-y1, 10);

    int gap = 18; //gap between bars
    int yOffset = 50; //the amount the bars are shifted above y2
    int w = (x2 - x1) / 6;
    int baseBarHeight = 30;
    int baseBarY = y2 - yOffset;
    int maxBarY = y1 + 200 + baseBarHeight;
    
    fill(255);
    textFont(text);
    text("STATISTICS", width / 2, y1 + 50);
    for (int i = 1; i <= 6; i++) {
      //the bar
      noStroke();
      if (guessNum == i) {
        fill(correctColor);
      } else {
        fill(incorrectColor);
      }
      //baseBarHeight + (maxBarHeight * (winCounts / maxWins))
      rect(x1 + w * (i-1) + gap, y2-yOffset, w - 2 * gap, -baseBarHeight - (abs(maxBarY - baseBarY) * (winCounts[i-1] / maxWins())));
      fill(255);
      textFont(graphFont);
      //the bar's quantity
      text(winCounts[i-1], x1 + w * i - w / 2, y2-yOffset -baseBarHeight - (abs(maxBarY - baseBarY) * (winCounts[i-1] / maxWins())) + (0.7 * baseBarHeight));
      //the x-axis label
      text(i, x1 + w * i - w / 2, y2 - yOffset + baseBarHeight);
    }
  }

  private float maxWins() {
    int max = 0;
    for (int i = 0; i < winCounts.length; i++) {
      max = max(max, winCounts[i]);
    }
    return max(5, max);
  }
}
