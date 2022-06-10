void mousePressed() {
  if (selectedLiquid > 0) addingLiquid = true;
}


void mouseReleased() {
  if (selectedLiquid > 0) addingLiquid = false;
}

void keyPressed() {
  if (key == ' ') {
    //for (FluidParticle fp : s.water.particles) {
    //  println(fp.pos);
    //}
    paused = !paused;
  }
}
