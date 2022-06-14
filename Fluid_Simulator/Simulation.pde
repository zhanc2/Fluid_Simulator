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
    
    this.water = new Fluid(1, 1, 10, color(0, 0, 255));
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
    this.userAddingBlocks();
    this.blocks();
  }
  
  void liquids() {
    this.grid.handleCells(this.gravity, subStepAmount);
  }
  
  void blocks() {
    for (int i = 0; i < this.blocks.size(); i++) {
      if (this.blocks.size() > 1 && i != this.blocks.size()-1) this.blocks.get(i).update(this.gravity, new ArrayList<Block>(this.blocks.subList(i+1, this.blocks.size()-1)));
      else this.blocks.get(i).update(this.gravity, new ArrayList<Block>());
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
      fill(0);
      rect(min(drawingBlockStartingPos.x, mouseX), min(drawingBlockStartingPos.y, mouseY), abs(mouseX - drawingBlockStartingPos.x), abs(mouseY - drawingBlockStartingPos.y));
    } else {
      if (finishedBlock) {
        if (mouseX - drawingBlockStartingPos.x != 0 && mouseY - drawingBlockStartingPos.y != 0) {
          Block b = new Block(new PVector(min(drawingBlockStartingPos.x, mouseX), min(drawingBlockStartingPos.y, mouseY)), new PVector(0,0), new PVector(abs(mouseX - drawingBlockStartingPos.x), abs(mouseY - drawingBlockStartingPos.y)), 10, 10, color(0));
          this.blocks.add(b);
        }
        finishedBlock = false;
      }
    }
  }
  
}
