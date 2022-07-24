void drawEverything() {
    background(200);
    drawPlayer();
    drawEntities();
}

void drawEntities() {
    for (Entity entity : entities) {
        drawEntity(entity);
    }
}

void drawPlayer() {
    fill(0, 230, 0);
    circle(player.coords.x, player.coords.y, player.w);
}

void drawEntity(Entity entity) {
    fill(139, 69, 19);
    if (entity.isTargeted) {
        fill(200, 200, 200);
    }
    if (entity.isGrabbed) {
        fill(240, 0, 0);
    }
    circle(entity.coords.x, entity.coords.y, entity.w);
}
