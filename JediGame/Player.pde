public class Player {
    PVector coords;
    float radius; // width
    float speed;
    boolean isLeft, isRight, isUp, isDown;
    private int hp;
    
    public Player(float x, float y) {
        coords = new PVector(x, y);
        speed = playerSpeed;
        radius = playerRadius;
        hp = 1;
    }
    
    void damage(int damage) {
        if (!godMode) {
            hp -= damage;
        }
    }
    
    void move() {
        float v = speed;
        if (playerCanMove) {
            float xDiff = v*(int(isRight) - int(isLeft));
            float yDiff = v*(int(isDown)  - int(isUp));
            
            // Moving diagonally should not be faster than moving up or down
            if (abs(xDiff) > v/10 && abs(yDiff) > v/10) {
                xDiff = xDiff * sqrt(0.5);    
                yDiff = yDiff * sqrt(0.5);   
            }
            
            // Change coords for all relevant objects
            for (Entity entity : entities) {
                entity.coords.x -= xDiff;
                entity.coords.y -= yDiff;
            }
            for (Bullet bullet : bullets) {
                bullet.coords.x -= xDiff;
                bullet.coords.y -= yDiff;
            }
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
