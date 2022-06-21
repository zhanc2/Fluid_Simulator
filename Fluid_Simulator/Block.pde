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
  
  int counter;
  
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
    this.counter = 0;
  }
  
  void display() {
    fill(this.c);
    rect(this.pos.x, this.pos.y, this.size.x, this.size.y);
  }
  
  void updatePosition(float subStepAmount) {
    if (!pickedUp) {
      this.pos.x += this.velocity.x/subStepAmount;
      this.pos.y -= this.velocity.y/subStepAmount;
    }
  }
  
  void undoVelocity() {
    if (!pickedUp) {
      this.pos.x -= this.velocity.x;
      this.pos.y += this.velocity.y;
    }
  }
  
  void gravity(float g) {
    if (!pickedUp) this.velocity.y -= g;
  }
  
  void boundaries() {
    if (this.pos.y + this.size.y > height) {
      this.pos.y = height - this.size.y;
      this.velocity.x *= 0.9;
      if (abs(this.velocity.x) < 0.3) this.velocity.x = 0; 
      this.velocity.y = 0;
    }
    if (this.pos.y < 0) {
      this.pos.y = 0;
      this.velocity.y = 0;
      this.velocity.x *= 0.9;
      if (abs(this.velocity.x) < 0.3) this.velocity.x = 0; 
    }
    if (this.pos.x + this.size.x > width) {
      this.pos.x = width - this.size.x;
    }
    else if (this.pos.x < 0) {
      this.pos.x = 0;
    }
  }
  
  void collision(Block b) {
    
    if (this.pos.x < b.pos.x + b.size.x && this.pos.x + this.size.x > b.pos.x && this.pos.y < b.pos.y + b.size.y && this.pos.y + this.size.y > b.pos.y) {
      
      //if (this.velocity.x == 0) {
      //  if (abs(this.velocity.y) > 1) {
      //    this.pos.y = b.pos.y - this.size.y;
      //    this.velocity.y = 0;
      //  }
      //}
      
      if (b.velocity.x == 0 && b.velocity.y == 0) {
        PVector prevPos = new PVector(this.pos.x - this.velocity.x, this.pos.y + this.velocity.y);
        int inBoundsTracker = inBounds(prevPos.x, prevPos.y, this.size.x, this.size.y, b.pos.x, b.pos.y, b.size.x, b.size.y);
        float divide = 2;
        while (inBoundsTracker == 0) {
          prevPos = new PVector(this.pos.x - this.velocity.x/divide, this.pos.y + this.velocity.y/divide);
          divide *= 2;
          inBoundsTracker = inBounds(prevPos.x, prevPos.y, this.size.x, this.size.y, b.pos.x, b.pos.y, b.size.x, b.size.y);
        }
        
        if (inBoundsTracker == 1) {
          this.velocity.y = 0;
          if (this.pos.y + this.size.y/2 > b.pos.y + b.size.y/2) this.pos.y = b.pos.y + b.size.y;
          else {
            this.pos.y = b.pos.y - this.size.y;
            this.velocity.x *= 0.9;
            if (abs(this.velocity.x) < 0.3) this.velocity.x = 0; 
          }
        } else {
          this.velocity.x = 0;
          if (this.pos.x + this.size.x/2 > b.pos.x + b.size.x/2) {
            this.pos.x = b.pos.x + b.size.x; //<>//
          }
          else {
            this.pos.x = b.pos.x - this.size.x; //<>//
          }
        }
        
      } else if (this.velocity.x == 0 && this.velocity.y == 0) {
        PVector prevPos = new PVector(b.pos.x - b.velocity.x, b.pos.y + b.velocity.y);
        int inBoundsTracker = inBounds(this.pos.x, this.pos.y, this.size.x, this.size.y, prevPos.x, prevPos.y, b.size.x, b.size.y);
        float divide = 2;
        while (inBoundsTracker == 0) {
          prevPos = new PVector(b.pos.x - b.velocity.x/divide, b.pos.y + b.velocity.y/divide);
          divide *= 2;
          inBoundsTracker = inBounds(this.pos.x, this.pos.y, this.size.x, this.size.y, prevPos.x, prevPos.y, b.size.x, b.size.y);
        }
        
        if (inBoundsTracker == 1) {
          b.velocity.y = 0;
          if (b.pos.y + b.size.y/2 > this.pos.y + this.size.y/2) b.pos.y = this.pos.y + this.size.y;
          else {
            b.pos.y = this.pos.y - b.size.y;
            b.velocity.x *= 0.9;
            if (abs(b.velocity.x) < 0.3) this.velocity.x = 0;
          }
        } else {
          b.velocity.x = 0;
          if (this.pos.x + this.size.x/2 > b.pos.x + b.size.x/2) b.pos.x = this.pos.x + this.size.x;
          else b.pos.x = this.pos.x - b.size.x;
        }
      }
      
    }
  }
  
  int inBounds(float x1, float y1, float w1, float h1, float x2, float y2, float w2, float h2) {
    if (x1 < x2 + w2 && x1 + w1 > x2) return 1;
    if (y1 < y2 + h2 && y1 + h1 > y2) return 2;
    return 0;
  }
  
  void move() {
    this.counter++;
    if (this.pickedUp) {
      if (this.counter % 3 == 0) {
        this.velocity.x = (mouseX - this.prevMousePos.x);
        this.velocity.y = (this.prevMousePos.y - mouseY);
      }
      this.pos.x = mouseX - this.pickedUpPosition.x;
      this.pos.y = mouseY - this.pickedUpPosition.y;
      this.prevMousePos.x = mouseX;
      this.prevMousePos.y = mouseY;
    }
  }
}
