import processing.sound.*; // You need to download this in Processing (Tools -> Add tool -> Libraries -> Install "Sound")

// ### Cheats ###
boolean godMode;
boolean noBullets;
int spawnMultiplier;                         // Set to 1 for default behavior. Higher means more frequent enemy spawns.

// ### Settings ###

// Basic
float volume;                                // Set between 0 and 1.
boolean muteSound;

// Binary gameplay choices
boolean collidingEnemiesShouldDie;            // I prefer false (high speed is *not* required for this setting).
boolean fastEntitiesAreLethal;                // I prefer true. This will make fast entites kill other entities at high speeds.
float lethalEntitySpeed;                      // Only used if fastEntitiesAreLethal is true
boolean targetedEntityShouldBeHighlighted;    // I prefer false (less visual clutter).
boolean playerCanMove;                        // Default: true.
boolean grabbedEntitiesSameDistFromPlayer;    // I think I prefer true. If true, grabbed entities will be at a set distance from player.
float dist_grabbedEntitiesToPlayer;           // Only used if grabbedEntitiesSameDistFromPlayer is true.
boolean onlyForceControlledEnemiesDieFromBullets; // I prefer true, since otherwise the player can easily get points by just
                                                  //  letting enemies kill each other. ForceControlled = pushed/thrown/grabbed.
boolean enemiesSpawnOnIntervall;              // Default: true. If false, each frame will have chanceStormtrooperSpawn of spawning an enemy                

// Player
int playerSpeed;
int playerRadius;

// Force powers
float forcePushInitialSpeed;                  // Default 50? Higher values means stronger push
float grabbedLengthRatio;                     // = grabbed_to_player / grabbed_to_mouse. Set 1 for entity to be at mouse position. 
                                              // Only used if grabbedEntitiesSameDistFromPlayer is false.

// Entities
float deacellerationFactor;                   // Between 0 and 1. Lower values means entities stop faster.

// Stormtroopers
int stormtrooperSpawnTimerInterval;           // Only used if enemiesSpawnOnIntervall is true
int stormtrooperRadius;
color stormtrooperColor;
int stormtrooperHp;
float chanceStormtrooperSpawn;                // Only used if enemiesSpawnOnIntervall is false
float chanceStormtrooperAttack;               // default: 0.012. Set between 0 and 1. Percentage chance that each enemy attacks each
int numStartStormtroopers;

// Boxes
int boxRadius;
color boxColor;
int boxHp;
float chanceBoxSpawn;
int numStartBoxes;

// Bullets
int bulletRadius;                              // Really wide bullets encourages using enemies as shields (80?).
float bulletSpeed;

// Enemy pointers
int entityPointerRadius;

// ### Dynamic variables ###
int score;                                    // Number of enemies killed
Player player;
ArrayList<Entity> entities;
ArrayList<Bullet> bullets;
PrintWriter output;     
int stormtrooperSpawnTimer;

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
    fullScreen();
    println("width: " + width);
    
    println("height: " + height);
    
    // ### Cheats ###
    godMode = true;
    noBullets = false;
    spawnMultiplier = 0;
    
    // ### Settings ###
    
    // Basic
    volume = 0.05;
    muteSound = false;
    if (muteSound) volume = 0;
    
    // Binary gameplay choices
    collidingEnemiesShouldDie = false;
    fastEntitiesAreLethal = true;
    lethalEntitySpeed = 9;
    targetedEntityShouldBeHighlighted = false;
    playerCanMove = true;                     
    grabbedEntitiesSameDistFromPlayer = true;
    dist_grabbedEntitiesToPlayer = 150;
    onlyForceControlledEnemiesDieFromBullets = true;
    enemiesSpawnOnIntervall = true;
    
    // Player
    playerSpeed = 5;
    playerRadius = 15;
    
    // Force powers
    grabbedLengthRatio = 1;
    forcePushInitialSpeed = 93;
    
    // Entities
    deacellerationFactor = 0.94;
    
    // Stormtroopers
    stormtrooperSpawnTimerInterval = 50;   
    stormtrooperRadius = 30;
    stormtrooperColor = color(255);
    stormtrooperHp = 1;
    chanceStormtrooperSpawn = 0.03;
    numStartStormtroopers = 2;   
    
    // Boxes
    boxRadius = 100;
    boxColor = color(139, 69, 19);
    boxHp = 30;
    chanceBoxSpawn = 0.002;
    numStartBoxes = 4;
    
    // Bullets
    chanceStormtrooperAttack = 0.25;
    bulletRadius = 40;
    bulletSpeed = 11;
    
    // Enemy pointers
    entityPointerRadius = 8;
    
    // ### Dynamic variables ###
    player = new Player(width/2, height/2);
    entities = new ArrayList<Entity>();
    bullets = new ArrayList<Bullet>();
    gameState = GameState.GAMEACTIVE;
    stormtrooperSpawnTimer = 10;
    
    // ### Sounds ###
    laserSound = new SoundFile(this, "retroBlasterSound.wav"); // https://freesound.org/people/JavierZumer/sounds/257232/;
    laserSound.amp(volume);
    wilhelmScreamSound = new SoundFile(this, "wilhelmScream.wav"); 
    wilhelmScreamSound.amp(volume);
    
    // ### Level setup ###
    initialLevelSetup();
}

// This function is called once per frame/tick
void draw() {
  switch(gameState) {
    case GAMEACTIVE:
      updateLogic();
      drawEverything();
      break;
    case GAMEOVER:
      drawGameOver();
      break;
  }
}

void initialLevelSetup() {
    //standardLevelSetup();
    spawnOneStromtrooper();
}

void resetGame() {
    score = 0;
    entities.clear();
    bullets.clear();
    initialLevelSetup();
    player = new Player(width/2, height/2);
    gameState = GameState.GAMEACTIVE;
    
}

void gameOver() {
    drawEverything();
    gameState = GameState.GAMEOVER; 
    saveCurrentScore();  // will only save if actually is new highscore
}
