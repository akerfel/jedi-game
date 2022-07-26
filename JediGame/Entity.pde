import java.util.Arrays;

public class Entity {
    PVector coords;
    boolean isLeft, isRight, isUp, isDown;
    int w; // entity width
    PVector v;
    float maxV;
    boolean isTargeted;
    boolean isGrabbed;
    int hp;
    float attackChance;
    
    public Entity(int x, int y, int w) {
        coords = new PVector(x, y);
        this.w = w;
        v = new PVector(0, 0);
        maxV = 30;
        isTargeted = false;
        isGrabbed = false;
        hp = 1;
        attackChance = enemyAttackChance;
    }
    
    void attack() {
        bullets.add(new Bullet(coords.x, coords.y));
        println("attack! " + random(0, 1));    
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
        float mousePlayerDiffX = mouseX - player.coords.x;
        float mousePlayerDiffY = mouseY - player.coords.y;
        
        float targetX = player.coords.x + grabbedLengthRatio * mousePlayerDiffX; 
        float targetY = player.coords.y + grabbedLengthRatio * mousePlayerDiffY; 
        
        setVelocityTowardsPosition(targetX, targetY);
    }
    
    // The velocity is updated so that entity will move towards (targetX, targetY).
    // The speed is proportional to how far away the target is from the entity.
    void setVelocityTowardsPosition(float targetX, float targetY) {
        float diffX = targetX - coords.x;
        float diffY = targetY - coords.y;
        
        v.x = diffX * 0.2;
        v.y = diffY * 0.2;
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
        
        float actualSpeed = sqrt(sq(v.x) + sq(v.y));
        println("actualSpeed: " + actualSpeed);
        //if (v.x > maxV) v.x = maxV;
        //if (v.x < -maxV) v.x = -maxV;
    }
    
    void updatePosition() {
        v.x *= 0.9;
        v.y *= 0.9;
        coords.x += v.x;
        coords.y += v.y;
        
        if (!collidingEnemiesShouldDie) {
            moveCollidingEntities(new ArrayList<Entity>(Arrays.asList(this)), v.x, v.y);
        }
    }
    
    boolean isDead() {
        return hp == 0;    
    }
    
    
    void initiateForcePush() {
        isGrabbed = false;
        
        float mousePlayerDiffX = mouseX - player.coords.x;
        float mousePlayerDiffY = mouseY - player.coords.y;
        
        float targetX = player.coords.x + 2 * grabbedLengthRatio * mousePlayerDiffX; 
        float targetY = player.coords.y + 2 * grabbedLengthRatio * mousePlayerDiffY; 
        
        setVelocityTowardsPosition(targetX, targetY, forcePushInitialSpeed);
    }
}
