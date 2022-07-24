Player player;
ArrayList<Box> boxes;

void setup() {
    size(1200, 1200);   
    player = new Player(width/2, height/2);
    boxes = new ArrayList<Box>();
    boxes.add(new Box(300, 300));
}

void draw() {
    updateLogic();
    drawEverything();
}
