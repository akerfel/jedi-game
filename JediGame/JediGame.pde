import processing.sound.*; // You need to download this in Processing (Tools -> Add tool -> Libraries -> Install "Sound")

// ### Settings ###
// Player
int playerSpeed;
int playerWidth;

// Force powers
float grabbedLengthRatio;                     // = grabbed_to_player / grabbed_to_mouse. Set to 1 for entity to be at mouse position. 
float forcePushInitialSpeed;                  // Default 50? Higher values means stronger push.

// Entities/Enemies
float chanceEnemySpawn;
float chanceEnemyAttack;                     // Set between 0 and 1. Higher value means more frequent attacks. Percentage chance that each enemy attacks each frame. 
int numStartEnemies;
int entityWidth;                     
boolean collidingEnemiesShouldDie;
boolean targetedEntityShouldBeHighlighted;    // I prefer false (less visual clutter).

// Bullets
int bulletWidth;
float bulletSpeed;

// ### Global variables ###
boolean gameOver;
Player player;
ArrayList<Entity> entities;
ArrayList<Bullet> bullets;

// This function is called once the game has been launched
void setup() {
    size(1200, 1200);   
    
    // ### Settings ###
    // Player
    playerSpeed = 7;
    playerWidth = 30;
    
    // Force powers
    grabbedLengthRatio = 1;    
    forcePushInitialSpeed = 50; 
    
    // Entities/Enemies
    chanceEnemySpawn = 0.003;
    chanceEnemyAttack = 0.005; 
    numStartEnemies = 2;
    entityWidth = 30;      
    targetedEntityShouldBeHighlighted = false; 
    collidingEnemiesShouldDie = false;
    
    // Bullets
    bulletWidth = 10;
    bulletSpeed = 8;
    
    // ### Global variables ###
    gameOver = false;
    player = new Player(width/2, height/2);
    entities = new ArrayList<Entity>();
    bullets = new ArrayList<Bullet>();
    
    // ### Level setup ###
    // Add some entities
    for (int i = 0; i < numStartEnemies; i++) {
        int randX = int(random(0, width));
        int randY = int(random(0, height));
        entities.add(new Entity(randX, randY, entityWidth));
    }
    //entities.add(new Entity(random(0, 1000), random(0, 1000), 300)); // big entity
}

// This function is called 60 times per second
void draw() {
    if (!gameOver) {
        updateLogic();
        drawEverything();
    }
    else if (entities.isEmpty()) {
        youWonScreen();
    }
    else {
        gameOverScreen();   
    }
}

void playAudioFile(String audioFileName) {
    SoundFile soundFile = new SoundFile(this, audioFileName);
    soundFile.play();
}
