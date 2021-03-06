/*****************************************************************************************************
 *  ITS JUST WORDLE
 *  BUT IN PROCESSING
 *  WOW SO COOL
 *  Credits:
 *    Kelvin for part of wordle (setup(), draw(), displayTitle(), displayDefeat(), displayVictory(), checkInputKey()), Tile, Textbox, Button, and the images
 *    Vincent for part of wordle (daily mode, practice mode, checkGuess(), initKb(), kbPressed(), keyPressed(), mousePressed(), mouseReleased()), Key, and Graph
 *    jelynfish for the wordle font file
 *
 * TO DO:
 *        How are you supposed to format headers like this?
 ******************************************************************************************************/

public enum GameState {
  ONGOING,
  DEFEAT,
  VICTORY;
}

int tileSideLength, guessNum, charNum, padding;
String ans, retryButtonFile, graphButtonFile, hardButtonFile, practiceButtonFile, saveFile, dailyWordsFile, answerWordsFile, inputWordsFile, dailyWord;
color bgColor, correctColor, closeColor, incorrectColor, guessingColor, keyColor, graphColor, graphBorderColor, buttonBaseColor;
boolean hardMode, wordleDone, practiceMode;
String[] inputWords, answerWords, dailyWords;
String[] qwerty = {"Q", "W", "E", "R", "T", "Y", "U", "I", "O", "P", "A", "S", "D", "F", "G", "H", "J", "K", "L", "ENTER", "Z", "X", "C", "V", "B", "N", "M", "BACKSPACE"};
PFont text, title, graphFont;
Tile[][] tiles;
GameState gState;
Key[] keyboard;
TextBox invalidText, hardValidText, endText, modeText, dailyWordleDone, practiceText;
Button retryButton, graphButton, hardButton, practiceButton;
Graph graph;

int totalAttempts, winCount, maxStreak, curStreak;
int[] winCounts;
PrintWriter writer;

void setup() {
  practiceMode = false;
  winCounts = new int[6];
  winCount = 0;
  saveFile = "data/save.txt";
  String[] data = loadStrings(saveFile);
  totalAttempts = int(data[0]);
  for (int i = 1; i < 7; i++) {
    winCounts[i-1] = int(data[i]);
    winCount += winCounts[i-1];
  }
  maxStreak = int(data[8]);
  curStreak = int(data[7]);
  String date = data[9];
  String curdate = "" + year() + month() + day();
  if (date.equals(curdate)) {
    wordleDone = true;
  }

  background(bgColor);
  size(750, 1050);
  frameRate(60);

  dailyWordsFile = "data/daily-words.txt";
  inputWordsFile = "data/input-words.txt";
  answerWordsFile = "data/answer-words.txt";
  inputWords = loadStrings(inputWordsFile);
  answerWords = loadStrings(answerWordsFile);

  guessNum = 0;
  charNum = 0;
  ans = answerWords[int(random(answerWords.length))];
  retryButtonFile = "retry.png";
  graphButtonFile = "graph.png";
  hardButtonFile = "hard.png";
  practiceButtonFile = "target.png";
  dailyWords = loadStrings(dailyWordsFile);
  if (!wordleDone) { //if wordle hasn't been done for the day, set ans to daily word
    dailyWord = dailyWords[0];
    ans = dailyWord;
  }

  //all the colors lmfao
  bgColor = color(19);
  correctColor = color(83, 141, 78);
  closeColor = color(181, 159, 59);
  incorrectColor = color(60);
  guessingColor = color(88);
  keyColor = color(129, 131, 132);
  graphColor = color(25);
  graphBorderColor = color(36);
  buttonBaseColor = color(200);

  text = createFont("Arial Bold", 30);
  title = createFont("karnakcondensed-normal-700.ttf", 60);
  graphFont = createFont("Arial Bold", 20);

  //Creates tiles
  tiles = new Tile[6][5];
  int y = 90; //starting ypos
  padding = 10; //padding of tiles
  tileSideLength = (width - 6 * padding)/(tiles[0].length + 2);
  for (Tile[] tRow : tiles) {
    int x = padding + tileSideLength;
    for (int j = 0; j < tRow.length; j++) {
      tRow[j] = new Tile(x, y, tileSideLength);
      x += tileSideLength + padding;
    }
    y += tileSideLength + padding;
  }

  //initialize keyboard
  keyboard = new Key[28];
  initKb();

  //displays tiles
  for (Tile[] tRow : tiles) for (Tile t : tRow) t.display();

  //sets game state
  gState = GameState.ONGOING;

  //initializes text box for when needed
  dailyWordleDone = new TextBox("", 50, height / 5, width - 100, 500);
  invalidText = new TextBox("Invalid word!", 150, height / 5, width - 300, 100);
  hardValidText = new TextBox("Must use all letters from previous attempts", 50, height / 5, width - 100, 100);
  endText = new TextBox("this only appears if the game ends", 150, height / 5, width - 300, 100);
  modeText = new TextBox("Hard mode?", 150, height / 5, width - 300, 100);
  practiceText = new TextBox("Practice mode?", 150, height / 5, width - 300, 100);

  //initializes buttons
  retryButton = new Button(retryButtonFile, ButtonType.RETRY, width - 35, 35, 25);
  graphButton = new Button(graphButtonFile, ButtonType.GRAPH, width - 90, 35, 25);
  hardButton = new Button(hardButtonFile, ButtonType.HARD, width - 145, 35, 25);
  practiceButton = new Button(practiceButtonFile, ButtonType.PRACTICE, width - 145 - (145 - 90), 35, 25);

  //initializes graph
  graph = new Graph(50, width - 50, 250, height - 75);
}

