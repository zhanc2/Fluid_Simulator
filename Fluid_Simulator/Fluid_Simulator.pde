import g4p_controls.*;
Simulation s = new Simulation();
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
}


void draw () {
  if (!paused) {
    background(255);
    s.run();
  }
}
