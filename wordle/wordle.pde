/*****************************************************************************************************
 *  ITS JUST WORDLE
 * BUT IN PROCESSING
 * WOW SO COOL
 * TO DO: Add a counter thing next to title to show the amount of guesses posssibly (not necessary
 *        Make the guess checking function, and fill in the boxes accordingly
 *        Implement the "word" part of wordle into the checking guess thing
 *        How are you supposed to format headers like this?
 ******************************************************************************************************/

int tileWidth, tileHeight, guessNum, charNum;
boolean won;
String ans;
Tile[][] tiles;
color bgcolor = color(200);
String[] inputWords, answerWords;

String[] correctGuesses;

void setup() {
  background(bgcolor);
  size(600, 600);
  frameRate(30);
  inputWords = loadStrings("input-words.txt");
  answerWords = loadStrings("answer-words.txt");
  guessNum = 0;
  charNum = 0;
  won = false;
  ans = answerWords[int(random(answerWords.length))];
  println("ANSWER: " + ans);
  textFont(createFont("Calisto MT Bold", 120));

  //Creates tiles
  tiles = new Tile[6][5];
  int ystart = 100; //starting y-coordinate of the first row
  tileWidth = (width - 50) / tiles[0].length - 5;
  tileHeight = (height - 65 - ystart) / tiles.length - 5;
  int y = ystart-50;
  for (Tile[] tRow : tiles) {
    y += tileHeight + 10;
    int x = 20;
    for (int j = 0; j < tRow.length; j++) {
      tRow[j] = new Tile(x, y);
      x += tileWidth + 10;
    }
  }

  //sets status of the first row
  for (Tile t : tiles[0]) t.STATE = State.GUESSING;

  //displays tiles
  for (Tile[] tRow : tiles) {
    for (Tile t : tRow) t.display();
  }

  printTitle();
}

void keyPressed() {
  if (key == '\n') {
    if (charNum < 5) return;

    if (checkGuess()) {
      println("Nice, you did it");
      setup();
      return;
    }
    guessNum++;
    charNum = 0;

    if (guessNum == 6) {
      println("6/6, u messed up, resetting.");
      setup();
      return;
    }
    
    for (Tile t : tiles[guessNum]) t.STATE = State.GUESSING;
  } else if (key == '\b') {
    if (charNum == 0) return;
    tiles[guessNum][charNum-1].ch = ' ';
    charNum--;
  } else {
    //make sure the inputted key is from A-Z, then input that into the tile
    if ((int(Character.toLowerCase(key)) >= 97 && int(Character.toLowerCase(key)) <= 122) && charNum < 5) {
      tiles[guessNum][charNum].ch = Character.toUpperCase(key);
      charNum++;
    }
  }
}
void draw() {
  background(bgcolor);
  printTitle();
  for (Tile[] tRow : tiles) {
    for (Tile t : tRow) t.display();
  }
}

void printTitle() {
  textFont(createFont("Calisto MT Bold", 120));
  textAlign(CENTER);
  fill(0);
  text("Wurdel", width / 2, 100);
}

boolean checkGuess() {
  String guess = ""; 
  for (int i = 0; i < tiles[guessNum].length; i++) {
    guess += tiles[guessNum][i].ch;
  }
  guess = guess.toLowerCase();
  
  //checks if guess was valid
  boolean valid = false;
  for (String s : inputWords) {
    if (s.equals(guess)) {
      valid = true;
      break;
    }
  }
  if (!valid) {
    println("Not Valid: " + guess);
    for (Tile t : tiles[guessNum]) {
      t.ch = ' ';
      t.c = color(100);
      t.STATE = State.GUESSING;
      t.display();
    }
    guessNum--;
    return false;
  }
  
  //now checks each character with answer
  for (int i = 0; i < tiles[0].length; i++) {
    tiles[guessNum][i].STATE = State.GUESSED;
  }
  /*
  for (int i = 0; i < guess.length(); i++) {
    for (int j = 0; j < ans.length(); j++) {
      if (guess.charAt(i) == ans.charAt(j)) {
        tiles[guessNum][i].STATE = State.CORRECT_LETTER;
      }
    }
    if (guess.charAt(i) == ans.charAt(i)) {
      tiles[guessNum][i].STATE = State.CORRECT_PLACE;
    }
  }*/
  for(int i = 0; i < ans.length(); i++){
    for(int j = 0; j < guess.length(); j++){
      if(ans.charAt(i) == guess.charAt(j)){
        tiles[guessNum][j].STATE = State.CORRECT_LETTER;
        
      }
    }
  }
  for(Tile t : tiles[guessNum]) t.display();
  return guess.equals(ans);
}
