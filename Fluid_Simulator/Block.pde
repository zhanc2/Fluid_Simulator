class Block {
 
  PVector pos;
  PVector velocity;
  PVector size;
  float mass;
  float density;
  color c;
  
  boolean pickedUp;
  PVector pickedUpPosition;
  PVector prevMousePos;
  
  Block(PVector p, PVector v, PVector s, float m, float d, color C) {
    this.pos = new PVector(p.x, p.y);
    this.velocity = new PVector(v.x, v.y);
    this.size = new PVector(s.x, s.y);
    this.mass = m;
    this.density = d;
    this.c = C;
    this.pickedUp = false;
    this.pickedUpPosition = new PVector(0,0);
    this.prevMousePos = new PVector(0,0);
  }
  
  void update(float g) {
    this.move();
    this.gravity(g);
    this.updatePosition();
    this.boundaries();
    this.display();
  }
  
  void display() {
    fill(this.c);
    rect(this.pos.x, this.pos.y, this.size.x, this.size.y);
  }
  
  void destroy() {
    
  }
  
  void updatePosition() {
    if (!pickedUp) {
      this.pos.x += this.velocity.x;
      this.pos.y -= this.velocity.y;
    }
  }
  
  void gravity(float g) {
    if (!pickedUp) this.velocity.y -= g;
  }
  
  void boundaries() {
    if (this.pos.y + this.size.y > height) {
      this.pos.y = height - this.size.y;
      this.velocity.x = 0;
      this.velocity.y = 0;
    }
    if (this.pos.y < 0) {
      this.pos.y = 0;
      this.velocity.y = 0;
      this.velocity.x = 0;
    }
    if (this.pos.x + this.size.x > width) {
      this.pos.x = width - this.size.x;
    }
    else if (this.pos.x < 0) {
      this.pos.x = 0;
    }
  }
  
  void collision(Block b) {
    
    if (this.velocity.x == 0 && this.velocity.y == 0) {
      if (this.pos.x + this.size.x > b.pos.x && this.pos.x +this.size.x < b.pos.x + b.size.x) {
        //if (this.
      }
    } else if (b.velocity.x == 0 && b.velocity.y == 0) {
      
    } else {
      
    }
    
  }
  
  void move() {
    if (this.pickedUp) {
      this.velocity.x = (mouseX - this.prevMousePos.x);
      this.velocity.y = (this.prevMousePos.y - mouseY);
      this.pos.x = mouseX - this.pickedUpPosition.x;
      this.pos.y = mouseY - this.pickedUpPosition.y;
      this.prevMousePos.x = mouseX;
      this.prevMousePos.y = mouseY;
    }
  }
}
