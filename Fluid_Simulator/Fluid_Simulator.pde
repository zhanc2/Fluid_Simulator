import g4p_controls.*;
Simulation s;
int n;
int selectedLiquid;
boolean addingLiquid;
boolean paused;
float addLiquidAmount;
float subStepAmount;
boolean blockMakerMode;
boolean drawingBlock;
boolean startedBlock;
boolean finishedBlock;
Block holdingBlock;
PVector drawingBlockStartingPos;

ArrayList<Integer> yes;

int ahh;

void setup() {
  size(400, 400);
  selectedLiquid = 0;
  addingLiquid = false;
  n = height;
  paused = false;
  addLiquidAmount = 0.5;
  subStepAmount = 5;
  blockMakerMode = true;
  drawingBlock = false;
  startedBlock = false;
  finishedBlock = false;
  holdingBlock = null;
  drawingBlockStartingPos = new PVector(0,0);
  s = new Simulation();
  ahh = 0;
}


void draw () {
  if (!paused) {
    background(255);
    s.run();
  }
}
