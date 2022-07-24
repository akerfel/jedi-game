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
    
    void updatePosition() {
        coords.x += v.x;
        coords.y += v.y;
        
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
