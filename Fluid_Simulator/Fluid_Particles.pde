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
  
  void applyForces() {
    this.pos.x += this.velocity.x;
    this.pos.y -= this.velocity.y;
  }
  
  void collision(FluidParticle fp) {
    
    float xDis = fp.pos.x - this.pos.x;
    float yDis = fp.pos.y - this.pos.y;
    float disBetweenCenters = sqrt(xDis * xDis + yDis * yDis);
    //println(disBetweenCenters);
    
    if (disBetweenCenters < 2*this.size) {
      if (disBetweenCenters == 0) { //<>//
        //this.pos.x = fp.pos.x - 2 * this.size;
        //this.pos.y = fp.pos.y - 2 * this.size;
        //println("?");
        return;
      }
      float ratio = this.size / disBetweenCenters;
      float xComponent = xDis * ratio;
      float yComponent = yDis * ratio;
      
      //float midX = this.pos.x + xDis/2;
      //float midY = this.pos.y + yDis/2;
      
      //float averageVelocity = (this.velocity.mag() + fp.velocity.mag())/2.0;
      
      stroke(0);
      strokeWeight(1);
      //line(this.pos.x, this.pos.y, fp.pos.x, fp.pos.y);
      
      //this.pos.x = midX - xComponent;
      //this.pos.y = midY - yComponent;
      this.setPos(fp.pos.x - 2 * xComponent, fp.pos.y - 2 * yComponent);
      //this.setVelocity(averageVelocity * 0.9);
      this.setVelocity(0,0);
      
      //fp.setPos(midX + xComponent, midY + yComponent);
      //fp.setVelocity(averageVelocity * 0.9);
      //fp.setVelocity(0,0);
      
      //this.pos.x = fp.pos.x - 2 * xComponent;
      //this.pos.y = fp.pos.y - 2 * yComponent;
      
    }
    
  }
  
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
      if (abs(this.velocity.y) < 0.05) this.velocity.y = 0;
      else {this.velocity.y *= -0.5;}
      if (abs(this.velocity.x) < 0.05) this.velocity.x = 0;
      else this.velocity.x *= 0.9;
    }
    if (this.pos.x + this.size > width) {
      this.pos.x = width - this.size;
      this.velocity.x = 0;
      this.againstBoundary[2] = true;
    }
    if (this.pos.x - this.size < 0) {
      this.pos.x = this.size;
      this.velocity.x = 0;
      this.againstBoundary[0] = true;
    }
  }
  
  PVector xyFromDirVel(float d, float v) {
    PVector result = new PVector(0, 0);
    
    result.x = cos(d) * v;
    result.y = sin(d) * v * -1;
    
    return result;
  }
  
}
