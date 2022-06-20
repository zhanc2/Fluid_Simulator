class Simulation {
  
  Fluid water;
  float gravity;
  Grid grid;
  int stateSize;
  FluidParticle[][] fluidState;
  FluidParticle[][] nextState;
  
  ArrayList<Block> blocks;
  
  float timeSinceLastSpawn;
  
  Simulation(int ss) {
    this.gravity = 1;
    this.timeSinceLastSpawn = 60;
    
    //this.grid = new Grid(20);
    
    this.blocks = new ArrayList<Block>();
    
    this.stateSize = ss;
    
    this.fluidState = new FluidParticle[ss][ss];
    this.nextState = new FluidParticle[ss][ss];
    
    this.water = new Fluid(1, 1, n/ss, color(0, 0, 255));
    
    //for (int i = 0; i < 7; i++) {
    //  for (int j = 0; j < 7; j++) {
    //    this.water.addLiquid(50+40*i, 50+40*j, this.grid);
    //  }
    //}
    
  }
  
  void run() {
    this.userAddingLiquids();
    //this.liquids();
    this.blocks();
    this.userAddingBlocks();
    this.updateFluidState();
    this.copyNextState();
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
  
  void updateFluidState() {
    for (int i = 0; i < this.stateSize; i++) {
      for (int j = 0; j < this.stateSize; j++) {
        if (this.fluidState[i][j] == null) continue;
        //this.fluidState[i][j].display();
        fill(0,0,255,190);
        strokeWeight(0);
        rect(i*(n/this.stateSize), j*(n/this.stateSize), this.fluidState[i][j].size, this.fluidState[i][j].size);
        this.fluidState[i][j].gravity(this.gravity);
        PVector roundedVelocity = new PVector(int(this.fluidState[i][j].velocity.x), int(this.fluidState[i][j].velocity.y));
        int xAmount = 0, yAmount = 0;
        while (true) {
          if (i + xAmount == this.stateSize-1 || i + xAmount == 0) break;
          if (abs(xAmount) == abs(roundedVelocity.x)) break;
          xAmount += 1 +(-2 * int(roundedVelocity.x < 0));
          if (this.fluidState[i+xAmount][j] != null) {xAmount -= 1 +(-2 * int(roundedVelocity.x < 0));break;}
        }
        while (true) {
          if (j - yAmount == this.stateSize-1 || j - yAmount == 0) break;
          if (abs(yAmount) == abs(roundedVelocity.y)) break;
          yAmount += 1 + (-2 * int(roundedVelocity.y < 0));
          if (this.fluidState[i][j-yAmount] != null) {yAmount -= 1 + (-2 * int(roundedVelocity.y < 0));break;}
        }
        this.nextState[i][j] = null;
        this.fluidState[i][j].pos.x += xAmount;
        this.fluidState[i][j].pos.y -= yAmount;
        this.nextState[i+xAmount][j-yAmount] = this.fluidState[i][j];
      }
    }
  }
  
  void copyNextState() {
    for (int i = 0; i < this.stateSize; i++) {
      for (int j = 0; j < this.stateSize; j++) {
        this.fluidState[i][j] = this.nextState[i][j];
      }
    }
  }
  
  void addFluidToState(FluidParticle f) {
    if (f.pos.x > -1 && f.pos.x < this.stateSize && f.pos.y > 0 && f.pos.y < this.stateSize) {
      if (this.nextState[int(f.pos.x)][int(f.pos.y)] == null) {
        this.nextState[int(f.pos.x)][int(f.pos.y)] = f;
      } 
    } 
  }
  
  void userAddingLiquids() {
    if (selectedLiquid > 0) {
      fill(255);
      stroke(0);
      strokeWeight(1);
      circle(mouseX, mouseY, addLiquidAmount*2*this.water.sizeOfLiquidParticles);
    }
    if (selectedLiquid == 1 && addingLiquid) {
      if (timeSinceLastSpawn > 0.1*frameRate) {
        if (addLiquidAmount == 0.5) {
          this.addFluidToState(water.createLiquid(mouseX/(n/this.stateSize),mouseY/(n/this.stateSize)));
          ahh++;
          timeSinceLastSpawn = 0;
          return;
        }
        for (int i = -round(addLiquidAmount); i < round(addLiquidAmount)+1; i++) {
          for (int j = -round(addLiquidAmount); j < round(addLiquidAmount)+1; j++) {
            if (i*i + j*j <= addLiquidAmount*addLiquidAmount) {
              this.addFluidToState(water.createLiquid((mouseX/(n/this.stateSize))+i,(mouseY/(n/this.stateSize))+j));
              ahh++;
            }
          }
        }
        timeSinceLastSpawn = 0;
      }
    }
    timeSinceLastSpawn++;
  }
  
  //void userAddingLiquids() {
  //  if (selectedLiquid > 0) {
  //    fill(255);
  //    stroke(0);
  //    circle(mouseX, mouseY, addLiquidAmount*4*this.water.sizeOfLiquidParticles);
  //  }
  //  if (selectedLiquid == 1 && addingLiquid) {
  //    if (timeSinceLastSpawn > 0.1*frameRate) {
  //      if (addLiquidAmount == 0.5) {
  //        water.addLiquid(mouseX, mouseY, this.grid);
  //        ahh++;
  //        timeSinceLastSpawn = 0;
  //        return;
  //      }
  //      for (int i = -round(addLiquidAmount); i < round(addLiquidAmount)+1; i++) {
  //        for (int j = -round(addLiquidAmount); j < round(addLiquidAmount)+1; j++) {
  //          if (i*i + j*j <= addLiquidAmount*addLiquidAmount) {water.addLiquid(mouseX+i*2*water.sizeOfLiquidParticles,mouseY+j*2*water.sizeOfLiquidParticles,this.grid);ahh++;}
  //        }
  //      }
  //      timeSinceLastSpawn = 0;
  //    }
  //  }
  //  timeSinceLastSpawn++;
  //}
  
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
