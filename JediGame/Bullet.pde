class Bullet {
    PVector coords;
    PVector v;
    int w;
    
    Bullet(float x, float y) {
        coords = new PVector(x, y);
        v = new PVector(0, 0);
        w = 10;
        setVelocityInPlayerDirection();
    }
    
    void setVelocityInPlayerDirection() {
         setVelocityTowardsPosition(player.coords.x, player.coords.y, bulletSpeed);   
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
        coords.x += v.x;
        coords.y += v.y;
    }
}
