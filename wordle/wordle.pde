/*****************************************************************************************************
 *  ITS JUST WORDLE
 * BUT IN PROCESSING
 * WOW SO COOL
 * TO DO:
 *        Add Victory/Loss screen
 *        Add Keyboard
 *        (maybe?) Add animation to revealing letters
 *        How are you supposed to format headers like this?
 ******************************************************************************************************/

int tileWidth, tileHeight, guessNum, charNum;
String ans;
Tile[][] tiles;
color bgcolor = color(200);
String[] inputWords, answerWords;
String[] correctGuesses;
GameState gState;

public enum GameState {
  ONGOING,
  DEFEAT,
  VICTORY;
}

void setup() {
  background(bgcolor);
  size(600, 600);
  frameRate(30);
  inputWords = loadStrings("input-words.txt");
  answerWords = loadStrings("answer-words.txt");
  guessNum = 0;
  charNum = 0;
  gState = GameState.ONGOING;
  ans = answerWords[int(random(answerWords.length))];

  //Creates tiles
  tiles = new Tile[6][5];
  int ystart = 75; //starting y-coordinate of the first row
  int tileAreaHeight = height * 2 / 5;
  tileWidth = (width - 50) / tiles[0].length - 5;
  tileHeight = tileAreaHeight / tiles.length - 5;
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

    for (Tile t : tiles[guessNum]) t.STATE = TileState.GUESSING;
    tiles[guessNum][charNum].STATE = TileState.SELECTED;
  } else if (key == '\b') {
    if (charNum == 0) return;
    if (charNum < 5) tiles[guessNum][charNum].STATE = TileState.GUESSING;
    tiles[guessNum][charNum-1].ch = ' ';
    tiles[guessNum][charNum-1].STATE = TileState.SELECTED;
    charNum--;
  } else if (key == ' ') {
    println("Answer: " + ans);
  } else {
    //make sure the inputted key is from A-Z, then input that into the tile
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
  textFont(createFont("Calisto MT Bold", 80));
  textAlign(CENTER);
  fill(0);
  text("wurdel", width / 2, 60);
}

//Displays victory screen
void displayVictory() {
  fill(255, 255, 255, 150);
  noStroke();
  rect(0, 0, width, height);
  textFont(createFont("Calisto MT Bold", 30));
  fill(0);
  textAlign(CENTER);
  text(guessNum == 1 ? "Nice, you did it in " + guessNum + " attempt" : "Nice, you did it in " + guessNum + " attempts", width / 2, height / 2);
}

//Displays defeat screen
void displayDefeat() {
  fill(80, 50, 50, 150);
  stroke(255, 50 ,50 , 200);
  strokeWeight(30);
  int border = 50;
  rect(-border / 4, -border / 4, width+border / 2, height+border / 2, border);
  fill(255);
  textFont(createFont("Calisto MT Bold", 30));
  textAlign(CENTER);
  text("6/6 valid guesses used.", width / 2, height / 2);
  text("The answer was: " + ans, width / 2, height / 2 + 30);
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
