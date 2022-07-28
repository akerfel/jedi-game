public class Enemy extends Entity {
    float attackChance;
    
    public Enemy(int x, int y, int radius, int hp, color rgbColor) {
        super(x, y, radius, hp, rgbColor, true, false, false);
    }
    
    // Please override this method in subclasses
    void attack() {
        
    }
}
