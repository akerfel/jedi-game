void drawEverything() {
    background(200);
    drawTranslatedObjects();
    drawHud();
}

// translate() is needed to move the "camera" such that the player in at the center.
void drawTranslatedObjects() {
    pushMatrix();
    translate(width/2 - player.coords.x, height/2 - player.coords.y);
    drawEntities();
    drawBullets();
    drawPlayer();
    drawEnemyPointers();
    popMatrix();
}

void drawHud() {
    drawScore();
    drawNumOfEntities();
    drawFPS();
}

void drawScore() {
  fill(color(255, 255, 255));
  textSize(20);
  text("Score: " + score, width - 120, 30);
}

void drawNumOfEntities() {
  fill(color(255, 255, 255));
  textSize(20);
  text("Entities: " + entities.size(), width - 120, 50);
}

void drawGameOver() {
  textSize(32);
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
  text(int(frameRate), 10, 20); 
}

void drawEntity(Entity entity) {
    fill(entity.rgbColor);
    
    strokeWeight(1); // default
    
    if (targetedEntityShouldBeHighlighted) {
        if (entity.isTargeted) {
            
            // highlight version 1: circle around
            //fill(200, 200, 200);
            //circle(entity.coords.x, entity.coords.y, entity.radius * 2);
            
            // highlight version 2: thicker stroke
            fill(139, 69, 19);
            strokeWeight(4);
        }
    }
    
    if (entity.isGrabbed) {
        fill(255, 165, 0);
    }
    circle(entity.coords.x, entity.coords.y, entity.radius*2);
    
    if (entity.hp != 1) {
        textAlign(CENTER, CENTER);
        fill(200);
        textSize(32);
        text(entity.hp, entity.coords.x, entity.coords.y);
        textAlign(BASELINE);
    }
}

// Draws a pointer for each enemy which is off-screen
void drawEnemyPointers() {
    for (Entity entity : entities) {
        if (entity.isEnemy && !entity.isOnScreen()) {
            drawEntityPointer(entity);    
        }
    }
}

void drawEntityPointer(Entity entity) {
    fill(entity.rgbColor);
    int pointerX = int(entity.coords.x);
    int pointerY = int(entity.coords.y);
    int edgeOffset = 50;
    if (pointerX < upperLeftX()) {
        pointerX = upperLeftX() + edgeOffset;
    }
    else if (pointerX > upperLeftX() + width) {
        pointerX = upperLeftX() + width - edgeOffset;    
    }
    if (pointerY < upperLeftY()) {
        pointerY = upperLeftY() + edgeOffset;
    }
    else if (pointerY > upperLeftY() + height) {
        pointerY = upperLeftY() + height - edgeOffset;    
    }
    
    fill(calcEntityColorBasedOnDistanceFromPlayer(entity));
    
    circle(pointerX, pointerY, entityPointerRadius * 2);
}

color calcEntityColorBasedOnDistanceFromPlayer(Entity entity) {
    float dist = sqrt(sq(player.coords.x - entity.coords.x) + sq(player.coords.y - entity.coords.y));
    float minDist = width/2;               // If the entity is at this distance, the "maximum closeness color" will be picked
    float maxDist = width/2 * 2;           // If the entity is at this distance, the "maximum distance color" will be picked
    float percentageOfMaxDist = (dist - minDist) / maxDist;
    println(percentageOfMaxDist);
    
    return color(255 * (1 - percentageOfMaxDist), 255 * (1 - percentageOfMaxDist), 255 * (1 - percentageOfMaxDist));
}

void drawBullets() {
    for (Bullet bullet : bullets) {
        drawBullet(bullet);    
    }
}

void drawBullet(Bullet bullet) {
    fill(255, 0, 0);
    circle(bullet.coords.x, bullet.coords.y, bullet.radius*2);
}

void drawPlayer() {
    fill(0, 230, 0);
    circle(player.coords.x, player.coords.y, player.radius*2);
}
