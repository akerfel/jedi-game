public class Player {
    PVector coords;
    float w; // width
    float speed;
    boolean isLeft, isRight, isUp, isDown;
    int hp;
    
    public Player(float x, float y) {
        coords = new PVector(x, y);
        speed = playerSpeed;
        w = playerWidth;
        hp = 1;
    }
    
    void move() {
        float v = speed;
        
        // Change coords for all relevant objects
        for (Entity entity : entities) {
            entity.coords.x -= v*(int(isRight) - int(isLeft));
            entity.coords.y -= v*(int(isDown)  - int(isUp));
        }
        for (Bullet bullet : bullets) {
            bullet.coords.x -= v*(int(isRight) - int(isLeft));
            bullet.coords.y -= v*(int(isDown)  - int(isUp));
        }
    }
    
    boolean isDead() {
        return hp <= 0;    
    }
    
    boolean setMove(final int k, final boolean b) {
        switch (k) {
            case +'W':
            case UP:
                  return isUp = b;
         
            case +'S':
            case DOWN:
                  return isDown = b;
         
            case +'A':
            case LEFT:
                  return isLeft = b;
         
            case +'D':
            case RIGHT:
                  return isRight = b;
         
            default:
                  return b;
        }
    }
}
