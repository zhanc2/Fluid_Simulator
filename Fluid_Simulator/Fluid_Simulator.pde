import g4p_controls.*;
Simulation s;
int n;
int selectedLiquid;
boolean addingLiquid;
boolean paused;

void setup() {
  size(500, 500);
  selectedLiquid = 1;
  addingLiquid = false;
  n = height;
  paused = false;
  s = new Simulation();
}


void draw () {
  if (!paused) {
    background(255);
    //stroke(0);
    //strokeWeight(1);
    //for (int i = 0; i < 20; i++) {
    //  line(0, i*25, n, i*25);
    //}
    //for (int i = 0; i < 20; i++) {
    //  line(i*25, 0, i*25, n);
    //}
    s.run();
  }
}
