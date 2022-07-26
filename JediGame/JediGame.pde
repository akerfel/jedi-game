// Global variables
Player player;
ArrayList<Entity> entities;

// Settings
boolean collidingEnemiesShouldDie;
boolean targetedEntityShouldBeHighlighted;
float grabbedLengthRatio;            
float forcePushInitialSpeed;

void setup() {
    size(1200, 1200);   
    
    // Global variables
    player = new Player(width/2, height/2);
    entities = new ArrayList<Entity>();
    
    // Add some entities
    for (int i = 0; i < 10; i++) {
        entities.add(new Entity(random(0, 1000), random(0, 1000)));
    }
    entities.add(new Entity(random(0, 1000), random(0, 1000), 300)); // big entity
    
    // Settings
    collidingEnemiesShouldDie = false;
    targetedEntityShouldBeHighlighted = false;    // I prefer false (less visual clutter).
    grabbedLengthRatio = 1.5;                       // = grabbed_to_player / grabbed_to_mouse. Set to 1 for entity to be at mouse position. 
    forcePushInitialSpeed = 50;                   // Default 50? Higher values means stronger push.
}

void draw() {
    updateLogic();
    drawEverything();
}
