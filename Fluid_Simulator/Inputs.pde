void mousePressed() {
  if (selectedLiquid > 0) addingLiquid = true;
  if (blockMakerMode) {drawingBlock = true; drawingBlockStartingPos = new PVector(mouseX, mouseY);}
}


void mouseReleased() {
  if (selectedLiquid > 0) addingLiquid = false;
  if (blockMakerMode) {drawingBlock = false; finishedBlock = true;}
}

void keyPressed() {
  if (key == ' ') {
    //for (FluidParticle fp : s.water.particles) {
    //  println(fp.pos);
    //}
    paused = !paused;
  }
  
  if (key == 'c') {
    //s.water.particles.clear();
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
