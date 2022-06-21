import g4p_controls.*;
Simulation s;
int n;
int userInputMode;
int selectedLiquid;
boolean addingLiquid;
boolean deletingLiquid;
boolean deletingBlockMode;
boolean deletingBlock;
boolean paused;
float addLiquidAmount;
float subStepAmount;
boolean blockMakerMode;
boolean drawingBlock;
boolean startedBlock;
boolean finishedBlock;
boolean validBlockLocation;
Block holdingBlock;
PVector drawingBlockStartingPos;

int ahh;

void setup() {
  size(600, 600);
  userInputMode = 0;
  selectedLiquid = 1;
  addingLiquid = false;
  deletingLiquid = false;
  n = height;
  paused = false;
  addLiquidAmount = 10;
  subStepAmount = 1;
  blockMakerMode = false;
  deletingBlockMode = false;
  deletingBlock = false;
  drawingBlock = false;
  startedBlock = false;
  finishedBlock = false;
  holdingBlock = null;
  validBlockLocation = true;
  drawingBlockStartingPos = new PVector(0,0);
  s = new Simulation(n/5);
  ahh = 0;
  createGUI();
}


void draw () {
  if (!paused) {
    background(255);
    s.run();
    //if (holdingBlock != null) println(holdingBlock.velocity);
  }
}
