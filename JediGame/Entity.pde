public class Entity {
    PVector coords;
    boolean isLeft, isRight, isUp, isDown;
    int w; // width
    boolean isTargeted;
    boolean isGrabbed;
    
    public Entity(float x, float y) {
        coords = new PVector(x, y);
        w = 30;
        isTargeted = false;
        isGrabbed = false;
    }
}
