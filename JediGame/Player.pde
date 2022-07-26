public class Player {
    PVector coords;
    int w; // width
    float speed;
    boolean isLeft, isRight, isUp, isDown;
    
    public Player(float x, float y) {
        coords = new PVector(x, y);
        speed = 3;
        w = 30;
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
