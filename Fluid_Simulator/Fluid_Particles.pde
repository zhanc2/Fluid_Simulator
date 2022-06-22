class FluidParticle {
  
  PVector pos;
  PVector velocity;
  float size;
  color c;
  float density;
  
  String type;
  
  FluidParticle(PVector p, color C, float s, float d, String t) {
    this.pos = new PVector(p.x, p.y);
    this.velocity = new PVector(0, 0);
    this.size = s;
    this.c = C;
    this.density = d;
    this.type = t;
  } //<>//
  
  void setVelocity(float x, float y) {
    this.velocity.x = x;
    this.velocity.y = y;
  }
  
  void gravity(float g) {
    this.velocity.y -= g;
  }
}  
