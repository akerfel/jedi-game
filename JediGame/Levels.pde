void spawnInitialEntities() {
    for (int i = 0; i < numStartStormtroopers; i++) {
        spawnStormtrooperOnEdge();
    }
    spawnBox(30, 30);
}

void spawnOneStromtrooper() {
    spawnStormtrooperOnEdge();
}
