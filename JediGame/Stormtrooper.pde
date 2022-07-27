public class Stormtrooper extends Enemy {
    
    public Stormtrooper(int x, int y) {
        super(x, y, stormtrooperRadius, stormtrooperHp, stormtrooperColor);
    }
    
    void attack() {
        if (!noBullets) {
            bullets.add(new Bullet(this)); 
            laserSound.play();
        }  
    }
}
