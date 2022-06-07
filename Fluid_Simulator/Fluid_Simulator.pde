Fluid w = new Fluid(1, 1, 1, color(0, 0, 255));

int n;
boolean[][] state;

void setup() {
  size(500, 500);
  n = height;
  state = new boolean[n][n];
  for (int i = 0; i < 5; i++) {
    for (int j = 0; j < 5; j++) {
      FluidParticle p = new FluidParticle(new PVector(50 + 50*j, 30 + 50*i), color(0, 0, 255), 20);
      //state[100 + i][100 + j] = true;
      w.particles.add(p);
    }
  }
}

void keyPressed() {
  if (key == ' ') {
    for (FluidParticle fp : w.particles) {
      println(fp.pos);
    }
  }
}


void draw () {
  background(255);
  stroke(0);
  fill(255);
  w.updateLiquid(1);
}
