Simulation s = new Simulation();
int n;

void setup() {
  size(500, 500);
  n = height;
}

void keyPressed() {
  if (key == ' ') {
    //for (FluidParticle fp : w.particles) {
    //  println(fp.pos);
    //}
  }
}


void draw () {
  background(255);
  stroke(0);
  fill(255);
  s.liquids();
}
