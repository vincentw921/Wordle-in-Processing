/*****************************************************************************************************
 *  ITS JUST WORDLE
 * BUT IN PROCESSING
 * WOW SO COOL
 * TO DO:
 *        Add statistics to victory/death screen?
 *        Add Keyboard
 *        (maybe?) Add animation to revealing letters
 *        How are you supposed to format headers like this?
 ******************************************************************************************************/

public enum GameState {
  ONGOING,
  DEFEAT,
  VICTORY;
}

int tileWidth, tileHeight, guessNum, charNum, invalidCount;
String ans;
color bgcolor = color(200);
String[] inputWords, answerWords;
String[] correctGuesses;
Tile[][] tiles;
GameState gState;

void setup() {
  background(bgcolor);
  size(600, 1100);
  frameRate(30);
  inputWords = loadStrings("input-words.txt");
  answerWords = loadStrings("answer-words.txt");
  guessNum = 0;
  charNum = 0;
  invalidCount = 0;
  gState = GameState.ONGOING;
  ans = answerWords[int(random(answerWords.length))];
  //Creates tiles
  tiles = new Tile[6][5];
  
  //TO DO: Figure out why the tile's positions is offset by a certain percentage
  tileWidth = (width - 135) / tiles[0].length - 5;
  tileHeight = tileWidth;
  int y = -10;
  for (Tile[] tRow : tiles) {
    y += tileHeight + 10;
    int x = 65;
    for (int j = 0; j < tRow.length; j++) {
      tRow[j] = new Tile(x, y);
      x += tileWidth + 10;
    }
  }

  //sets status of the first row
  for (Tile t : tiles[0]) t.STATE = TileState.GUESSING;
  tiles[guessNum][charNum].STATE = TileState.SELECTED;

  //displays tiles
  for (Tile[] tRow : tiles) for (Tile t : tRow) t.display();

  println("Press space to print the answer");
  printTitle();
}

void keyPressed() {
  //if the game isn't running, dont check for keyboard inputs
  if (gState != GameState.ONGOING) return;

  //if enter key is pressed, make sure the input is valid before checking it.
  if (key == '\n') {
    if (charNum < 5) return;
    if (checkGuess()) {
      gState = GameState.VICTORY;
      return;
    }
    guessNum++;
    charNum = 0;
    if (guessNum == 6) {
      gState = GameState.DEFEAT;
      return;
    }

    //the guess has already been calculated, now to update the new row's tiles
    for (Tile t : tiles[guessNum]) t.STATE = TileState.GUESSING;
    tiles[guessNum][charNum].STATE = TileState.SELECTED;
  } else if (key == '\b') {  //removes the current character and backs up a tile
    if (charNum == 0) return;
    if (charNum < 5) tiles[guessNum][charNum].STATE = TileState.GUESSING;
    tiles[guessNum][charNum-1].ch = ' ';
    tiles[guessNum][charNum-1].STATE = TileState.SELECTED;
    charNum--;
  } else if (key == ' ') { //shows the answer
    println("Answer: " + ans);
  } else {
    //Ensures the inputted key is from A-Z, then inputs that into the tile
    if ((int(Character.toLowerCase(key)) >= 97 && int(Character.toLowerCase(key)) <= 122) && charNum < 5) {
      tiles[guessNum][charNum].ch = Character.toUpperCase(key);
      tiles[guessNum][charNum].STATE = TileState.GUESSING;
      charNum++;
      tiles[guessNum][min(4, charNum)].STATE = TileState.SELECTED;
    }
  }
}

void draw() {
  background(bgcolor);
  printTitle();
  for (Tile[] tRow : tiles) for (Tile t : tRow) t.display();
  if (gState == GameState.VICTORY) displayVictory();
  if (gState == GameState.DEFEAT) displayDefeat();
}

//Prints the title;
void printTitle() {
  textFont(createFont("karnakcondensed-normal-700.ttf", 80));
  textAlign(CENTER);
  fill(0);
  text("Wordle", width / 2, 75);
}

//Displays victory screen
void displayVictory() {
  fill(255, 255, 255, 150);
  noStroke();
  rect(0, 0, width, height);
  textFont(createFont("Calisto MT Bold", 30));
  fill(0);
  textAlign(CENTER);
  //using the ? as intended, to make code harder to read

  text(guessNum == 1 ? "Nice, you did it in " + guessNum + " attempt" : "Nice, you did it in " + guessNum + " attempts", width / 2, height / 2);
}

//Displays defeat screen
void displayDefeat() {
  fill(80, 50, 50, 150);
  stroke(255, 50, 50, 200);
  int border = 50;
  strokeWeight(border);
  rect(-border / 4, -border / 4, width + border / 2, height + border / 2, border);
  fill(255);
  textFont(createFont("Calisto MT Bold", 30));
  textAlign(CENTER);
  text("6/6 valid guesses used.\nThe answer was: " + ans, width / 2, height / 2);
}

//Checks the inputted guess
boolean checkGuess() {
  String guess = "";
  for (int i = 0; i < tiles[guessNum].length; i++) guess += tiles[guessNum][i].ch;
  guess = guess.toLowerCase();

  //checks if guess was valid, based on input-words.txt
  boolean valid = false;
  for (String s : inputWords) {
    if (s.equals(guess)) {
      valid = true;
      break;
    }
  }
  if (!valid) {
    invalidCount++;
    println("Not a valid input: " + guess);
    for (Tile t : tiles[guessNum]) {
      t.ch = ' ';
      t.c = color(100);
      t.STATE = TileState.GUESSING;
      t.display();
    }
    guessNum--;
    return false;
  }

  //now checks each character with answer
  for (int i = 0; i < tiles[0].length; i++) tiles[guessNum][i].STATE = TileState.GUESSED;

  //Marks characters in the correct location, and keeps a counter for keeping track of characters.
  int[] count = new int[26];
  for (int i = 0; i < ans.length(); i++) {
    count[((int)ans.charAt(i))-97]++;
    if (ans.charAt(i) == guess.charAt(i)) {
      tiles[guessNum][i].STATE = TileState.CORRECT_PLACE;
      count[((int)ans.charAt(i))-97]--;
    }
  }

  //Now uses the counter to mark tiles that are in the wrong place
  for (int i = 0; i < ans.length(); i++) {
    for (int j = 0; j < guess.length(); j++) {
      //tiles[guessNum][j].STATE != State.CORRECT_PLACE
      if (ans.charAt(i) == guess.charAt(j) && tiles[guessNum][j].STATE != TileState.CORRECT_PLACE && count[((int)ans.charAt(i))-97] > 0) {
        tiles[guessNum][j].STATE = TileState.CORRECT_LETTER;
        count[((int)ans.charAt(i))-97]--;
      }
    }
  }

  //displays the tiles
  for (Tile t : tiles[guessNum]) t.display();
  return guess.equals(ans);
}
