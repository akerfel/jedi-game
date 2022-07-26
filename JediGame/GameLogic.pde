import java.util.Iterator;

void updateLogic() {
    randomlySpawnEnemies();
    
    player.move();    
    updateEntities();
    updateBullets();
    
    removeDeadEntities();
    removeDeadBullets();
    checkIfGameOver();
}

void spawnEnemyOnEdge() {
    int spawnX = int(random(0, width));
    int spawnY = int(random(0, height));
    
    int randWallNum = int(random(0, 4));
    
    switch(randWallNum) {
      case 0: 
        spawnY = entityWidth;
        break;
      case 1: 
        spawnY = height - entityWidth;
        break;
      case 2: 
        spawnX = entityWidth;
        break;
      case 3: 
        spawnX = width - entityWidth;
        break;
    }
    
    entities.add(new Entity(spawnX, spawnY, entityWidth));
}

void randomlySpawnEnemies() {
    if (random(0, 1) < chanceEnemySpawn) {
        int randX = int(random(0, width));
        int randY = int(random(0, height));
        spawnEnemyOnEdge();
    }
}

void updateEntities() {
    updateEntityPositions();
    makeEntitiesRandomlyAttack();
    if (collidingEnemiesShouldDie) {
        killCollidingEntities();
    }
    if (fastEntitiesAreLethal) {
        killFastCollidingEntities();
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
}

void killFastCollidingEntities() {
    for (Entity e1 : entities) {
        //println("e1.getSpeed() " + e1.getSpeed());
        if (e1.getSpeed() > lethalEntitySpeed) {
            for (Entity e2 : entities) {
                if (e1 != e2 && areTouching(e1, e2)) {
                    println("Lethal speed: " + e1.getSpeed() + "/" + lethalEntitySpeed);
                    e1.hp = 0;
                    e2.hp = 0;
                }
            }    
        }    
    }
}

void updateBullets() {
    updateBulletPositions();
    damagePlayerIfTouchesBullet();
    damageEnemiesWhoTouchBullets();
}

void checkIfGameOver() {
    if (player.isDead()) {
        gameOver = true;  
        saveCurrentScore();  // will only save if actually is new highscore
    }
}

void removeDeadEntities() {
    Iterator<Entity> it = entities.iterator();
    while(it.hasNext()) {
        if (it.next().isDead()) {
            it.remove();    
            wilhelmScreamSound.play();
            score++;
        }
    }
}

void removeDeadBullets() {
    Iterator<Bullet> it = bullets.iterator();
    while(it.hasNext()) {
        if (it.next().isDead()) {
            it.remove();    
        }
    }
}

void damagePlayerIfTouchesBullet() {
    for (Bullet bullet : bullets) {
        if (areColliding(player, bullet)) {
            player.damage(1);
            bullet.hp--; // yes, bullets have hp
        }
    }  
}

void damageEnemiesWhoTouchBullets() {
    for (Entity e : entities) {
        for (Bullet b : bullets) {
            if (areColliding(e, b)) {
                e.hp--;
                b.hp--; // yes, bullets have hp
            }
        }  
    }  
}

void updateBulletPositions() {
    for (Bullet bullet : bullets) {
        bullet.updatePosition();    
    }
}

void makeEntitiesRandomlyAttack() {
    for (Entity entity : entities) {
        if (!entity.isGrabbed && random(0, 1) < entity.attackChance) {
            entity.attack();    
        }
    }
}

// Returns true if the two entities are colliding
boolean areColliding(Entity e1, Entity e2) {
    return (sqrt(sq(abs(e1.coords.x - e2.coords.x)) + sq(abs(e1.coords.y - e2.coords.y))) < e1.w/2 + e2.w/2);
}

// Returns true if the two entities are touching
boolean areTouching(Entity e1, Entity e2) {
    return (sqrt(sq(abs(e1.coords.x - e2.coords.x)) + sq(abs(e1.coords.y - e2.coords.y))) < 1.15 * (e1.w/2 + e2.w/2));
}

// Returns true if the entity is collding with the bullet
boolean areColliding(Entity e, Bullet b) {
    return (sqrt(sq(abs(e.coords.x - b.coords.x)) + sq(abs(e.coords.y - b.coords.y))) < e.w/2 + b.w/2);
}

// Returns true if the bullet is collding with the player
boolean areColliding(Player p, Bullet b) {
    return (sqrt(sq(abs(p.coords.x - b.coords.x)) + sq(abs(p.coords.y - b.coords.y))) < p.w/2 + b.w/2);
}

void updateEntityPositions() {
    setAllEntitiesUntargeted();
    markTargetedEntity();
    
    for (Entity entity : entities) {
        if (entity.isGrabbed) {
            entity.updateGrabbedVelocity();
        }
        
        entity.updatePosition();
    }
}

void setAllEntitiesUntargeted() {
    for (Entity entity : entities) {
        entity.isTargeted = false;
    }
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

// Return targeted entity if there is one, otherwise returns null.
Entity getTargetedEntity() {
    for (Entity entity : entities) {
        if (entity.isTargeted) {
            return entity;    
        }
    }
    return null;
}

// If the mouse is very close to an entity, then it will be targeted.
// Otherwise, the entity with the smallest smallestAngleDiff will be targeted.
// TODO: if smallestAngleDiff is below a certain amount (40?), then distance to player OR mouse should take precedent.
//    e.g. if one entity is "right behind" another enemy, then the angle should not matter.
void markTargetedEntity() {
    if (!entities.isEmpty()) {
        
        // If an entity is grabbed, then it is also targeted
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
            // Entity must be visible to be grabbed
            if (entity.coords.x > -entity.w/2 && entity.coords.x < width + entity.w/2 && entity.coords.y > -entity.w/2 && entity.coords.x < height + entity.w/2) {
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
        }
        if (targetedEntity == null) {
            return;
        }
        
        // Distance to mouse
        if (distClosestEntity < 50) {
            targetedEntity = closestEntity;
            targetedEntity.isTargeted = true;
            return;
        }
        
        // Angles
        targetedEntity.isTargeted = true;
    }
}

PVector mouseCoords() {
    return new PVector(mouseX, mouseY);    
}
