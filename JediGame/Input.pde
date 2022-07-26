void mousePressed() {
    if (mouseButton == LEFT) {
        if (!entities.isEmpty()) {
            Entity targetedEntity = getTargetedEntity();
            if (targetedEntity != null) {
                targetedEntity.isGrabbed = true;
            }
        }
    }
    
    if (mouseButton == RIGHT) {
        for (Entity entity : entities) {
            if (entity.isGrabbed) {
                entity.initiateForcePush();
            }
        }
    }
}

void mouseReleased() {
    if (mouseButton == LEFT) {
        for (Entity entity : entities) {
            entity.isGrabbed = false;
        }
    }
}

void keyPressed() {
    switch(gameState) {
    case GAMEACTIVE:
        keysPressedGAMEACTIVE();
        break;
    case GAMEOVER:
        keysPressedGAMEOVER();
        break;
  }
}

void keysPressedGAMEACTIVE() {
    player.setMove(keyCode, true);
}

void keysPressedGAMEOVER() {
  if (key == ENTER || key == 'c' || key == ' ') {
    resetGame();
  }
}

void keyReleased() {
    player.setMove(keyCode, false);
    
}
