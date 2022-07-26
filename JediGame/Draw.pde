void drawEverything() {
    background(200);
    drawEntities();
    drawBullets();
    drawPlayer();
}

void youWonScreen() {
    fill(0);
    textSize(50);
    text("You won", 50, 100); 
}

void gameOverScreen() {
    fill(0);
    textSize(50);
    text("Game Over", 50, 100); 
}

void drawEntities() {
    for (Entity entity : entities) {
        drawEntity(entity);
    }
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
            //fill(139, 69, 19);
            //strokeWeight(4);
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
