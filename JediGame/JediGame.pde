Player player;
ArrayList<Entity> entities;
Entity grabbedEntity;

// Settings
boolean collidingEnemiesShouldDie;
float grabbedLengthRatio;            // = grabbed_to_player / grabbed_to_mouse. Set to 1 for entity to be at mouse position. 

void setup() {
    size(1200, 1200);   
    player = new Player(width/2, height/2);
    entities = new ArrayList<Entity>();
    
    //entities.add(new Entity(300, 300));
    //entities.add(new Entity(800, 300));
    //entities.add(new Entity(900, 900));
    //entities.add(new Entity(800, 850));
    
    for (int i = 0; i < 10; i++) {
        entities.add(new Entity(random(0, 1000), random(0, 1000)));
    }
    
    // big entity
    entities.add(new Entity(random(0, 1000), random(0, 1000), 300));
    
    
    grabbedEntity = null;
    
    // Settings
    collidingEnemiesShouldDie = false;
    grabbedLengthRatio = 1;
}

void draw() {
    updateLogic();
    drawEverything();
}
