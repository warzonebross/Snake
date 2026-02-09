void draw() {
    if (gameState == MENU) {
        drawMenu();
        return;
    }
    if (gameState == SPIEL) {
        background(0,250,0); // Hintergrundfarbe während des Spiels
        drawGrid();
        drawApple();
        drawSnakeBody();
        drawHead();

        if (!gameOver) {
            checkTick();
        } else {
            gameState = ENDE;
        }

        return;
    }
    if (gameState == ENDE) {
        drawGameOverScreen();
        return;
    }
        background(0,200,50);
    fill(255);
    textSize(40);
    text("SNAKE", width/2 - 80, 100);

    textSize(20);
    text("1 = Start", width/2 - 80, 200);
    text("2 = Schwierigkeit", width/2 - 80, 240);
    text("3 = Highscore", width/2 - 80, 280);
     if (gameState == MENU) {
     drawMenu();
     return;
  
  }
  else if (gameState == SCHWIERIGKEIT) {
      drawDifficultyMenu();
  }

  else if (gameState == HIGHSCORE) {
      drawHighscoreMenu();
  }
  else if (gameState == SPIEL) {
      startGame();
  }
  else if (gameState == ENDE) {
      drawGameOverScreen();
  }
}




void drawGrid() {
  stroke (0,200,0); // Linienfarbe
  strokeWeight(2);
  
  for(int i=0; i<510; i=i+30){ //i=0 also der Startpunkt, i ist kleiner als 450 also das Ziel und i ist gleich i plus 30 damit dieser Hochrechnet
    line(i,0,i,510); // das i was hochgezählt wird immer, ersetzt die X und Y koordinaten
  }  
  for(int i=0; i< 510; i=i+30){// die horizontalen Linien also die X Koordinaten die an der y Achse runter gehen
    line(0,i,510,i);
  }
}

void drawHead(){ // Funktion um den Kopf der Schlange zu zeichnen
  fill(0,0,255); // Farbe des Kopfes
  stroke(255,255,255); // Umrandungsfarbe
  strokeWeight(1);// Umrandungsdicke
  square(headX +2,headY+2,25);// Koordinaten wo das Quadrat erscheint: X Koordinate, Y koordinate und dann Durchmesser
  circle(headX +10, headY +10,5); // Auge links
  circle(headX +20, headY+10 ,5); // Auge rechts
  line (headX +10, headY +20, headX +20, headY +20); // Mund
}

void drawApple (){ // soll den Apfel erstellen, betonung auf soll XD
  fill(255,0,0);
  stroke(255,255,255);
  strokeWeight(1);
  circle( appleX+ 15, appleY + 15, 25);
}

void drawSnakeBody(){ // Funktion um den Körper der Schlange zu zeichnen
    fill(0,150,250); // Farbe des Körpers
    stroke(255,255,255); // Umrandungsfarbe
    strokeWeight(1);// Umrandungsdicke
    for (int i = 0; i < snake.size(); i++){
      PVector part = snake.get(i); // Körperteil holen
      square(part.x + 2, part.y + 2, 25); // Körperteil zeichnen
    }
}

  void drawMenu() {   // Funktion um das Menü zu zeichnen
    background(50,200,50);
    fill(255);
    textSize(40);
    text("SNAKE", width/2 - 80, 100);

    textSize(20);
    text("Drücke 1 = Start", width/2 - 80, 200);
    text("Drücke 2 = Schwierigkeit", width/2 - 80, 240);
    text("Drücke 3 = Highscore", width/2 - 80, 280);
}

void drawGameOverScreen() { // Funktion um den Game Over Bildschirm zu zeichnen
  background(255);

  fill(255, 0, 0);
  textSize(40);
  text("GAME OVER", width/2 - 120, height/2 - 40);

  fill(0);
  textSize(20);
  text("Score: " + score, width/2 - 60, height/2 + 10);
  text("Highscore: " + highscore, width/2 - 70, height/2 + 40);

  textSize(16);
  text("Drücke ENTER für Menü", width/2 - 100, height/2 + 80);
}

void drawDifficultyMenu() { // Funktion um das Schwierigkeitsmenü zu zeichnen
    background(0);
    fill(255);
    textSize(30);
    text("Schwierigkeit wählen", width/2 - 150, 100); // erst weite dann höhe Wert

    textSize(20);
    text("1 = Leicht (400ms)", width/2 - 120, 160);
    text("2 = Normal (300ms)", width/2 - 120, 200);
    text("3 = Schwer (120ms)", width/2 - 120, 240);
    text("4 = Extrem (50ms)", width/2 - 120, 280);

    text("B = Zurück", width/2 - 120,400); 
    text("ENTER = Start", width/2 - 120, 320);
    text("BACKSPACE = Exit", width/2 - 120, 360);
}

void drawHighscoreMenu() { // Funktion um das Highscore Menü zu zeichnen
    background(0);
    fill(255);
    textSize(30);
    text("Highscore", width/2 - 100, 120);

    textSize(20);
    text("Punkte: " + highscore, width/2 - 80, 200);

    text("BACKSPACE = Zurück", width/2 - 120, 320);
}

void drawModeMenu() {
    background(20);

    fill(255);
    textSize(32);
    text("MODUS AUSWÄHLEN", width/2 - 150, 80);

    textSize(22);
    text("1 – Normal (nur Äpfel)", width/2 - 150, 150);
    text("2 – Giftfrüchte (Achtung: sofort tot)", width/2 - 150, 190);
    text("3 – Bonusfrüchte (+3 Punkte)", width/2 - 150, 230);
    text("4 – Mix (Äpfel, Bonus & Gift)", width/2 - 150, 270);

    fill(180);
    textSize(18);
    text("B – Zurück", width/2 - 50, 340);
}
