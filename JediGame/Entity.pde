import java.util.Arrays;

public class Entity {
    PVector coords;
    float radius; // entity width
    PVector v;
    float maxV;
    boolean isTargeted;
    boolean isGrabbed;
    boolean isBeingForcePushed;
    int hp;
    float attackChance;
    color rgbColor;
    boolean isEnemy;            // If false, it is just a static object, like a stone
    
    public Entity(int x, int y, int radius, int hp, color rgbColor, boolean isEnemy) {
        coords = new PVector(x, y);
        this.radius = radius;
        v = new PVector(0, 0);
        maxV = 50;
        isTargeted = false;
        isGrabbed = false;
        this.hp = hp;
        attackChance = chanceStormtrooperAttack;
        this.rgbColor = rgbColor;
        this.isEnemy = isEnemy;
    }
    
    // Remember: velocity has direction (vector), speed does not (scalar)
    float getSpeed() {
        return sqrt(sq(v.x) + sq(v.y));
    }
    
    void moveCollidingEntities(ArrayList<Entity> alreadyMovedEntities, float grabbedVx, float grabbedVy) {
        for (Entity e1 : entities) {
            if (e1 != this && !alreadyMovedEntities.contains(e1) && areColliding(this, e1)) {
                e1.coords.x += grabbedVx;
                e1.coords.y += grabbedVy;
                alreadyMovedEntities.add(this);
                e1.moveCollidingEntities(alreadyMovedEntities, grabbedVx, grabbedVy);
            }
        }
    }
    
    // The mouse should be on a straight line stretching from the player to the entity
    void updateGrabbedVelocity() {
        float targetX = 0;
        float targetY = 0;
        
        float mousePlayerDiffX = translateMouseX() - player.coords.x;
        float mousePlayerDiffY = translateMouseY() - player.coords.y;
        
        if (grabbedEntitiesSameDistFromPlayer) {
            float resizeFactor = dist_grabbedEntitiesToPlayer / (sqrt(sq(mousePlayerDiffX) + sq(mousePlayerDiffY)));
            
            float scaledDiffX = resizeFactor * mousePlayerDiffX;
            float scaledDiffY = resizeFactor * mousePlayerDiffY;
            
            targetX = player.coords.x + scaledDiffX; 
            targetY = player.coords.y + scaledDiffY; 
        }
        else {
            targetX = player.coords.x + grabbedLengthRatio * mousePlayerDiffX; 
            targetY = player.coords.y + grabbedLengthRatio * mousePlayerDiffY; 
        }
        
        setVelocityTowardsPosition(targetX, targetY);
    }
    
    // The velocity is updated so that entity will move towards (targetX, targetY).
    // The speed is proportional to how far away the target is from the entity.
    void setVelocityTowardsPosition(float targetX, float targetY) {
        float diffX = targetX - coords.x;
        float diffY = targetY - coords.y;
        
        v.x = diffX * 0.4;
        v.y = diffY * 0.4;
        if (v.x > maxV) v.x = maxV;
        if (v.x < -maxV) v.x = -maxV;
    }
    
    // The velocity is updated so that entity will move towards (targetX, targetY).
    // The speed is specified as an argument.
    void setVelocityTowardsPosition(float targetX, float targetY, float speed) {
        float diffX = targetX - coords.x;
        float diffY = targetY - coords.y;
        
        float unscaledVx = diffX;
        float unscaledVy = diffY;
        
        // This formula was calculated by solving an equation system using the pythagorean theorem.
        float resizeFactor = speed / (sqrt(sq(unscaledVx) + sq(unscaledVy)));
        
        v.x = resizeFactor * unscaledVx;
        v.y = resizeFactor * unscaledVy;
        
        //if (v.x > maxV) v.x = maxV;
        //if (v.x < -maxV) v.x = -maxV;
    }
    
    // Returns true if entity is on screen
    boolean isOnScreen() {
        return coords.x > upperLeftX() - radius && 
               coords.x < upperLeftX() + width + radius && 
               coords.y > upperLeftY() - radius && 
               coords.y < upperLeftY() + height + radius;
    }
    
    // Returns true if entity is or is almost on screen
    boolean isAlmostOnScreen() {
        int extra = 500;
        return coords.x > upperLeftX() - radius - extra && 
               coords.x < upperLeftX() + width + radius + extra && 
               coords.y > upperLeftY() - radius - extra && 
               coords.y < upperLeftY() + height + radius + extra;
    }
    
    void updatePosition() {
        v.x *= deacellerationFactor;
        v.y *= deacellerationFactor;
        coords.x += v.x;
        coords.y += v.y;
        
        if (!collidingEnemiesShouldDie) {
            moveCollidingEntities(new ArrayList<Entity>(Arrays.asList(this)), v.x, v.y);
        }
    }
    
    boolean isDead() {
        return hp <= 0;    
    }
    
    void initiateForcePush() {
        isGrabbed = false;
        isBeingForcePushed = true;
        
        float mousePlayerDiffX = translateMouseX() - player.coords.x;
        float mousePlayerDiffY = translateMouseY() - player.coords.y;
        
        float targetX = player.coords.x + 2 * grabbedLengthRatio * mousePlayerDiffX; 
        float targetY = player.coords.y + 2 * grabbedLengthRatio * mousePlayerDiffY; 
        
        setVelocityTowardsPosition(targetX, targetY, forcePushInitialSpeed);
    }
}
