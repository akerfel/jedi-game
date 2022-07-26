class Bullet {
    float w;
    PVector coords;
    PVector v;
    int hp;
    
    // Give the entity which shoots the bullet as an argument (entity coords and width are needed)
    Bullet(Entity entity) {
        w = bulletWidth; // must be initialised before coords! 
        setStartCoords(entity);
        //coords = new PVector(entity.coords.x, entity.coords.y); // this will change, but they are needed for setVelocityTowardsPosition
        
        setVelocityInPlayerDirection();
        hp = 1;
    }
    
    void setStartCoords(Entity entity) {
        coords = new PVector(0, 0);
        float diffX = player.coords.x - entity.coords.x;
        float diffY = player.coords.y - entity.coords.y;
        println("-------");
        println("diffX: " + diffX);
        println("diffY: " + diffY);
        
        // Trigonometry time
        float distEntityPlayer = sqrt(sq(diffX) + sq(diffY));
        float distToEntityWidthRatio = (entity.w/2) / distEntityPlayer;
        float distToBulletWidthRatio = (this.w/2) / distEntityPlayer;
        println("w: " + entity.w);
        println("distEntityPlayer: " + distEntityPlayer);
        println("distToWidthRatio: " + distToEntityWidthRatio);
        coords.x = entity.coords.x + 1.2 * diffX * distToEntityWidthRatio + 1.2 * diffX * distToBulletWidthRatio;
        coords.y = entity.coords.y + 1.2 * diffY * distToEntityWidthRatio + 1.2 * diffY * distToBulletWidthRatio;
        
    }
    
    void setVelocityInPlayerDirection() {
         v = new PVector(0, 0);
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
        
        //if (v.x > maxV) v.x = maxV;
        //if (v.x < -maxV) v.x = -maxV;
    }
    
    void updatePosition() {
        coords.x += v.x;
        coords.y += v.y;
    }
    
    boolean isDead() {
        return hp <= 0;    
    }
}
