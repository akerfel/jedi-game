void mousePressed() {
    if (mouseButton == LEFT) {
        if (!entities.isEmpty()) {
            Entity targetedEntity = getTargetedEntity();
            targetedEntity.isGrabbed = true;
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
    player.setMove(keyCode, true);
}

void keyReleased() {
    player.setMove(keyCode, false);
    
}
