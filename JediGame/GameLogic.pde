void updateLogic() {
    player.move();    
    markTargetedEntity();
}

void markTargetedEntity() {
    for (Entity entity : entities) {
        entity.isTargeted = false;
    }
    Entity targetedEntity = getTargetedEntity();
    targetedEntity.isTargeted = true;
}

// Gives angle between (x1, y1) and (x2, y2).
// (x1, y1) is the center of a unit circle (-180 to +180)
float getAngle(float x1, float y1, float x2, float y2) {
    pushMatrix();
    translate(x1, y1);
    float toReturn = -degrees(atan2(y2-y1, x2-x1));
    popMatrix();
    return toReturn;
}

// If the mouse is very close to an entity, then it will be targeted.
// Otherwise, the entity with the smallest angle_difference will be targeted.
// angle_difference = abs(angle_mouse_player - angle_mouse_entity)
Entity getTargetedEntity() {
    
    // Mark all entites as not targeted
    for (Entity entity : entities) {
        entity.isTargeted = false;
    }
    
    // If an entity is grabbed, then it is also targetd
    for (Entity entity : entities) {
        if (entity.isGrabbed) {
            return entity;    
        }
    }
    
    // Angles
    float angleMousePlayer = getAngle(player.coords.x, player.coords.y, mouseX, mouseY);
    float smallestEntityAngleDiff = 1000;
    Entity targetedEntity = null;
    
    // Distance to mouse
    Entity closestEntity = null;
    float distClosestEntity = 1000000;
    
    for (Entity entity : entities) {
        
        // Angles
        float angleEntity = getAngle(mouseX, mouseY, entity.coords.x, entity.coords.y);
        float entityAngleDiff = abs(angleMousePlayer - angleEntity);
        if (entityAngleDiff < smallestEntityAngleDiff) {
            smallestEntityAngleDiff = entityAngleDiff;
            targetedEntity = entity;
        }
        
        // Distance to mouse
        PVector mouseCoords = new PVector(mouseX, mouseY);
        float distEntity = mouseCoords.dist(entity.coords);
        if (distEntity < distClosestEntity) {
            distClosestEntity = distEntity;
            closestEntity = entity;
        }
        
    }
    if (distClosestEntity < 70) {
        targetedEntity = closestEntity;
    }
    
    return targetedEntity;
}
