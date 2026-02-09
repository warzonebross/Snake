//Variablen und Importe
  import java.util.ArrayList;
  import processing.core.PVector;
  int tickSpeed = 200; // globale ms pro Tick
  int lastTickTime = 0; // letzte Bewegung
  int appleX; // Apfel Position X Koordinate
  int appleY; // Apfel Position Y Koordinate
  int score = 0; // Variable um den Punktestand zu speichern
  int highscore = 0; // Variable um den Highscore zu speichern
  ArrayList<PVector> snake = new ArrayList<PVector>(); // Liste um die Körperteile der Schlange zu speichern
  int directionX = 0; // Variable für die Bewegungsrichtung in X-Richtung. Positive Zahlen gehen nach rechts, negative nach links
  int directionY = 0; // Variable für die Bewegungsrichtung in Y-Richtung Positive Zahlen gehen nach unten, negative nach oben
  float headX = 0; // Anfangsposition des Kopfes X
  float headY = 0; // Anfangsposition des Kopfes Y
  boolean gameOver = false; // Variable um zu checken ob das Spiel vorbei ist

// - - - Spielzustände - - -//
  final int MENU = 0;
  final int SCHWIERIGKEIT = 1;
  final int HIGHSCORE = 2;
  final int SPIEL = 3;
  final int ENDE = 4;
  final int MODE_NORMAL = 5;

  int gameMode = MODE_NORMAL;
  int gameState = MENU;
  

void setup (){
  size(510, 450);
  background(0);
  newApple();
  snake.add(new PVector(0, 0)); // Anfangsposition des Kopfes vom Körper der Schlange
  frameRate(600); // hohe Frame Rate für flüssige Bewegung
}

void keyPressed() { // Funktion zum Erkennen des Tastendruckes auf der Tastatur
  // ---------- B für Zurück ---------- 
  if (key == 'b' || key == 'B') {
    if (gameState != MENU) {
        resetToMenu();
    }
  }

  // ---------- HAUPTMENÜ ----------
  if (gameState == MENU) {
    if (key == '1') {
        startGame();
    }
    if (key == '2') {
        gameState = SCHWIERIGKEIT;   
    }
    if (key == '3') {
        gameState = HIGHSCORE;       
    }
    return;
  }

  // ---------- SCHWIERIGKEIT ----------
  if (gameState == SCHWIERIGKEIT) { // Tickspeed Zeit in MS für eine Aktion der Schlange
    if (key == '1') tickSpeed = 400;   // leicht
    if (key == '2') tickSpeed = 300;   // mittel
    if (key == '3') tickSpeed = 120;   // schwer (Vorgegebener Standard)
    if (key == '4') tickSpeed = 50;    // extrem

    if (key == ENTER) {
      startGame(); // ENTER startet
    }
    if (key == BACKSPACE) {
      gameState = MENU; // zurück
    }
    return;
  }

  // ---------- HIGHSCORE ----------
  if (gameState == HIGHSCORE) { // Funktion um den Tastendruck im Highscore Bildschirm zu erkennen
    if (key == BACKSPACE) // Wenn Backspace gedrückt wird
        gameState = MENU; // Zurück zum Menü
    return;
  }

  // ---------- SPIEL ----------
  if (gameState == SPIEL) {
    if (keyCode == UP    && directionY != 1) { directionX = 0; directionY = -1; } // Bewegung nach oben, verhindert 180 Grad Wende
    if (keyCode == DOWN  && directionY != -1){ directionX = 0; directionY = 1; }  // Bewegung nach unten, verhindert 180 Grad Wende
    if (keyCode == LEFT  && directionX != 1) { directionX = -1; directionY = 0; } // Bewegung nach links, verhindert 180 Grad Wende
    if (keyCode == RIGHT && directionX != -1){ directionX = 1; directionY = 0; } // Bewegung nach rechts, verhindert 180 Grad Wende
    return;
  }

  // ---------- GAME OVER ----------
  if (gameState == ENDE) { // Funktion um den Tastendruck im Game Over Bildschirm zu erkennen
    if (keyCode == ENTER) { // Wenn Enter gedrückt wird
        resetToMenu(); // Zurück zum Menü
    }
  }

}

void newApple() { // Funktion um einen neuen Apfel zu generieren
    boolean validPosition = false; // Variable um zu checken ob die Position gültig ist
    while (!validPosition) { // Solange keine gültige Position gefunden wurde
        appleX = int(random(0, 16)) * 30; // Zufällige Position generieren
        appleY = int(random(0, 15)) * 30;

        validPosition = true; // Annahme: Position ist gültig
        for (PVector part : snake) { // Überprüfen ob der Apfel auf der Schlange liegt
            if (appleX == part.x && appleY == part.y) { // Apfel auf der Schlange
                validPosition = false; // Apfel auf der Schlange, nochmal generieren
                break;
            }
        }
    }
}

