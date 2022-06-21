class FluidParticle {
  
  PVector pos;
  PVector velocity;
  float size;
  color c;
  
  boolean[] againstBoundary;
  
  FluidParticle(PVector p, color C, float s) {
    this.pos = new PVector(p.x, p.y);
    this.velocity = new PVector(0, 0);
    this.size = s;
    this.c = C;
    this.againstBoundary = new boolean[3];
  } //<>//
  
  void setVelocity(float x, float y) {
    this.velocity.x = x;
    this.velocity.y = y;
  }
  
  void gravity(float g) {
    this.velocity.y -= g;
  }
}  
