import g4p_controls.*;
Simulation s;
int n;
int userInputMode;
int selectedLiquid;
boolean addingLiquid;
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
  size(1000, 500);
  userInputMode = 0;
  selectedLiquid = 1;
  addingLiquid = false;
  n = height;
  paused = false;
  addLiquidAmount = 10;
  subStepAmount = 5;
  blockMakerMode = false;
  drawingBlock = false;
  startedBlock = false;
  finishedBlock = false;
  holdingBlock = null;
  validBlockLocation = true;
  drawingBlockStartingPos = new PVector(0,0);
  s = new Simulation();
  ahh = 0;
  createGUI();
}


void draw () {
  if (!paused) {
    background(255);
    s.run();
    for (int i = 0; i < n; i++) {
      for (int j = 0; j < n; j++) {
        if (s.fluidState[i][j] != null) {fill(0); rect(i+500,j,1,1);}
      }
    }
  }
}
