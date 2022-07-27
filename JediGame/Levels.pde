void spawnInitialEntities() {
    for (int i = 0; i < numStartStormtroopers; i++) {
        spawnStormtrooperOnEdge();
    }
    
    for (int i = 0; i < numStartBoxes; i++) {
        spawnBoxOnEdge();
    }
}

void spawnOneStromtrooper() {
    spawnStormtrooperOnEdge();
}
