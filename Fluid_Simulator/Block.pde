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
  
  void updatePosition(int cellSize) {
    
    // The reason for this weird looking way of adding velocity to position is to lock the position of the block according to the size of the grid squares
    // This avoid the case of having a liquid particle partially in a block
    
    if (!pickedUp) {
      this.pos.x = (this.pos.x + this.velocity.x) - (this.pos.x + this.velocity.x) % cellSize;
      this.pos.y = (this.pos.y - this.velocity.y) - (this.pos.y - this.velocity.y) % cellSize;
    }
  }
  
  void gravity(float g) {
    if (!pickedUp) this.velocity.y -= g;
  }
  
  void boundaries() {
    if (this.pos.y + this.size.y > height) {
      this.pos.y = height - this.size.y;
      this.friction();
      this.velocity.y = 0;
    }
    if (this.pos.y < 0) {
      this.pos.y = 0;
      this.velocity.y = 0;
      this.friction();
    }
    if (this.pos.x + this.size.x > width) {
      this.pos.x = width - this.size.x;
    }
    else if (this.pos.x < 0) {
      this.pos.x = 0;
    }
  }
  
  // Lower the velocity in the x-direction
  // The last line of the function stops block from having a tiny amount of velocity that isn't visible but interferes with collision checking
  void friction() {
    if (this.velocity.x < 0) {
      this.velocity.x++;
    }
    else if (this.velocity.x > 0) {
      this.velocity.x--;
    }
    if (abs(this.velocity.x) < 0.3) this.velocity.x = 0;
  }
  
  void collision(Block b) {
    
    // Checks if there is an intersection
    if (this.pos.x < b.pos.x + b.size.x && this.pos.x + this.size.x > b.pos.x && this.pos.y < b.pos.y + b.size.y && this.pos.y + this.size.y > b.pos.y) {
      
      /*
        
        The logic behind the collision system is as follows:
        
        When there is a collision, for 1 moment, the 2 blocks are intersecting at some point.
        The block that has velocity was the one that moved into the other block, so that is the one we move.
        
        We check where it was right before it collided with the other block by reversing the velocity.
        At the point right before intersecting, the moving block will be either above or below, or to the left of or to the right of the other block.
        (We ignore the super narrow case of its velocity and intersection happening perfectly at the diagonal)
        We can find which of these cases it is by examining if the position of the moving block overlaps the position of the stationary block in only one axis.
        
        Which of these cases it is tells us where to reposition the moving block.
        
        The reason why this process is done in a while loop is the case where the velocity of the moving block is high enough so that after reversing the velocity once, the block will be in one of the diagonal areas.
        In this case, it's much harder to tell its position in regards to the other block.
        To prevent this, we reverse the velocity in smaller and smaller increments, until it does fall into one of the directions.
        Again, we ignore the perfect diagonal case.
        
        On collision, we apply friction if the block landed on another and set velocities to 0 depending on which direction the collision happened in.
        
        
      */
      
      // This is the case that b is stationary
      if ((abs(b.velocity.x) <= 4 && abs(b.velocity.y) <= 4)) {
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
            this.friction();
          }
        } else {
          this.velocity.x = 0; //<>//
          if (this.pos.x + this.size.x/2 > b.pos.x + b.size.x/2) {
            this.pos.x = b.pos.x + b.size.x;
          }
          else {
            this.pos.x = b.pos.x - this.size.x;
          }
        }
        
      // This is the case when this is stationary
      } else if ((abs(this.velocity.x) <= 4 && abs(this.velocity.y) <= 4)) {
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
            this.friction();
          }
        } else {
          b.velocity.x = 0; //<>//
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
  
  void move(int cellSize) {
    this.counter++;
    if (this.pickedUp) {
      // This is to give the held block velocity so that it "throws" on release
      // We only check every 3 frames or else the difference in mouse position will be too small to work with
      if (this.counter % 3 == 0) {
        this.velocity.x = (mouseX - this.prevMousePos.x);
        this.velocity.y = (this.prevMousePos.y - mouseY);
      }
      // This is here so that the block remains locked in the grid
      this.pos.x = (mouseX - this.pickedUpPosition.x) - (mouseX - this.pickedUpPosition.x) % cellSize;
      this.pos.y = (mouseY - this.pickedUpPosition.y) - (mouseY - this.pickedUpPosition.y) % cellSize;
      this.prevMousePos.x = mouseX;
      this.prevMousePos.y = mouseY;
    }
  }
}
