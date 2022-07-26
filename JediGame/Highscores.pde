import java.util.ArrayList;
import java.util.Collections;

void saveCurrentScore() {
  createHighscoresFileIfMissing();                            // create high score file if missing
  ArrayList<Integer> highscores = getHighscores();            // load data/highscores.txt into arraylist
  highscores.add(score);                                      // add score to highscores arraylist
  Collections.sort(highscores, Collections.reverseOrder());   // sort highscores arraylist
  saveHighscores(highscores);                                 // save top 10 scores in highscores arraylist
}

// If highscores.txt does not exist, create it
void createHighscoresFileIfMissing() {
  File f = dataFile("highscores.txt");  // automatically has "data/" in front
  boolean exists = f.isFile();
  if(!exists) {
    // Create "highscores.txt"
    output = createWriter("data/highscores.txt");
    output.flush(); // Writes the remaining data to the file
    output.close(); // Finishes the file
  }
}

// Load highscores.txt into int arraylist that is returned
ArrayList<Integer> getHighscores() {
  ArrayList<Integer> highscores = new ArrayList<Integer>();
  BufferedReader reader = createReader("data/highscores.txt");
  String line = null;
  try {
    while ((line = reader.readLine()) != null) {
      highscores.add(int(line));
    }
    reader.close();
  } catch (IOException e) {
    e.printStackTrace();
  }
  return highscores;
}

// Save highscores from supplied arraylist into data/highscores.txt
void saveHighscores(ArrayList<Integer> highscores) {
  output = createWriter("data/highscores.txt");
  int i = 0;
  for (int someScore :highscores) {
    output.println(str(someScore));
    i++;
    if (i >= 10) {
      break;  
    }
  }
  output.flush(); // Writes the remaining data to the file
  output.close(); // Finishes the file 
}
