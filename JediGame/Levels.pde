void standardLevelSetup() {
    for (int i = 0; i < numStartStormtroopers; i++) {
        spawnStormtrooperOnEdge();
    }
    
    for (int i = 0; i < numStartBoxes; i++) {
        spawnBoxOnEdge();
    }
    
    for (int i = 0; i < numStartWalls; i++) {
        spawnWallOnEdge();
    }
}

void spawnOneOfEachEntity() {
    spawnStormtrooperOnEdge();
    spawnBoxOnEdge();
    spawnWallOnEdge();
}
