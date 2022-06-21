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
boolean blockMakerMode;
boolean drawingBlock;
boolean startedBlock;
boolean finishedBlock;
boolean validBlockLocation;
Block holdingBlock;
PVector drawingBlockStartingPos;

int ahh;

void setup() {
  size(1200, 600);
  userInputMode = 0;
  selectedLiquid = 1;
  addingLiquid = false;
  deletingLiquid = false;
  n = height;
  paused = false;
  addLiquidAmount = 10;
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
    for (int i = 0; i < s.highestFluidLevel.length; i++) {
      rect(600 + i*s.cellSize, s.highestFluidLevel[i]*s.cellSize, s.cellSize, s.cellSize);
    }
  }
}
