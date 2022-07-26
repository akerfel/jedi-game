import processing.sound.*; // You need to download this in Processing (Tools -> Add tool -> Libraries -> Install "Sound")

// ### Cheats ###
boolean godMode;
boolean noBullets;

// ### Settings ###

// Binary gameplay choices
boolean collidingEnemiesShouldDie;            // I prefer false (high speed is *not* required for this setting).
boolean fastEntitiesAreLethal;                // I prefer true. This will make fast entites kill other entities at high speeds.
float lethalEntitySpeed;                      // Only relevant if fastEntitiesAreLethal is true
boolean targetedEntityShouldBeHighlighted;    // I prefer false (less visual clutter).
boolean playerCanMove;                        // Default: true.
boolean onlyForceControlledEnemiesDieFromBullets; // I prefer true, since otherwise the player can easily get points
                                                  // by just letting enemies kill each other. ForceControlled = pushed/thrown/grabbed.


// Player
int playerSpeed;
int playerWidth;

// Force powers
float grabbedLengthRatio;                     // = grabbed_to_player / grabbed_to_mouse. Set to 1 for entity to be at mouse position. 
float forcePushInitialSpeed;                  // Default 50? Higher values means stronger push

// Entities/Enemies
float chanceEnemySpawn;
float chanceEnemyAttack;                      // default: 0.012. Set between 0 and 1. Higher value means more frequent attacks. Percentage chance that each enemy attacks each frame. 
int numStartEnemies;
int entityWidth;                    

// Bullets
int bulletWidth;                              // Really wide bullets encourages using enemies as shields (80?).
float bulletSpeed;

// ### Dynamic variables ###
int score;                                    // Number of enemies killed
Player player;
ArrayList<Entity> entities;
ArrayList<Bullet> bullets;
PrintWriter output;

// ### Sounds ###
SoundFile laserSound;
SoundFile wilhelmScreamSound; 

// ### GamesState ###
public enum GameState {
  GAMEOVER,
  STARTSCREEN,
  GAMEACTIVE
}
GameState gameState;

// This function is called once the game has been launched
void setup() {
    size(1200, 1200);   
    
    // ### Cheats ###
    godMode = false;
    noBullets = false;
    
    // ### Settings ###
    
    // Binary gameplay choices
    collidingEnemiesShouldDie = false;
    fastEntitiesAreLethal = true;
    lethalEntitySpeed = 14;
    targetedEntityShouldBeHighlighted = false;
    playerCanMove = true;                     
    onlyForceControlledEnemiesDieFromBullets = true;
    
    // Player
    playerSpeed = 7;
    playerWidth = 30;
    
    // Force powers
    grabbedLengthRatio = 1;
    forcePushInitialSpeed = 50;
    
    // Entities/Enemies
    chanceEnemySpawn = 0.01;
    numStartEnemies = 2;
    entityWidth = 60;
    
    // Bullets
    chanceEnemyAttack = 0.005;
    bulletWidth = 80;
    bulletSpeed = 9;
    
    // ### Dynamic variables ###
    player = new Player(width/2, height/2);
    entities = new ArrayList<Entity>();
    bullets = new ArrayList<Bullet>();
    gameState = GameState.GAMEACTIVE;
    
    // ### Sounds ###
    laserSound = new SoundFile(this, "retroBlasterSound.wav"); // https://freesound.org/people/JavierZumer/sounds/257232/;
    wilhelmScreamSound = new SoundFile(this, "wilhelmScream.wav"); 
    
    // ### Level setup ###
    // Add some entities
    for (int i = 0; i < numStartEnemies; i++) {
        spawnEnemyOnEdge();
    }
    //entities.add(new Entity(random(0, 1000), random(0, 1000), 300)); // big entity
}

// This function is called 60 times per second
void draw() {
  switch(gameState) {
    case GAMEACTIVE:
      drawEverything();
      updateLogic();
      break;
    case GAMEOVER:
      drawGameOver();
      break;
  }
}

void resetGame() {
    score = 0;
    entities.clear();
    bullets.clear();
    player = new Player(width/2, height/2);
    gameState = GameState.GAMEACTIVE;
}

void gameOver() {
    drawEverything();
    gameState = GameState.GAMEOVER; 
    saveCurrentScore();  // will only save if actually is new highscore
}
