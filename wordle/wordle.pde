int tileWidth, tileHeight, guessNum;
boolean won;
String ans;
Tile[][] tiles;
color bgcolor = color(200);

void setup() {
  background(bgcolor);
  size(600,600);
  frameRate(30);
  String[] words = loadStrings("words.txt");
  guessNum = 0;
  won = false;
  ans = words[int(random(words.length))];
  textFont(createFont("Calisto MT Bold", 120));
  //Trebuchet MS Bold
  //Nirmala UI Bold
  //Segoe Script Bold
  //println(PFont.list());
  tiles = new Tile[6][5];
  int ystart = 100;
  tileWidth = (width - 50) / tiles[0].length - 5;
  tileHeight = (height - 60 - ystart) / tiles.length - 5;
  int y = ystart-50;
  for(Tile[] tRow : tiles){
    y += tileHeight + 10;
    int x = 20;
    for(Tile t : tRow){
      t = new Tile(x, y);
      x += tileWidth + 10;
      t.display();
    }
  }
  textAlign(CENTER);
  fill(0);
  text("Wurdel", width / 2, 100);
  //set state of all boxes in row[numGuesses] to 1, and all before it to 2, whenever enter is pressed
}

void draw() {
  
}
