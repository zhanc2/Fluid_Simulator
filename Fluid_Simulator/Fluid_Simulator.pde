import g4p_controls.*;
Simulation s;
int n;
int selectedLiquid;
boolean addingLiquid;
boolean paused;
int addLiquidAmount;
float subStepAmount;
boolean blockMakerMode;
boolean drawingBlock;
boolean finishedBlock;
PVector drawingBlockStartingPos;


int ahh;

void setup() {
  size(400, 400);
  selectedLiquid = 0;
  addingLiquid = false;
  n = height;
  paused = false;
  addLiquidAmount = 5;
  subStepAmount = 5;
  blockMakerMode = true;
  drawingBlock = false;
  finishedBlock = false;
  drawingBlockStartingPos = new PVector(0,0);
  s = new Simulation();
  ahh = 0;
}


void draw () {
  if (!paused) {
    background(255);
    stroke(0);
    strokeWeight(1);
    for (int i = 0; i < 16; i++) {
      line(0, i*25, n, i*25);
    }
    for (int i = 0; i < 16; i++) {
      line(i*25, 0, i*25, n);
    }
    s.run();
  }
}
