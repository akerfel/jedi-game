// Settings
boolean collidingEnemiesShouldDie;
boolean targetedEntityShouldBeHighlighted;    // I prefer false (less visual clutter).
float grabbedLengthRatio;                     // = grabbed_to_player / grabbed_to_mouse. Set to 1 for entity to be at mouse position. 
float forcePushInitialSpeed;                  // Default 50? Higher values means stronger push.
float enemyAttackChance;                      // Set between 0 and 1. Percentage chance that each enemy attacks each frame. Higher value means more frequent attacks.

// Global variables
Player player;
ArrayList<Entity> entities;

void setup() {
    size(1200, 1200);   
    
    // Settings
    collidingEnemiesShouldDie = true;
    targetedEntityShouldBeHighlighted = false;    
    grabbedLengthRatio = 1;                       
    forcePushInitialSpeed = 50;                   
    enemyAttackChance = 0.003;      
    
    // Global variables
    player = new Player(width/2, height/2);
    entities = new ArrayList<Entity>();
    
    // Add some entities
    for (int i = 0; i < 4; i++) {
        entities.add(new Entity(int(random(0, width)), int(random(0, height))));
    }
    //entities.add(new Entity(random(0, 1000), random(0, 1000), 300)); // big entity
    
    
}

void draw() {
    updateLogic();
    drawEverything();
}
