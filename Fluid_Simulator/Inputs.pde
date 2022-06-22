void mousePressed() {
  /* 
  
  selectedLiquid = -1: Deleting Liquid
  selectedLiquid = 0: Not in Adding Liquid Mode
  selectedLiquid = 1: Adding Water
  selectedLiquid = 2: Adding Honey
  selectedLiquid = 3: Adding Red Water
  
  */
  
  
  if (selectedLiquid > 0) addingLiquid = true;
  if (selectedLiquid < 0) deletingLiquid = true;
  if (blockMakerMode) {
    // Checks if the mouse clicked on a block
    for (Block b : s.blocks) {
      if (b.pos.x < mouseX && b.pos.x + b.size.x > mouseX && b.pos.y < mouseY && b.pos.y + b.size.y > mouseY) {
        b.pickedUp = true;
        b.pickedUpPosition.x = mouseX - b.pos.x;
        b.pickedUpPosition.y = mouseY - b.pos.y;
        b.prevMousePos.x = mouseX;
        b.prevMousePos.y = mouseY;
        holdingBlock = b;
        
        Block temp = b;
        s.blocks.remove(b);
        s.blocks.add(0, temp);
        
        return;
      }
    }
    startedBlock = true;
    drawingBlock = true; 
    drawingBlockStartingPos = new PVector(mouseX, mouseY);
  }
  if (deletingBlockMode) deletingBlock = true;
}


void mouseReleased() {
  if (selectedLiquid > 0) addingLiquid = false;
  if (selectedLiquid < 0) deletingLiquid = false;
  if (blockMakerMode) {
    if (holdingBlock != null) {
      holdingBlock.pickedUp = false;
      holdingBlock = null;
      return;
    }
    drawingBlock = false;
    if (startedBlock) finishedBlock = true;
    startedBlock = false;
  }
  if (deletingBlockMode) deletingBlock = false;
}

void keyPressed() {
  if (key == ' ') {
    paused = !paused;
  }
  
  if (key == 'q') {
    userInputMode = ((userInputMode-1)+4)%4;
    updateUserInputMode();
  }
  
  if (key == 'e') {
    userInputMode = (userInputMode+1)%4;
    updateUserInputMode();
  }
}

void mouseWheel(MouseEvent e) {
  if (e.getCount() < 0) {
    addLiquidAmount = min(addLiquidAmount+1, 20);
  } else {
    addLiquidAmount = max(addLiquidAmount-1, 0);
  }
}

void updateUserInputMode() {
  switch (userInputMode) {
    case 0:
      selectedLiquid = 1;
      blockMakerMode = false;
      deletingBlockMode = false;
      currentMode.setText("Current Mode: Adding Liquid");
      break;
    case 1:
      selectedLiquid = -1;
      blockMakerMode = false;
      deletingBlockMode = false;
      currentMode.setText("Current Mode: Deleting Liquid");
      break;
    case 2:
      selectedLiquid = 0;
      blockMakerMode = true;
      deletingBlockMode = false;
      currentMode.setText("Current Mode: Block Maker");
      break;
    case 3:
      selectedLiquid = 0;
      blockMakerMode = false;
      deletingBlockMode = true;
      currentMode.setText("Current Mode: Deleting Blocks");
      break;
  }
}
