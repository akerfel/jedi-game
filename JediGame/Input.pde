void mousePressed() {
    if (mouseButton == LEFT) {
        Entity grabbedEntity = getTargetedEntity();
        grabbedEntity.isGrabbed = true;
    }
}

void mouseReleased() {
    for (Entity entity : entities) {
        entity.isGrabbed = false;
    }
}

void keyPressed() {
    player.setMove(keyCode, true);
}

void keyReleased() {
    player.setMove(keyCode, false);
    
}
