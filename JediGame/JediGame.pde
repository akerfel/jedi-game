// ### Settings ###
// Player
int playerSpeed;
int playerWidth;

// Force powers
float grabbedLengthRatio;                     // = grabbed_to_player / grabbed_to_mouse. Set to 1 for entity to be at mouse position. 
float forcePushInitialSpeed;                  // Default 50? Higher values means stronger push.

// Entities/Enemies
int entityWidth;
float enemyAttackChance;                      // Set between 0 and 1. Higher value means more frequent attacks. Percentage chance that each enemy attacks each frame. 
boolean collidingEnemiesShouldDie;
boolean targetedEntityShouldBeHighlighted;    // I prefer false (less visual clutter).

// Bullets
int bulletWidth;
float bulletSpeed;

// ### Global variables ###
Player player;
ArrayList<Entity> entities;
ArrayList<Bullet> bullets;

// This function is called once the game has been launched
void setup() {
    size(1200, 1200);   
    
    // ### Settings ###
    // Player
    playerSpeed = 4;
    playerWidth = 30;
    
    // Force powers
    grabbedLengthRatio = 1;    
    forcePushInitialSpeed = 50; 
    
    // Entities/Enemies
    entityWidth = 30;      
    enemyAttackChance = 0.005; 
    targetedEntityShouldBeHighlighted = false; 
    collidingEnemiesShouldDie = false;
    
    // Bullets
    bulletWidth = 10;
    bulletSpeed = 8;
    
    // ### Global variables ###
    player = new Player(width/2, height/2);
    entities = new ArrayList<Entity>();
    bullets = new ArrayList<Bullet>();
    
    // ### Level setup ###
    // Add some entities
    entities.add(new Entity(100, 100, 30));
    for (int i = 0; i < 4; i++) {
        int randX = int(random(0, width));
        int randY = int(random(0, height));
        entities.add(new Entity(randX, randY, entityWidth));
    }
    //entities.add(new Entity(random(0, 1000), random(0, 1000), 300)); // big entity
}

// This function is called 60 times per second
void draw() {
    updateLogic();
    drawEverything();
}
