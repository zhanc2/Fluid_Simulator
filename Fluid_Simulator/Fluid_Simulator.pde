/*

Fluid Simulator by Charles Zhang, ICS 4UI Final Project, 2022

To use:
- Use the GUI/Hotkeys to switch between the different input options
- In Adding Liquid Mode, clicking with the mouse will add the selected liquid to the simulation at the cursor's position.
- In Deleting Liquid Mode, clicking with the mouse will delete any liquid that is at the cursor's position.
- In Block Maker Mode, click with the mouse and drag to drop in a block. If the position is invalid, it will turn red and won't spawn a new block. You can also drag and throw blocks.
- In Deleting Block Mode, any block that is under the cursor while the mouse is being held will be deleted

Fluids are implemented in the manner of a Cellular Automata.

The 3 available liquids are Water, Honey, and Red Colored Water.
Honey is more dense than the others and will sink if dropped in either of the other fluids.
Water and Red Colored Water are the same density and neither will sink in the other.

Hotkeys:
- Space: Pause/Play the simulation
- 'q' and 'e': Changes the current input mode
- Scrolling mouse: Changes the amount of fluid added/deleted at once

*/

import g4p_controls.*;
Simulation s;
int n, userInputMode, selectedLiquid;
float addLiquidAmount, fps;
boolean addingLiquid, deletingLiquid, deletingBlockMode, deletingBlock, paused, blockMakerMode, drawingBlock, startedBlock, finishedBlock, validBlockLocation;
Block holdingBlock;
PVector drawingBlockStartingPos;

int e = 0;

void setup() {
  size(600, 600);
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
  fps = 60;
  createGUI();
}


void draw () {
  if (!paused) {
    background(255);
    s.run();
    frameRate(fps);
  }
}
