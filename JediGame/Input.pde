void mousePressed() {
    if (mouseButton == LEFT) {
        if (!entities.isEmpty()) {
            Entity targetedEntity = getTargetedEntity();
            targetedEntity.isGrabbed = true;
            grabbedEntity = targetedEntity;
        }
    }
}

void mouseReleased() {
    for (Entity entity : entities) {
        entity.isGrabbed = false;
    }
    grabbedEntity = null;
}

void keyPressed() {
    player.setMove(keyCode, true);
}

void keyReleased() {
    player.setMove(keyCode, false);
    
}
