Player player;

void setup() {
    size(1200, 1200);   
    player = new Player(width/2, height/2);
}

void draw() {
    background(200);
    player.move();
    drawPlayer();
}

void drawPlayer() {
    fill(255, 0, 0);
    circle(player.coords.x, player.coords.y, player.w);
}
