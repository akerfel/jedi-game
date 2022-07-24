void mousePressed() {
    if (mouseButton == LEFT) {
        float angleMousePlayer = getAngle(player.coords.x, player.coords.y, mouseX, mouseY);
        println(angleMousePlayer);
    }
}

void keyPressed() {
    player.setMove(keyCode, true);
}

void keyReleased() {
    player.setMove(keyCode, false);
    
}
