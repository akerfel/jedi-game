Player player;
ArrayList<Entity> entities;

void setup() {
    size(1200, 1200);   
    player = new Player(width/2, height/2);
    entities = new ArrayList<Entity>();
    entities.add(new Entity(300, 300));
    
    entities.add(new Entity(800, 300));
    entities.add(new Entity(900, 900));
    entities.add(new Entity(800, 850));
}

void draw() {
    updateLogic();
    drawEverything();
}
