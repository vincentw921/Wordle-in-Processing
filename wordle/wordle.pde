class Tile {
  color c;
  int x,y;
  
  public Tile(int x, int y) {
    this.x = x;
    this.y = y;
    c = color(200);
  }
  void display() {
    fill(c);
    square(x,y,tileWidth);
  }
}

int tileWidth = width / 5;
String ans;
int guessNum;

boolean won;

Tile[][] tiles;

void setup() {
  size(600,600);
  frameRate(30);
  String[] words = loadStrings("words.txt");
  ans = words[(int)random(words.length)];
  tiles = new Tile[5][6];
  guessNum = 0;
  
  won = false;
}

void draw() {
  for (int i = 0; i < tiles.length; i++) {
    for (int j = 0; j < tiles[0].length; j++) {
      tiles[i][j].display();
    }
  }
  brc();
  String changed = brcChanged();
  
  if (changed.equals("send")) {
    if (checkGuess()) {
      won = true;
    }
    guessNum++;
  }
  if (won) {
    println("Congradulations: One win for you");
  }
  
  if (guessNum >= 6) {
    println("Nice Try!");
    setup();
  }
}

boolean checkGuess() {
  String guess = brcValue("guess");
  for (int i = 0; i < guess.length(); i++) {
    for (int j = 0; j < ans.length(); j++) {
      if (guess.charAt(i) == guess.charAt(j)) {
        tiles[i][guessNum].c = color(255,255,0);
      }
    }
    if (guess.charAt(i) == ans.charAt(i)) {
      tiles[i][guessNum].c = color(0,255,0);
    }
  }
  return guess.equals(ans);
}
