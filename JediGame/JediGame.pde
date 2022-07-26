import processing.sound.*; // You need to download this in Processing (Tools -> Add tool -> Libraries -> Install "Sound")

// ### Cheats ###
boolean godMode;
boolean noBullets;

// ### Settings ###
// Player
int playerSpeed;
int playerWidth;

// Force powers
float grabbedLengthRatio;                     // = grabbed_to_player / grabbed_to_mouse. Set to 1 for entity to be at mouse position. 
float forcePushInitialSpeed;                  // Default 50? Higher values means stronger push.

// Entities/Enemies
float chanceEnemySpawn;
float chanceEnemyAttack;                      // default: 0.012. Set between 0 and 1. Higher value means more frequent attacks. Percentage chance that each enemy attacks each frame. 
int numStartEnemies;
int entityWidth;                    
boolean targetedEntityShouldBeHighlighted;    // I prefer false (less visual clutter).
boolean collidingEnemiesShouldDie;
boolean fastEntitiesAreLethal;
float lethalEntitySpeed;                      // Only relevant if fastEntitiesAreLethal is true

// Bullets
int bulletWidth;
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
    targetedEntityShouldBeHighlighted = false; 
    collidingEnemiesShouldDie = false;
    fastEntitiesAreLethal = true;
    lethalEntitySpeed = 8;
    
    // Bullets
    chanceEnemyAttack = 0.015;
    bulletWidth = 10;
    bulletSpeed = 13;
    
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
