class FluidParticle {
  
  PVector pos;
  PVector velocity;
  float size;
  color c;
  
  FluidParticle(PVector p, color C, float s) {
    this.pos = new PVector(p.x, p.y);
    this.velocity = new PVector(0, 0);
    this.size = s;
    this.c = C;
  }
  
  void display() {
    fill(c, 170);
    noStroke();
    circle(this.pos.x, this.pos.y, this.size*2);
  }
  
  void updatePosition() {
    for (int i = 1; i < this.velocity.x; i++) {
      
    }
    this.pos.x += this.velocity.x;
    this.pos.y -= this.velocity.y;
  }
  
  void gravity(float g) {
    this.velocity.y -= g;
  }
  
  void boundaries() {
    if (this.pos.y + this.size > height) {
      this.pos.y = height - this.size;
      if (this.velocity.x == 0) {
        this.velocity = xyFromDirVel(random(0, PI), this.velocity.y * 0.4);
      } else {
        this.velocity.y *= -0.4;
        this.velocity.x *= 0.99;
      }
    }
    if (this.pos.x + this.size > width) {
      this.pos.x = width - this.size;
      this.velocity.x = 0;
    }
    if (this.pos.x - this.size < 0) {
      this.pos.x = this.size;
      this.velocity.x = 0;
    }
  }
  
  PVector xyFromDirVel(float d, float v) {
    PVector result = new PVector(0, 0);
    
    result.x = cos(d) * v;
    result.y = sin(d) * v * -1;
    
    return result;
  }
  
}
