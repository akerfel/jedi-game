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
    
    public Entity(float x, float y) {
        coords = new PVector(x, y);
        w = 30;
        v = new PVector(0, 0);
        maxV = 30;
        isTargeted = false;
        isGrabbed = false;
        hp = 1;
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
                alreadyMovedEntities.add(this);
                e1.moveCollidingEntities(alreadyMovedEntities, grabbedVx, grabbedVy);
            }
        }
    }
    
    // The mouse should be on a straight line stretching from the player to the entity
    void updateGrabbedPosition() {
        float targetX = 0;
        float targetY = 0;
        
        float anglePlayerMouse = getAngle(player.coords.x, player.coords.y, mouseX, mouseY);
        float anglePlayerEntity = getAngle(player.coords.x, player.coords.y, coords.x, coords.y);
        float entityAngleDiff = abs(anglePlayerMouse - anglePlayerEntity);
        
        float playerMouseDiffX = player.coords.x - mouseX;
        float playerMouseDiffY = player.coords.y - mouseY;
        targetX = player.coords.x - 1.5 * playerMouseDiffX; 
        targetY = player.coords.y - 1.5 * playerMouseDiffY; 
        
        // TODO: should be a smooth change to these coords (i.e. with acceleration)
        coords.x = targetX;
        coords.y = targetY;
        
    }
    
    // NOT USED ATM, replaced by updateGrabbedPosition
    void updatePosition() {
        coords.x += v.x;
        coords.y += v.y;
        
        if (!collidingEnemiesShouldDie) {
            moveCollidingEntities(new ArrayList<Entity>(Arrays.asList(this)), v.x, v.y);
        }
        
        // friction
        float frictionFactor = 0.91;
        v.x *= frictionFactor;
        v.y *= frictionFactor;
        
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
}
