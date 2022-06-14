class Simulation {
  
  Fluid water;
  float gravity;
  Grid grid;
  FluidParticle[][] state;
  
  ArrayList<Block> blocks;
  
  float timeSinceLastSpawn;
  
  Simulation() {
    this.gravity = 1;
    this.timeSinceLastSpawn = 60;
    
    this.water = new Fluid(1, 1, 1, color(0, 0, 255));
    this.grid = new Grid(20);
    
    this.blocks = new ArrayList<Block>();
    
    this.state = new FluidParticle[n][n];
    
    //for (int i = 0; i < 7; i++) {
    //  for (int j = 0; j < 7; j++) {
    //    this.water.addLiquid(50+40*i, 50+40*j, this.grid);
    //  }
    //}
    
  }
  
  void run() {
    this.userAddingLiquids();
    this.liquids();
    this.blocks();
    this.userAddingBlocks();
  }
  
  void liquids() {
    this.grid.handleCells(this.gravity, subStepAmount);
  }
  
  void blocks() {
    for (int i = 0; i < this.blocks.size(); i++) {
      for (int s = 0; s < subStepAmount; s++) {
        this.blocks.get(i).move();
        this.blocks.get(i).gravity(this.gravity/2);
        this.blocks.get(i).updatePosition(subStepAmount);
        for (int j = 0; j < this.blocks.size(); j++) {
          if (j != i) {
            this.blocks.get(i).collision(this.blocks.get(j));
          }
        }
        this.blocks.get(i).boundaries();
      }
      this.blocks.get(i).display();
    }
  }
  
  void userAddingLiquids() {
    if (selectedLiquid > 0) {
      fill(255);
      stroke(0);
      circle(mouseX, mouseY, addLiquidAmount*4*this.water.sizeOfLiquidParticles);
    }
    if (selectedLiquid == 1 && addingLiquid) {
      if (timeSinceLastSpawn > 0.1*frameRate) {
        if (addLiquidAmount == 0.5) {
          water.addLiquid(mouseX, mouseY, this.grid);
          ahh++;
          timeSinceLastSpawn = 0;
          return;
        }
        for (int i = -round(addLiquidAmount); i < round(addLiquidAmount)+1; i++) {
          for (int j = -round(addLiquidAmount); j < round(addLiquidAmount)+1; j++) {
            if (i*i + j*j <= addLiquidAmount*addLiquidAmount) {water.addLiquid(mouseX+i*2*water.sizeOfLiquidParticles,mouseY+j*2*water.sizeOfLiquidParticles,this.grid);ahh++;}
          }
        }
        timeSinceLastSpawn = 0;
      }
    }
    timeSinceLastSpawn++;
  }
  
  void userAddingBlocks() {
    if (drawingBlock) {
      validBlockLocation = true;
      for (Block b : this.blocks) {
        if (blockCollision(min(drawingBlockStartingPos.x, mouseX), min(drawingBlockStartingPos.y, mouseY), abs(mouseX - drawingBlockStartingPos.x), abs(mouseY - drawingBlockStartingPos.y), b.pos.x, b.pos.y, b.size.x, b.size.y)) {
          strokeWeight(0);
          fill(255,0,0, 170);
          validBlockLocation = false;
        }
      }
      if (validBlockLocation) {
        fill(0);
        stroke(0);
        strokeWeight(1);
      }
      rect(min(drawingBlockStartingPos.x, mouseX), min(drawingBlockStartingPos.y, mouseY), abs(mouseX - drawingBlockStartingPos.x), abs(mouseY - drawingBlockStartingPos.y));
    } else {
      if (finishedBlock) {
        if (mouseX - drawingBlockStartingPos.x != 0 && mouseY - drawingBlockStartingPos.y != 0) {
          
          if (!validBlockLocation) {
            finishedBlock = false;
            return;
          }
          
          Block b = new Block(new PVector(min(drawingBlockStartingPos.x, mouseX), min(drawingBlockStartingPos.y, mouseY)), new PVector(0,0), new PVector(abs(mouseX - drawingBlockStartingPos.x), abs(mouseY - drawingBlockStartingPos.y)), 10, 10, color(0));
          this.blocks.add(b);
        }
        finishedBlock = false;
      }
    }
  }
  
  boolean blockCollision(float x1, float y1, float w1, float h1, float x2, float y2, float w2, float h2) {
    if (x1 < x2 + w2 && x1 + w1 > x2 && y1 < y2 + h2 && y1 + h1 > y2) return true;
    return false;
  }
  
}
