class Bullet {
    float radius;
    PVector coords;
    PVector v;
    int hp;
    
    // Give the entity which shoots the bullet as an argument (entity coords and radius are needed)
    Bullet(Entity entity) {
        radius = bulletWidth; // must be initialised before coords! 
        setStartCoords(entity);
        setVelocityInPlayerDirection();
        hp = 1;
    }
    
    // The bullet will spawn facing the player. It must not touch the entity which spawned it, since that would kill the entity.
    void setStartCoords(Entity entity) {
        coords = new PVector(0, 0);
        float diffX = player.coords.x - entity.coords.x;
        float diffY = player.coords.y - entity.coords.y;
        
        // Trigonometry time. The bullet spawns at a distance of (1.2 * entity_radius + 1.2 * bullet_radius) from the entity's center.
        float distEntityPlayer = sqrt(sq(diffX) + sq(diffY));
        float distToEntityWidthRatio = (entity.radius) / distEntityPlayer;
        float distToBulletWidthRatio = (this.radius) / distEntityPlayer;
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
    }
    
    void updatePosition() {
        coords.x += v.x;
        coords.y += v.y;
    }
    
    boolean isDead() {
        return hp <= 0;    
    }
}
