import java.util.Iterator;

void updateLogic() {
    player.move();    
    updateEntities();
    if (collidingEnemiesShouldDie) {
        killCollidingEntities();
    }
}

void killCollidingEntities() {
    for (Entity e1 : entities) {
        for (Entity e2 : entities) {
            if (e1 != e2 && areColliding(e1, e2)) {
                e1.hp = 0;
                e2.hp = 0;
            }
        }  
    }  
    
    Iterator<Entity> it = entities.iterator();
    while(it.hasNext()) {
        if (it.next().isDead()) {
            it.remove();    
        }
    }
}

// Returns true if the two supplied entities are colliding
boolean areColliding(Entity e1, Entity e2) {
    return (sqrt(sq(abs(e1.coords.x - e2.coords.x)) + sq(abs(e1.coords.y - e2.coords.y))) < e1.w/2 + e2.w/2);
}

void updateEntities() {
    setAllEntitiesUntargeted();
    markTargetedEntity();
    
    for (Entity entity : entities) {
        if (entity.isGrabbed) {
            entity.updateGrabbedVelocity();
        }
        if (entity.isBeingForcePushed) {
            entity.stopForcePushIfHitWall();
        }
        
        entity.updatePosition();
    }
    //updateGrabbedEntityVelocity();
    //updateEntitiesPositions();
}

/*
void updateEntitiesPositions() {
    for (Entity entity : entities) {
        entity.updatePosition();
    }
}

void updateGrabbedEntityVelocity() {
    if (grabbedEntity != null) {
        println(mouseX - pmouseX);
        float grabbedSpeedFactor = 0.15;
        
        //grabbedEntity.coords.x += (mouseX - pmouseX);
        //grabbedEntity.coords.y += (mouseY - pmouseY);
        
        grabbedEntity.changeVx((mouseX - pmouseX) * grabbedSpeedFactor);
        grabbedEntity.changeVy((mouseY - pmouseY) * grabbedSpeedFactor);
    }
}
*/

void setAllEntitiesUntargeted() {
    for (Entity entity : entities) {
        entity.isTargeted = false;
    }
}

Entity getTargetedEntity() {
    for (Entity entity : entities) {
        if (entity.isTargeted) {
            return entity;    
        }
    }
    return null;
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
// Otherwise, the entity with the smallest smallestAngleDiff will be targeted.
// TODO: if smallestAngleDiff is below a certain amount (40?), then distance to player OR mouse should take precedent.
//    e.g. if one entity is "right behind" another enemy, then the angle should not matter.
void markTargetedEntity() {
    if (!entities.isEmpty()) {
        // If an entity is grabbed, then it is also targetd
        for (Entity entity : entities) {
            if (entity.isGrabbed) {
                entity.isTargeted = true;
                return;
            }
        }
        
        // Angles
        float anglePlayerMouse = getAngle(player.coords.x, player.coords.y, mouseX, mouseY);
        float smallestAngleDiff = 1000;
        Entity targetedEntity = null;
        
        // Distance to mouse
        Entity closestEntity = null;
        float distClosestEntity = 1000000;
        
        for (Entity entity : entities) {
            
            // Angles
            float anglePlayerEntity = getAngle(player.coords.x, player.coords.y, entity.coords.x, entity.coords.y);
            float angleDiff = abs(anglePlayerMouse - anglePlayerEntity);
            if (angleDiff < smallestAngleDiff) {
                smallestAngleDiff = angleDiff;
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
        if (distClosestEntity < 50) {
            targetedEntity = closestEntity;
            targetedEntity.isTargeted = true;
            return;
        }
        targetedEntity.isTargeted = true;
    }
}

PVector mouseCoords() {
    return new PVector(mouseX, mouseY);    
}