void draw() {
  background(bgColor);
  printTitle();
  boolean draw = true;
  for (Tile[] tRow : tiles) for (Tile t : tRow) {
    if (t.animate || !draw) draw = false;
    t.display();
  }
  for (Key k : keyboard) k.display();

  if (graph.show && graphButton.active) {
    noStroke();
    fill(0, 0, 0, 120);
    rect(0, 0, width, height);
    graph.createGraph();
  }
  if (wordleDone && !practiceMode) {
    int seconds = (24 * 60 * 60) - (second() + 60 * minute() + 3600 * hour());
    int hours = seconds / 3600;
    seconds %= 3600;
    int minutes = seconds / 60;
    seconds %= 60;
    String timer = "Come back in:";
    String d = "Daily Wordle already finished";
    dailyWordleDone.timerStr =  "\n" + (hours / 10 == 0 ? "0" + hours : hours) + ":" + (minutes / 10 == 0 ? "0" + minutes : minutes) + ":" + (seconds / 10 == 0 ? "0" + seconds : seconds);
    dailyWordleDone.isTimer = true;
    dailyWordleDone.msg = d + "\n" + timer;
    dailyWordleDone.displayStart(5, 100);
    dailyWordleDone.font = createFont("Arial Bold", 40);
  }
  graphButton.display();
  retryButton.display();
  hardButton.display();
  practiceButton.display();
  invalidText.display();
  if (invalidText.show) return;
  hardValidText.display();
  if (hardValidText.show) return;
  modeText.display();
  if (modeText.show) return;
  practiceText.display();
  if (practiceText.show) return;
  endText.display();
  if (endText.show || graph.show) return;
  dailyWordleDone.display();
}

void mousePressed() {
  retryButton.checkHeld();
  graphButton.checkHeld();
  hardButton.checkHeld();
  practiceButton.checkHeld();
}

void mouseReleased() {
  retryButton.checkClicked();
  practiceButton.checkClicked();
  graphButton.checkClicked();
  hardButton.checkClicked();
  kbPressed();
}

void keyPressed() {
  checkInputKey(key);
}

//Prints the title;
void printTitle() {
  stroke(50);
  strokeWeight(2);
  line(30, 70, width-30, 70);
  textFont(title);
  textAlign(CENTER);
  fill(255);
  text("Wordle", width / 2, 60);
}

//Displays victory screen
void textVictory() {
  //Using ? as intended, to make code impossibly confusing to read. Here it's only being used to be grammatically accurate
  endText = new TextBox(winCount == 1 ? "Nice, you've won " + winCount + " time!" : "Nice, you've won " + winCount + " times!", 150, height / 20, width - 300, 100);
  endText.displayStart(frameRate * 4, frameRate * 1);
  graph = new Graph(50, width - 50, 250, height - 150);
  graph.show = true;
  graphButton.active = true;
  if (!wordleDone && !practiceMode) {
    wordleDone = true;
  }
}

//Displays defeat screen
void textDefeat() {
  endText = new TextBox("Correct answer: \"" + Character.toUpperCase(ans.charAt(0)) + ans.substring(1, ans.length()) + "\"", 150, height / 10, width - 300, 100);
  endText.displayStart(frameRate * 4, frameRate * 1);
  graph = new Graph(50, width - 50, 250, height - 150);
  graph.show = true;
  graphButton.active = true;
}

