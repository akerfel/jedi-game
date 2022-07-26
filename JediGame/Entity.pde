import java.util.Arrays;

public class Entity {
    PVector coords;
    boolean isLeft, isRight, isUp, isDown;
    int w; // width
    PVector v;
    float maxV;
    boolean isTargeted;
    boolean isGrabbed;
    int hp;
    boolean isBeingForcePushed;
    
    public Entity(float x, float y) {
        coords = new PVector(x, y);
        w = 30;
        v = new PVector(0, 0);
        maxV = 60;
        isTargeted = false;
        isGrabbed = false;
        hp = 1;
        isBeingForcePushed = false;
    }
    
    public Entity(float x, float y, int w) {
        coords = new PVector(x, y);
        this.w = w;
        v = new PVector(0, 0);
        maxV = 30;
        isTargeted = false;
        isGrabbed = false;
        hp = 1;
    }
    
    void moveCollidingEntities(ArrayList<Entity> alreadyMovedEntities, float grabbedVx, float grabbedVy) {
        for (Entity e1 : entities) {
            if (e1 != this && !alreadyMovedEntities.contains(e1) && areColliding(this, e1)) {
                e1.coords.x += grabbedVx;
                e1.coords.y += grabbedVy;
                
                // Don't let entity leave screen
                if (e1.coords.x - w/2 < 0) { 
                    e1.coords.x = w/2;
                    e1.v.x = 0;
                }
                if (e1.coords.x + w/2 > width) {
                    e1.coords.x = width - w/2;
                    e1.v.x = 0;
                }
                if (e1.coords.y - w/2 < 0) { 
                    e1.coords.y = w/2;
                    e1.v.y = 0;
                }
                if (e1.coords.y + w/2 > width) {
                    e1.coords.y = width - w/2;
                    e1.v.y = 0;
                }
                alreadyMovedEntities.add(this);
                e1.moveCollidingEntities(alreadyMovedEntities, grabbedVx, grabbedVy);
            }
        }
    }
    
    // The mouse should be on a straight line stretching from the player to the entity
    void updateGrabbedVelocity() {
        if (!isBeingForcePushed) {
            float mousePlayerDiffX = mouseX - player.coords.x;
            float mousePlayerDiffY = mouseY - player.coords.y;
            
            float targetX = player.coords.x + grabbedLengthRatio * mousePlayerDiffX; 
            float targetY = player.coords.y + grabbedLengthRatio * mousePlayerDiffY; 
            
            setVelocityTowardsPosition(targetX, targetY);
        }
    }
    
    void setVelocityTowardsPosition(float targetX, float targetY) {
        float diffX = targetX - coords.x;
        float diffY = targetY - coords.y;
        
        v.x = diffX * 0.2;
        v.y = diffY * 0.2;
        if (v.x > maxV) v.x = maxV;
        if (v.x < -maxV) v.x = -maxV;
    }
    
    void updatePosition() {
        v.x *= 0.9;
        v.y *= 0.9;
        coords.x += v.x;
        coords.y += v.y;
        
        if (!collidingEnemiesShouldDie) {
            moveCollidingEntities(new ArrayList<Entity>(Arrays.asList(this)), v.x, v.y);
        }
        
        // Don't let entity leave screen
        if (coords.x - w/2 < 0) { 
            coords.x = w/2;
            v.x = 0;
        }
        if (coords.x + w/2 > width) {
            coords.x = width - w/2;
            v.x = 0;
        }
        if (coords.y - w/2 < 0) { 
            coords.y = w/2;
            v.y = 0;
        }
        if (coords.y + w/2 > width) {
            coords.y = width - w/2;
            v.y = 0;
        }
    }
    
    void changeVx(float diffVx) {
        v.x += diffVx;
        //if (v.x > maxV) v.x = maxV;
        //if (v.x < -maxV) v.x = -maxV;
        
    }
    
    void changeVy(float diffVy) {
        v.y += diffVy;
        //if (v.y > maxV) v.y = maxV;
        //if (v.y < -maxV) v.y = -maxV;
    }
    
    boolean isDead() {
        return hp == 0;    
    }
    
    void stopForcePushIfHitWall() {
        isBeingForcePushed = false;
        // Don't let entity leave screen
        if (coords.x - w/2 < 0) { 
            coords.x = w/2;
            v.x = 0;
            v.y = 0;
        }
        if (coords.x + w/2 > width) {
            coords.x = width - w/2;
            v.x = 0;
            v.y = 0;
        }
        if (coords.y - w/2 < 0) { 
            coords.y = w/2;
            v.x = 0;
            v.y = 0;
        }
        if (coords.y + w/2 > width) {
            coords.y = width - w/2;
            v.x = 0;
            v.y = 0;
        }
    }
    
    void initiateForcePush() {
        isGrabbed = false;
        isBeingForcePushed = true;
        
        float mousePlayerDiffX = mouseX - player.coords.x;
        float mousePlayerDiffY = mouseY - player.coords.y;
        
        /*
        if (mousePlayerDiffX > 0 && mousePlayerDiffY > 0) {
            if (width - mouseX < height - mouseY) {
                targetX = width - w/2;
                targetY = mousePlayerDiffX * (width/mousePlayerDiffY) - w/2;
                setVelocityTowardsPosition(targetX, targetY);
            }
        }
        */
        
        float targetX = player.coords.x + 2 * grabbedLengthRatio * mousePlayerDiffX; 
        float targetY = player.coords.y + 2 * grabbedLengthRatio * mousePlayerDiffY; 
        
        setVelocityTowardsPosition(targetX, targetY);
        
    }
}
