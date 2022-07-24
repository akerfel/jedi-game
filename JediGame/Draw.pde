void drawEverything() {
    background(200);
    drawPlayer();
    drawBoxes();
}

void drawBoxes() {
    for (Box box : boxes) {
        drawBox(box);
    }
}

void drawPlayer() {
    fill(255, 0, 0);
    circle(player.coords.x, player.coords.y, player.w);
}

void drawBox(Box box) {
    fill(139, 69, 19);
    circle(box.coords.x, box.coords.y, player.w);
}
