int tileWidth;
int guessNum;
boolean won;
String ans;
Tile[][] tiles;

void setup() {
  size(600,600);
  frameRate(30);
  String[] words = loadStrings("words.txt");
  tileWidth = 500;
  guessNum = 0;
  won = false;
  ans = words[int(random(words.length))];
  
  tiles = new Tile[5][6];
  int y = 50;
  for(Tile[] tRow : tiles){
    y += (height - 100) / tiles.length;
    int x = 50;
    for(Tile t : tRow){
      t = new Tile(x, y);
      x += (width - 100) / tRow.length;
    }
  }
}

void draw() {
  for(Tile[] tRow : tiles){
    for(Tile t : tRow){
      println(
    }
  }
  stroke(0);
  strokeWeight(1);
  brc();
  String changed = brcChanged();
  
  if (changed.equals("send")) {
    if (checkGuess()) {
      won = true;
    }
    guessNum++;
  }
  if (won) {
    println("Congratulations: One win for you");
  }
  
  if (guessNum >= 6) {
    println("Nice Try!");
    setup();
  }
}

boolean checkGuess() {
  String guess = brcValue("guess");
  for (int i = 0; i < guess.length(); i++) {
    
  }
  return guess.equals(ans);
}