void moveSnake() {
    if (directionX == 0 && directionY == 0) return; // keine Bewegung
    if (gameOver) return; // Spiel gestoppt

    PVector head = snake.get(0); // Kopf der Schlange holen
    int newX = int(head.x) + directionX * 30;
    int newY = int(head.y) + directionY * 30;

    // Prüfen auf Wand-Kollision
    if (newX < 0 || newX > 480 || newY < 0 || newY > 420) {
    gameOver = true;

    // Highscore speichern
    if (score > highscore) {
        highscore = score;
    }

    gameState = ENDE;
    return;
    }

    snake.add(0, new PVector(newX, newY));

    if (newX == appleX && newY == appleY) { // Apfel gegessen
        score++; // Punktestand erhöhen
        newApple(); // Neuer Apfel
    } else {
        snake.remove(snake.size() - 1);
    }

    // Kopf-Koordinaten aktualisieren
    headX = newX;
    headY = newY;
    
    // Selbstkollision prüfen (erst nach dem Verschieben!)
    if (checkSelfCollision()) {// Funktion um zu checken ob die Schlange sich selbst trifft
        triggerGameOver();// Spiel beenden
        return;
    }
}

boolean eatAppleCheck(){ // Funktion um zu checken ob der Apfel gegessen wurde

    PVector head = snake.get(0); // Kopf der Schlange holen
    if (int(head.x) == appleX && int(head.y) == appleY){
      score = score + 1; // Punktestand erhöhen
      newApple();
      //appleExists = false;  // beim nächsten Durchlauf wird ein neuer erstellt
      return true; // Apfel wurde gegessen
    }
    return false; // Apfel wurde nicht gegessen
}

void checkTick() { // Funktion um die Zeit zu checken und die Schlange zu bewegen
    int currentTime = millis();
    if (currentTime - lastTickTime >= tickSpeed) { 
        moveSnake(); // bewegt die Schlange alle X Millisekunden
        lastTickTime = currentTime;

        // Kopf-Koordinaten aktualisieren für drawHead()
        PVector head = snake.get(0);
        headX = head.x;
        headY = head.y;
    }
}

boolean checkSelfCollision() { // Funktion um zu checken ob die Schlange sich selbst trifft
    PVector head = snake.get(0);
    for (int i = 1; i < snake.size(); i++) {
        PVector part = snake.get(i);
        if (head.x == part.x && head.y == part.y) {
            return true; // Kopf trifft Körper
        }
    }
    return false;
}

void startGame() { // Funktion um ein neues Spiel zu starten
    snake.clear();
    snake.add(new PVector(0, 0));
    headX = 0;
    headY = 0;
    directionX = 0;
    directionY = 0;
    score = 0;
    gameOver = false; //  Spiel nicht mehr vorbei
    newApple(); /// neuer Apfel

    gameState = SPIEL;
}

void setDifficulty() { // Funktion um die Schwierigkeit zu setzen
    println("Schwierigkeit wählen: 1 = leicht, 2 = normal, 3 = schwer");

    // Beispiel – echte Buttons baust du später ein
    if (key == '1') tickSpeed = 500;
    if (key == '2') tickSpeed = 300;
    if (key == '3') tickSpeed = 150;
}

void showHighscore() { // Funktion um den Highscore anzuzeigen
    println("Highscore: " + highscore);
}

void resetToMenu() { // Funktion um zum Menü zurückzukehren und das Spiel zurückzusetzen
    // Schlange zurücksetzen
    snake.clear();
    snake.add(new PVector(0, 0));

    headX = 0; // Alle Koordinaten werden auf 0 gesetzt damit eine neuer Start nicht von alten Koordinaten passiert
    headY = 0;

    directionX = 0;
    directionY = 0;

    score = 0;
    gameOver = false; // gameOver = false damit ein neues Spiel gestartet werden kann

    newApple();         // neuer Apfel
    gameState = MENU;   // zurück ins Menü
}

void triggerGameOver() { // Funktion um das Spiel zu beenden
    gameOver = true;

    // Highscore aktualisieren
    if (score > highscore) {
        highscore = score;
    }

    gameState = ENDE;  
}

void handleModeMenuInput() {

    if (key == '1') {
        gameMode = MODE_NORMAL;
        startGame();
        return;
    }
    if (key == 'b' || key == 'B') {
        gameState = SCHWIERIGKEIT;  // zurück
        return;
    }
}

// Normaler Apfel
void spawnNormalApple() {   
    newApple(); 
}