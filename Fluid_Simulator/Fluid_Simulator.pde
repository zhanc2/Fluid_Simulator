Fluid w = new Fluid(1, 1, 1, color(0, 0, 255));

int n;
boolean[][] state;

void setup() {
  size(500, 500);
  n = height;
  state = new boolean[n][n];
  for (int i = 0; i < 100; i++) {
    for (int j = 0; j < 100; j++) {
      FluidParticle p = new FluidParticle(new PVector(100 + i, 100 + j), color(0, 0, 255), 1);
      state[100 + i][100 + j] = true;
      w.particles.add(p);
    }
  }
}


void draw () {
  background(255);
  w.updateLiquid(1);
}
