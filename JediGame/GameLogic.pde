import java.util.Iterator;

void updateLogic() {
    handleEnemySpawning();
    
    player.move();    
    updateEntities();
    updateBullets();
    
    removeDeadEntities();
    removeDeadBullets();
    checkIfGameOver();
}

void updateEntities() {
    updateEntityPositions();
    makeEntitiesRandomlyAttack();
    if (collidingEnemiesShouldDie) {
        damageCollidingEntities();
    }
    if (fastEntitiesAreLethal) {
        damageFastCollidingEntities();
    }
    unmarkEntitiesWhoAreNoLongerBeingForcePushed();
}

void updateBullets() {
    updateBulletPositions();
    damagePlayerIfTouchesBullet();
    damageEntitiesWhoTouchBullets();
}

void spawnInitialEntities() {
    for (int i = 0; i < numStartEnemies; i++) {
        spawnStormtrooperOnEdge();
    }
    spawnBox(30, 30);
}

void handleEnemySpawning() {
    if (enemiesSpawnOnIntervall) {
        updateStormtrooperSpawnTimer();
    }
    else {
        randomlySpawnEnemies();
    }
}

// Spawns a box at location (x, y)
void spawnBox(int x, int y) {
    entities.add(new Box(x, y));
}

// Spawns a stormtrooper at location (x, y)
void spawnStormtrooper(int x, int y) {
    entities.add(new Stormtrooper(x, y));
}

void spawnStormtrooperOnEdge() {
    int spawnX = int(random(0, width));
    int spawnY = int(random(0, height));
    
    int randWallNum = int(random(0, 4));
    
    switch(randWallNum) {
      case 0: 
        spawnY = stormtrooperRadius;
        break;
      case 1: 
        spawnY = height - stormtrooperRadius;
        break;
      case 2: 
        spawnX = stormtrooperRadius;
        break;
      case 3: 
        spawnX = width - stormtrooperRadius;
        break;
    }
    
    spawnStormtrooper(spawnX, spawnY);
}

void unmarkEntitiesWhoAreNoLongerBeingForcePushed() {
    for (Entity entity : entities) {
        if (entity.isBeingForcePushed && entity.getSpeed() < 0.05) {
            entity.isBeingForcePushed = false;
        }
    }
}

void damageCollidingEntities() {
    for (Entity e1 : entities) {
        for (Entity e2 : entities) {
            if (e1 != e2 && areColliding(e1, e2)) {
                e1.hp--;
                e2.hp--;
            }
        }  
    }
}

void damageFastCollidingEntities() {
    for (Entity e1 : entities) {
        //println("e1.getSpeed() " + e1.getSpeed());
        if (e1.getSpeed() > lethalEntitySpeed) {
            for (Entity e2 : entities) {
                if (e1 != e2 && areTouching(e1, e2)) {
                    println("Lethal speed: " + e1.getSpeed() + "/" + lethalEntitySpeed);
                    e1.hp--;
                    e2.hp--;
                }
            }    
        }    
    }
}

void updateStormtrooperSpawnTimer() {
    stormtrooperSpawnTimer--;
    if (stormtrooperSpawnTimer < 0) {
        spawnStormtrooperOnEdge();
        stormtrooperSpawnTimer = int(stormtrooperSpawnTimerInterval / spawnMultiplier);
    }
}

void randomlySpawnEnemies() {
    if (random(0, 1) / spawnMultiplier < chanceEnemySpawn) {
        spawnStormtrooperOnEdge();
    }
}

void checkIfGameOver() {
    if (player.isDead()) {
        gameOver();
        gameState = gameState.GAMEOVER;  
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

void damageEntitiesWhoTouchBullets() {
    for (Entity e : entities) {
        for (Bullet b : bullets) {
            if (!e.isEnemy || (!onlyForceControlledEnemiesDieFromBullets || (e.isGrabbed || e.isBeingForcePushed))) {
                if (areColliding(e, b)) {
                    e.hp--;
                    b.hp--; // yes, bullets have hp
                }
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
        if (!entity.isGrabbed && random(0, 1) < entity.attackChance && entity instanceof Enemy) {
            ((Enemy) entity).attack();    
        }
    }
}

// Returns true if the two entities are colliding
boolean areColliding(Entity e1, Entity e2) {
    return (sqrt(sq(abs(e1.coords.x - e2.coords.x)) + sq(abs(e1.coords.y - e2.coords.y))) < e1.radius + e2.radius);
}

// Returns true if the two entities are touching
boolean areTouching(Entity e1, Entity e2) {
    return (sqrt(sq(abs(e1.coords.x - e2.coords.x)) + sq(abs(e1.coords.y - e2.coords.y))) < 1.15 * (e1.radius + e2.radius));
}

// Returns true if the entity is collding with the bullet
boolean areColliding(Entity e, Bullet b) {
    return (sqrt(sq(abs(e.coords.x - b.coords.x)) + sq(abs(e.coords.y - b.coords.y))) < e.radius + b.radius);
}

// Returns true if the bullet is collding with the player
boolean areColliding(Player p, Bullet b) {
    return (sqrt(sq(abs(p.coords.x - b.coords.x)) + sq(abs(p.coords.y - b.coords.y))) < p.radius + b.radius);
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
            if (entity.coords.x > -entity.radius && entity.coords.x < width + entity.radius && entity.coords.y > -entity.radius && entity.coords.x < height + entity.radius) {
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
