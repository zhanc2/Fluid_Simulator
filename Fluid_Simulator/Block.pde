class Block {
 
  PVector pos;
  PVector velocity;
  PVector size;
  float mass;
  float density;
  color c;
  
  Block(PVector p, PVector v, PVector s, float m, float d, color C) {
    this.pos = new PVector(p.x, p.y);
    this.velocity = new PVector(v.x, v.y);
    this.size = new PVector(s.x, s.y);
    this.mass = m;
    this.density = d;
    this.c = C;
  }
  
  void update(float g) {
    this.gravity(g);
    this.updatePosition();
    this.boundaries();
    this.display();
  }
  
  void display() {
    rect(this.pos.x, this.pos.y, this.size.x, this.size.y);
  }
  
  void updatePosition() {
    this.pos.x += this.velocity.x;
    this.pos.y -= this.velocity.y;
  }
  
  void gravity(float g) {
    this.velocity.y -= g;
  }
  
  void boundaries() {
    if (this.pos.y + this.size.y > height) {
      this.pos.y = height - this.size.y;
      this.velocity.y = 0;
    }
    if (this.pos.x + this.size.x > width) {
      this.pos.x = width - this.size.x;
    }
    else if (this.pos.x < 0) {
      this.pos.x = 0;
    }
  }
  
  void collision(Block b) {
    
    
    
  }
}
