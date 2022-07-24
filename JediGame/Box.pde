public class Box {
    PVector coords;
    boolean isLeft, isRight, isUp, isDown;
    int w; // width
    
    public Box(float x, float y) {
        coords = new PVector(x, y);
        w = 30;
    }
    
}