void initKb() {
  int gap = 8;
  int w = (width - (11 * gap)) / 10;
  int h = 80;
  int x = gap;
  int y = 90 + (6 * (tileSideLength + padding)) + 25;
  int i = 0;

  for (; i < 10; i++) {
    keyboard[i] = new Key(x, y, w, h, qwerty[i]);
    x += w + gap;
  }

  // second row
  x = gap * 2 + (w / 2);
  y += h + 1.5 * gap;
  for (; i < 19; i++) {
    keyboard[i] = new Key(x, y, w, h, qwerty[i]);
    x += w + gap;
  }

  //third row
  x = gap;
  y += h + 1.5 * gap;
  //enter
  keyboard[i] = new Key(x, y, int(gap + 1.5 * w), h, qwerty[i]);
  x += gap;
  i++;
  x += (3 * w) / 2 + gap;
  for (; i < 27; i++) {
    keyboard[i] = new Key(x, y, w, h, qwerty[i]);
    x += w + gap;
  }
  //backspace
  keyboard[i] = new Key(x, y, int(1.5 * w), h, qwerty[i]);
}

void kbPressed() {
  //if the game isn't running, dont check for keyboard inputs
  if (gState != GameState.ONGOING) return;

  //if enter key is pressed, make sure the input is valid before checking it.
  String kPressed = " ";
  for (Key i : keyboard) {
    if (i.isPressed()) {
      kPressed = i.k;
      break;
    }
  }

  //if no key was pressed, stop
  if (kPressed.equals(" ")) return;

  if (kPressed.equals("ENTER")) checkInputKey('\n');
  else if (kPressed.equals("BACKSPACE")) checkInputKey('\b');
  else checkInputKey(kPressed.charAt(0));
}

void checkInputKey(char c) {
  if (wordleDone && !practiceMode) return;
  //if the game isn't running, dont check for keyboard inputs
  if (gState == GameState.DEFEAT && c == '\n') {
    endText.displayStart(frameRate * 1, frameRate * 0.5);
  }
  if (gState != GameState.ONGOING) return;
  //if enter key is pressed, make sure the input is valid before checking it.
  if (c == '\n') {
    if (charNum < 5) return;
    if (checkGuess()) {
      guessNum++;
      gState = GameState.VICTORY;
      textVictory();
      if (practiceMode) return;
      //everything after here is when dailymode is beaten
      winCounts[guessNum-1]++;
      winCount++;
      totalAttempts++;
      curStreak++;
      //changes the daily word
      for (int i = 0; i < dailyWords.length-1; i++) {
        dailyWords[i] = dailyWords[i+1];
      }
      dailyWords[dailyWords.length-1] = dailyWord;
      PrintWriter dailyPw = createWriter(dailyWordsFile);
      for (String s : dailyWords) dailyPw.println(s);

      writer = createWriter(saveFile);
      writer.println(totalAttempts);
      for (int i : winCounts) {
        writer.println(i);
      }
      maxStreak = max(curStreak, maxStreak);
      writer.println(curStreak);
      writer.println(maxStreak);
      writer.println("" + year() + month() + day());
      writer.flush();
      writer.close();
      textVictory();
      return;
    }
    guessNum++;
    charNum = 0;
    if (guessNum == 6) {
      gState = GameState.DEFEAT;

      textDefeat();
      if (practiceMode) return;
      totalAttempts++;
      curStreak = 0;
      writer = createWriter(saveFile);
      writer.println(totalAttempts);
      for (int i : winCounts) {
        writer.println(i);
      }
      curStreak = 0;
      writer.println(curStreak);
      writer.println(maxStreak);
      writer.println("" + year() + month() + day());
      writer.flush();
      writer.close();
      return;
    }
  } else if (c == '\b') {  //removes the current character and backs up a tile
    if (charNum == 0) return;
    tiles[guessNum][charNum-1].ch = ' ';
    tiles[guessNum][charNum-1].tState = TileState.NOT_GUESSED;
    charNum--;
  } else {
    //Ensures the inputted key is from A-Z, then inputs that into the tile
    if ((Character.toLowerCase(c) >= 97 && Character.toLowerCase(c) <= 122) && charNum < 5) {
      tiles[guessNum][charNum].ch = Character.toUpperCase(c);
      tiles[guessNum][charNum].tState = TileState.GUESSING;
      charNum++;
    }
  }
}

