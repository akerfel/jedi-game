public class Enemy extends Entity {
    float attackChance;
    
    public Enemy(int x, int y, int w, int hp, color rgbColor) {
        super(x, y, w, hp, rgbColor, true);
    }
    
    // Please override this method in subclasses
    void attack() {
        
    }
}
