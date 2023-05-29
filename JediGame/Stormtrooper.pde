public class Stormtrooper extends Enemy {

    public Stormtrooper(int x, int y) {
        super(x, y, stormtrooperRadius, stormtrooperHp, stormtrooperColor);
    }

    void attack() {
        if (!noBullets && v.mag() < 0.01) {
            bullets.add(new Bullet(this));
            laserSound.stop();
            laserSound.play();
        }
    }
}
