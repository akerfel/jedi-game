void keyPressed() {
    player.setMove(keyCode, true);
}

void keyReleased() {
    player.setMove(keyCode, false);
    
    if (key == CODED) {
        if (keyCode == SHIFT) {
            player.isRunning = false;    
        }
    }
}
