void mousePressed() {
  if (selectedLiquid > 0) addingLiquid = true;
  if (blockMakerMode) {
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
}


void mouseReleased() {
  if (selectedLiquid > 0) addingLiquid = false;
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
}

void keyPressed() {
  if (key == ' ') {
    paused = !paused;
  }
  
  if (key == 'c') {
    for (int i = 0; i < s.grid.cells.length; i++) {
      for (ArrayList<FluidParticle> a : s.grid.cells[i]) {
        a.clear();
      }
    }
  }
  
  if (key == 'a') {
    for (int i = 0; i < s.grid.cells.length; i++) {
      for (ArrayList<FluidParticle> a : s.grid.cells[i]) {
        print(a.size(), " ");
      }
      println("");
    }
  }
  
  if (key == 's') {
    println("Total particles: " + ahh);
  }
  
  if (key == 'f') {
    println("Framerate: " + frameRate + " fps");
  }
}
