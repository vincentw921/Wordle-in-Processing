public class Graph {
  int x1, y1, x2, y2;
  boolean show, mDown;

  Graph(int x1, int x2, int y1, int y2) {
    this.x1 = x1; //left side x
    this.x2 = x2; //right side x
    this.y1 = y1; //top side x
    this.y2 = y2; //bottom side x
    show = false;
    mDown = false;
  }

  void createGraph() {
    //displays the graph (wierd name ik)
    if (!show) return;
    textAlign(CENTER);
    fill(graphColor);
    stroke(graphBorderColor);
    rect(x1, y1, x2-x1, y2-y1, 10); //draws the window where the graph will be

    //used to draw the bars of the graph
    int gap = 18; //gap between bars
    int yOffset = 50; //the amount the bars are shifted above y2
    int w = (x2 - x1) / 6; //width of the bars
    int baseBarHeight = 30; //base bar height
    int baseBarY = y2 - yOffset; //start of the bar (bottom's Y)
    int maxBarY = y1 + 200 + baseBarHeight; //top's Y, the masximum possible y-value for the top of a bar

    fill(255);
    textFont(text);
    text("STATISTICS", width / 2, y1 + 50);
    textFont(graphFont);
    //prints the win rate, total attempts, current streak, and max streak
    text("Winrate: " + round(100. * float(winCount) / float(totalAttempts)) + "%  Total Attempts: " + totalAttempts, width / 2, y1 + 80);
    text("Current Streak: " + curStreak + "  Max Streak: " + maxStreak, width / 2, y1 + 110);
    for (int i = 1; i <= 6; i++) {//draws the 6 bars, along with the text
      noStroke();
      if (guessNum == i && gState == GameState.VICTORY) {
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
