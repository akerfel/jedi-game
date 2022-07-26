void drawEverything() {
    background(200);
    drawEntities();
    drawBullets();
    drawPlayer();
    drawScore();
    drawFPS();
}

void drawScore() {
  fill(color(255, 255, 255));
  textSize(32);
  text(score, width - 60, 60);
}

void drawGameOver() {
  fill(255, 255, 255);
  textAlign(CENTER);
  text("GAME OVER", width/2, 50);
  fill(0, 200, 0);
  text("Score: " + score, width/2, 100);
  fill(255, 255, 255);
  text("Restart: Space", width/2, 150);
  fill(255, 255, 255);
  text("Highscores:", width/2, 200);
  drawHighScores();
}

void drawHighScores() {
  ArrayList<Integer> highscores = getHighscores();
  for (int i = 0; i < highscores.size(); i++) {
    int scoreToPrint = highscores.get(i);
    if (scoreToPrint == score && (i == highscores.size() - 1 || (i < highscores.size() - 1 && highscores.get(i+1) != score))) {
        fill(0, 200, 0);
    }
    else {
      fill(255, 255, 255);
    }
    text((i+1) + ". " + str(scoreToPrint), width/2, 250 + i * 50);
  }
  rectMode(CORNER);
}

void drawEntities() {
    for (Entity entity : entities) {
        drawEntity(entity);
    }
}

void drawFPS() {
  fill(220);
  text(int(frameRate), 20, 30); 
}

void drawEntity(Entity entity) {
    fill(139, 69, 19);
    
    strokeWeight(1); // default
    
    if (targetedEntityShouldBeHighlighted) {
        if (entity.isTargeted) {
            
            // highlight version 1: circle around
            //fill(200, 200, 200);
            //circle(entity.coords.x, entity.coords.y, entity.w * 2);
            
            // highlight version 2: thicker stroke
            fill(139, 69, 19);
            strokeWeight(4);
        }
    }
    
    if (entity.isGrabbed) {
        fill(240, 0, 0);
    }
    circle(entity.coords.x, entity.coords.y, entity.w);
}

void drawBullets() {
    for (Bullet bullet : bullets) {
        drawBullet(bullet);    
    }
}

void drawBullet(Bullet bullet) {
    fill(0, 0, 255);
    circle(bullet.coords.x, bullet.coords.y, bullet.w);
}

void drawPlayer() {
    fill(0, 230, 0);
    circle(player.coords.x, player.coords.y, player.w);
}
