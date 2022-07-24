public class Player {
    PVector coords;
    int w; // width
    float speed;
    boolean isRunning;
    float runningFactor;
    boolean isLeft, isRight, isUp, isDown;
    
    public Player(float x, float y) {
        coords = new PVector(x, y);
        speed = 3;
        isRunning = false;
        runningFactor = 1.5;
        w = 30;
    }
    
    void move() {
        float v = speed;
        if (isRunning) {
            v *= runningFactor; 
        }
        
        // Change coords
        coords.x += v*(int(isRight) - int(isLeft));
        coords.y += v*(int(isDown)  - int(isUp));
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
