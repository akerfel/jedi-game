void updateLogic() {
    player.move();    
}

// Gives angle between (x1, y1) and (x2, y2).
// (x1, y1) is the center of a unit circle (-180 to +180)
float getAngle(float x1, float y1, float x2, float y2) {
    translate(x1, y1);
    return -degrees(atan2(y2-y1, x2-x1));
}
