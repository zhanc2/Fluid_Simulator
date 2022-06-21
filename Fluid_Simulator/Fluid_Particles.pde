class FluidParticle {
  
  PVector pos;
  PVector velocity;
  float size;
  color c;
  
  boolean[] againstBoundary;
  
  int[] currentGridCell;
  
  FluidParticle(PVector p, color C, float s) {
    this.pos = new PVector(p.x, p.y);
    this.velocity = new PVector(0, 0);
    this.size = s;
    this.c = C;
    this.againstBoundary = new boolean[3];
    this.currentGridCell = new int[2];
  }
  
  void display() {
    fill(c, 170);
    noStroke();
    circle(this.pos.x, this.pos.y, this.size*2);
  }
  
  void update(float gravity, float ssA) {
    this.gravity(gravity/ssA);
    this.applyForces(ssA);
  }
  
  void applyForces(float ssA) {
    this.pos.x += this.velocity.x / ssA;
    this.pos.y -= this.velocity.y / ssA;
  } //<>// //<>// //<>// //<>//
  
  void setPos(float x, float y) {
    this.pos.x = x;
    this.pos.y = y;
  }
  
  void setVelocity(float x, float y) {
    this.velocity.x = x;
    this.velocity.y = y;
  }
  
  void setVelocity(float newVelocity) {
    if(this.velocity.mag() == 0) {
      return;
    }
    float ratio = newVelocity/this.velocity.mag();
    this.velocity.x *= ratio;
    this.velocity.y *= ratio;
  }
  
  void gravity(float g) {
    this.velocity.y -= g;
  }
  
  void boundaries() {
    if (this.pos.y + this.size > height) {
      this.againstBoundary[1] = true;
      this.pos.y = height - this.size;
      if (abs(this.velocity.y) < 1) this.velocity.y = 0;
      else {this.velocity.y *= -0.3;}
      if (abs(this.velocity.x) < 0.05) this.velocity.x = 0;
      else this.velocity.x *= 0.9;
    } else 
      this.againstBoundary[1] = false;
    if (this.pos.x + this.size > width) {
      if (this.pos.y < height-this.size-5) {
        this.pos.x = width - this.size - 2;
      } else {
        this.pos.x = width - this.size;
      }
      this.velocity.x = 0;
      this.againstBoundary[2] = true;
    } else this.againstBoundary[2] = false;
    if (this.pos.x - this.size < 0) {
      if (this.pos.y < height-this.size-5) {
        this.pos.x = this.size + 2;
      } else {
        this.pos.x = this.size;
      }
      this.velocity.x = 0;
      this.againstBoundary[0] = true;
    } else this.againstBoundary[0] = false;
  }
  
  PVector xyFromDirVel(float d, float v) {
    PVector result = new PVector(0, 0);
    
    result.x = cos(d) * v;
    result.y = sin(d) * v * -1;
    
    return result;
  }
  
}
