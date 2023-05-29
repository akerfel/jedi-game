public class Box extends Entity {
    float attackChance;

    public Box(int x, int y) {
        super(x, y, boxRadius, boxHp, boxColor, false);
    }
}
