public class Graph {
  public Graph(int x, int y, int size, int blocknum) {
    
  }
  
  void createGraph() {
    int x1 = height / 4;
    int x2 = height * 3 / 4;
    int y1 = width / 4;
    int y2 = width * 3 / 4;
    line(x1, y1, x2, y1);
    line(x1,y2,x2,y2);
    line(x1,y1,x1,y2);
    
    int w = x2 - x1;
    int h = y2 - y1;
    for (int i = 1; i <= 6; i++) {
      text(i, x1 + (x2 - x1) / 6 * i, y2);
    }
    for (int i = 0; i < (maxWins() / 5 + 1) * 5; i += 5) {
      
    }
  }
  
  int maxWins() {
    int max = 0;
    for (int i = 0; i < numWins.length; i++) {
      max = max(max,numWins[i]);
    }
    return max;
  }
}

public class Block {
  int x;
  int y;
  int size;
  public Block(int x, int y, int size) {
    this.x = x;
    this.y = y;
    this.size = size;
  }
}
