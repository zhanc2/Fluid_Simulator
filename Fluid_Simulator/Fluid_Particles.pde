class FluidParticle {
  
  PVector pos;
  PVector velocity;
  color c;
  
  FluidParticle(PVector p, color C) {
    this.pos = new PVector(p.x, p.y);
    this.velocity = new PVector(0, 0);
    this.c = C;
  }
  
}