//Checks the inputted guess
boolean checkGuess() {
  String guess = "";
  for (int i = 0; i < tiles[guessNum].length; i++) guess += tiles[guessNum][i].ch;
  guess = guess.toLowerCase();

  boolean valid = false;
  boolean hardValid = true;

  //checks if guess was valid, based on input-words.txt
  for (String s : inputWords) {
    if (s.equals(guess)) {
      valid = true;
      break;
    }
  }
  if (!valid) {
    for (Tile t : tiles[guessNum]) {
      t.ch = ' ';
      t.tState = TileState.NOT_GUESSED;
    }
    invalidText.displayStart(frameRate * 1.1, frameRate * 0.4);
    guessNum--;
    return false;
  }
  guess = guess.toUpperCase();
  //now it checks the letters compared to the answer for hard mode
  if (hardMode && guessNum > 0) {
    for (int i = 0; i < tiles[guessNum-1].length; i++) {
      if (tiles[guessNum-1][i].tState == TileState.CORRECT_PLACE) {
        if (guess.charAt(i) != tiles[guessNum-1][i].ch) {
          hardValid = false;
          break;
        }
      } else if (tiles[guessNum-1][i].tState == TileState.CORRECT_LETTER) {
        hardValid = false;
        for (int j = 0; j < guess.length(); j++) {
          if (guess.charAt(j) == tiles[guessNum-1][i].ch) {
            hardValid = true;
            break;
          }
        }
        if (!hardValid) break;
      }
    }
  }

  if (!hardValid) {
    for (Tile t : tiles[guessNum]) {
      t.ch = ' ';
      t.tState = TileState.NOT_GUESSED;
    }
    hardValidText.displayStart(frameRate * 1.1, frameRate * 0.4);
    guessNum--;
    return false;
  }
  guess = guess.toLowerCase();

  //now checks each character with answer, starting by marking each tile as writerong before updating the correct ones
  for (int i = 0; i < tiles[0].length; i++) tiles[guessNum][i].tState = TileState.GUESSED;
  //Marks characters in the correct location, and keeps a counter for keeping track of characters.
  int[] count = new int[26];
  for (int i = 0; i < ans.length(); i++) {
    count[(ans.charAt(i))-97]++;
    if (ans.charAt(i) == guess.charAt(i)) {
      tiles[guessNum][i].tState = TileState.CORRECT_PLACE;
      count[(ans.charAt(i))-97]--;
    }
  }

  //Now uses the counter to mark tiles that are in the writerong place
  for (int i = 0; i < ans.length(); i++) {
    for (int j = 0; j < guess.length(); j++) {
      //tiles[guessNum][j].tState != State.CORRECT_PLACE
      if (ans.charAt(i) == guess.charAt(j) && tiles[guessNum][j].tState != TileState.CORRECT_PLACE && count[(ans.charAt(i))-97] > 0) {
        tiles[guessNum][j].tState = TileState.CORRECT_LETTER;
        count[ans.charAt(i)-97]--;
      }
    }
  }
  //now starts the flip animation for all of them at the same time
  float flipTime = frameRate * 0.25;
  for (int i = 0; i < tiles[guessNum].length; i++) {
    tiles[guessNum][i].animateStart(int(frameCount + (i * flipTime)), flipTime);
  }
  //now adds those states to the onscreen keyboard
  for (int i = 0; i < guess.length(); i++) {
    if (tiles[guessNum][i].tState == TileState.CORRECT_PLACE) {
      //find corresponding key
      for (Key ky : keyboard) {
        if (ky.k.length() > 1) continue; //makes sure "ENTER" and "BACKSPACE" aren't used
        if (ky.k.charAt(0) == tiles[guessNum][i].ch) {
          ky.kState = KeyState.CORRECT_PLACE;
          break;
        }
      }
    } else if (tiles[guessNum][i].tState == TileState.CORRECT_LETTER) {
      for (Key ky : keyboard) {
        if (ky.k.length() > 1) continue; //makes sure "ENTER" and "BACKSPACE" aren't used
        if (ky.k.charAt(0) == tiles[guessNum][i].ch && ky.kState != KeyState.CORRECT_PLACE) {
          ky.kState = KeyState.CORRECT_LETTER;
          break;
        }
      }
    } else {
      for (Key ky : keyboard) {
        if (ky.k.length() > 1) continue; //makes sure "ENTER" and "BACKSPACE" aren't used
        if (ky.k.charAt(0) == tiles[guessNum][i].ch && ky.kState == KeyState.NOT_GUESSED) {
          ky.kState = KeyState.GUESSED;
          break;
        }
      }
    }
  }

  //displays the tiles
  return guess.equals(ans);
}
