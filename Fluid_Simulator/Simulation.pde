class Simulation {
  
  Fluid water;
  float gravity;
  int stateSize;
  int cellSize;
  FluidParticle[][] fluidState;
  FluidParticle[][] nextState;
  int fluidAmount;
  
  int[] highestFluidLevel;
  
  ArrayList<Block> blocks;
  ArrayList<Block> blocksToBeRemoved;
  
  float timeSinceLastSpawn;
  
  Simulation(int ss) {
    this.gravity = 1;
    this.timeSinceLastSpawn = 60;
    
    this.blocks = new ArrayList<Block>();
    this.blocksToBeRemoved = new ArrayList<Block>();
    
    this.stateSize = ss;
    this.cellSize = n/ss;
    
    this.fluidState = new FluidParticle[ss][ss];
    this.nextState = new FluidParticle[ss][ss];
    
    this.highestFluidLevel = new int[ss];
    
    this.fluidAmount = 0;
    
    this.water = new Fluid(1, 1, n/ss, color(0, 0, 255));
    
  }
  
  void run() {
    this.userAddingLiquids();
    this.blocks();
    this.userAddingBlocks();
    this.userDeletingBlocks();
    this.updateFluidState();
    this.copyNextState();
  }
  
  void blocks() {
    for (Block b : this.blocksToBeRemoved) this.blocks.remove(b);
    for (int i = 0; i < this.blocks.size(); i++) {
      this.blocks.get(i).move(this.cellSize);
      this.blocks.get(i).gravity(this.gravity);
      this.blocks.get(i).updatePosition(this.cellSize);
      if (!this.blocks.get(i).pickedUp) {
        for (int j = 0; j < this.blocks.size(); j++) {
          if (j != i) {
            this.blocks.get(i).collision(this.blocks.get(j));
          }
        }
      }
      this.blocks.get(i).boundaries();
      this.blocks.get(i).display();
    }
  }
  
  void updateFluidState() {
    this.fluidAmount = 0;
    for (int i = 0; i < this.stateSize; i++) {
      boolean firstFound = false;
      for (int j = 0; j < this.stateSize; j++) {
        if (this.fluidState[i][j] == null) continue;
        if (!firstFound) {
          firstFound = true;
          highestFluidLevel[i] = j;
        }
        this.fluidAmount++;
        fill(0,0,255,190);
        strokeWeight(0);
        rect(i*(n/this.stateSize), j*(n/this.stateSize), this.fluidState[i][j].size, this.fluidState[i][j].size);
        this.fluidState[i][j].gravity(this.gravity);
        PVector roundedVelocity = new PVector(int(this.fluidState[i][j].velocity.x), int(this.fluidState[i][j].velocity.y));
        int xAmount = 0, yAmount = 0;
        boolean condition = true;
        while (condition) {
          if (i + xAmount == this.stateSize-1) {
            if (!(i == this.stateSize-1 && roundedVelocity.x < 0)) break;
          } else if (i + xAmount == 0) {
            if (!(i == 0 && roundedVelocity.x > 0)) break;
          }
          if (abs(xAmount) == abs(roundedVelocity.x)) break;
          xAmount += 1 +(-2 * int(roundedVelocity.x < 0));
          if (this.fluidState[i+xAmount][j] != null) {xAmount -= 1 +(-2 * int(roundedVelocity.x < 0));break;}
          for (Block b : this.blocks) {
            if ((j-yAmount)*this.cellSize >= b.pos.y && (j-yAmount)*this.cellSize <= b.pos.y + b.size.y && (i+yAmount)*this.cellSize <= b.pos.x + b.size.x && (i+yAmount)*this.cellSize >= b.pos.x) {
              xAmount -= 1 +(-2 * int(roundedVelocity.x < 0));
              condition=false;
              break;
            }
          }
        }
        condition = true;
        while (condition) {
          if (j - yAmount == this.stateSize-1) {
            this.fluidState[i][j].velocity.y = 0;
            break;
          } else if (j - yAmount == 0) break;
          if (abs(yAmount) == abs(roundedVelocity.y)) break;
          yAmount += 1 + (-2 * int(roundedVelocity.y < 0));
          if (this.fluidState[i][j-yAmount] != null) {yAmount -= 1 + (-2 * int(roundedVelocity.y < 0));break;}
          for (Block b : this.blocks) {
            if ((j-yAmount)*this.cellSize >= b.pos.y && (j-yAmount)*this.cellSize <= b.pos.y + b.size.y && (i+yAmount)*this.cellSize <= b.pos.x + b.size.x && (i+yAmount)*this.cellSize >= b.pos.x) {
              yAmount -= 1 + (-2 * int(roundedVelocity.y < 0));
              condition=false;
              break;
            }
          }
        }
        
        int randLeveling = randomLeveling(i,j);

        if (this.nextState[i+xAmount][j-yAmount] == null) {
          this.nextState[i][j] = null;
          this.fluidState[i][j].pos.x += xAmount;
          this.fluidState[i][j].pos.y -= yAmount;  //<>//
          this.nextState[i+xAmount][j-yAmount] = this.fluidState[i][j];
        }
        
        if (randLeveling == 1) {
          this.nextState[i+xAmount][j-yAmount].velocity.x = -1;
        }
        if (randLeveling == 2) {
          this.nextState[i+xAmount][j-yAmount].velocity.x = 1;
        }
        
        if (j-yAmount > 0) {
          for (Block b : this.blocks) {
            if ((j-yAmount-1)*this.cellSize <= b.pos.y + b.size.y && (j-yAmount-1)*this.cellSize >= b.pos.y && (i+yAmount)*this.cellSize <= b.pos.x + b.size.x && (i+yAmount)*this.cellSize >= b.pos.x) {
              int disToLeftWall = int(b.pos.x);
              int disToRightWall = int(this.stateSize - b.pos.x - b.size.x);
              int displacement;
              boolean findingPlace = true;
              int tries = 0;
              while (findingPlace) {
                tries++;
                if ((i+yAmount) > b.pos.x + b.size.x/2) {
                  displacement = min(disToRightWall/this.cellSize, round(random(1, 10)));
                } else {
                  displacement = -min(disToLeftWall/this.cellSize, round(random(1, 10)));
                }
                if (this.highestFluidLevel[i+yAmount+displacement] > 0) {
                  if (this.nextState[i+yAmount+displacement][this.highestFluidLevel[i+yAmount+displacement-1]] == null) {
                    FluidParticle temp = this.nextState[i+xAmount][j-yAmount];
                    this.nextState[i+xAmount][j-yAmount] = null;
                    this.highestFluidLevel[i+yAmount+displacement]--;
                    this.nextState[i+yAmount+displacement][this.highestFluidLevel[i+yAmount+displacement]] = temp;
                    //this.nextState[i+yAmount+displacement][this.highestFluidLevel[i+yAmount+displacement-1]].setVelocity(0,0);
                    findingPlace = false;
                  }
                }
                if (tries > 5) {findingPlace = false;}
              }
            }
          }
        }
      }
    }
    //println(this.fluidAmount);
  }
  
  int randomLeveling(int i, int j) {
    if (j != this.stateSize-1) 
      if (this.fluidState[i][j+1] == null) return 0;
    
    if (i == this.stateSize-1) {
      if (this.fluidState[i-1][j] != null) {return 0;}
      float r = random(0,1);
      return int(r > 0.1);
    }
    if (i == 0) {
      if (this.fluidState[i+1][j] != null) {return 0;}
      float r = random(0,1);
      return 2 * int(r > 0.1);
    }
    if (this.fluidState[i+1][j] != null && this.fluidState[i-1][j] != null) return 0;
    if (this.fluidState[i+1][j] != null) {
      //float r = random(0,1);
      //return int(r > 0.1);
      return 1;
  } else if (this.fluidState[i-1][j] != null) {
      //float r = random(0,1);
      //return 2 * int(r > 0.1);
      return 2;
    }
    float r = random(0,2);
    //if (r < 0.1) return 0;
    if (r < 1) return 1;
    return 2;
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
  
  boolean pointInBlock(int x, int y) {
    for (Block b : this.blocks) {
      if (x < b.pos.x + b.size.x && x > b.pos.x && y < b.pos.y + b.size.y && y > b.pos.y) {
        println("hey");
        return true;
      }
    }
    return false;
  }
  
  void userAddingLiquids() {
    if (selectedLiquid != 0) {
      fill(255);
      stroke(0);
      strokeWeight(1);
      circle(mouseX, mouseY, addLiquidAmount*2*this.water.sizeOfLiquidParticles);
    }
    if (selectedLiquid == 1 && addingLiquid) {
      if (timeSinceLastSpawn > 0.1*frameRate) {
        if (addLiquidAmount == 0.5) {
          if (!pointInBlock(mouseX, mouseY)) {
            this.addFluidToState(water.createLiquid(mouseX/(n/this.stateSize),mouseY/(n/this.stateSize)));
            ahh++;
            timeSinceLastSpawn = 0;
            return;
          }
        }
        for (int i = -round(addLiquidAmount); i < round(addLiquidAmount)+1; i++) {
          for (int j = -round(addLiquidAmount); j < round(addLiquidAmount)+1; j++) {
            if (i*i + j*j <= addLiquidAmount*addLiquidAmount) {
              if (!pointInBlock(mouseX+i*this.cellSize, mouseY+j*this.cellSize)) {
                this.addFluidToState(water.createLiquid((mouseX/this.cellSize)+i,(mouseY/this.cellSize)+j));
                ahh++;
              }
            }
          }
        }
        timeSinceLastSpawn = 0;
      }
    } else if (selectedLiquid == -1 && deletingLiquid) {
      if (addLiquidAmount == 0.5) {
        this.fluidState[mouseX/this.cellSize][mouseY/this.cellSize] = null;
        ahh--;
      }
      for (int i = -round(addLiquidAmount); i < round(addLiquidAmount)+1; i++) {
          for (int j = -round(addLiquidAmount); j < round(addLiquidAmount)+1; j++) {
            if (i*i + j*j <= addLiquidAmount*addLiquidAmount) {
              try {
                this.fluidState[mouseX/this.cellSize+i][mouseY/this.cellSize+j] = null;
                this.nextState[mouseX/this.cellSize+i][mouseY/this.cellSize+j] = null;
              }
              catch (Exception e) {}
              ahh--;
            }
          }
        }
    }
    timeSinceLastSpawn++;
  }
  
  void userAddingBlocks() {
    if (drawingBlock) {
      validBlockLocation = true;
      for (Block b : this.blocks) {
        if (blockCollision(min(drawingBlockStartingPos.x, mouseX) - min(drawingBlockStartingPos.x, mouseX)%this.cellSize, 
        min(drawingBlockStartingPos.y, mouseY) - min(drawingBlockStartingPos.y, mouseY)%this.cellSize, 
        abs(mouseX - drawingBlockStartingPos.x) - abs(mouseX - drawingBlockStartingPos.x)%this.cellSize, 
        abs(mouseY - drawingBlockStartingPos.y) - abs(mouseY - drawingBlockStartingPos.y)%this.cellSize, b.pos.x, b.pos.y, b.size.x, b.size.y)) {
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
      rect(min(drawingBlockStartingPos.x, mouseX) - min(drawingBlockStartingPos.x, mouseX)%this.cellSize, 
      min(drawingBlockStartingPos.y, mouseY) - min(drawingBlockStartingPos.y, mouseY)%this.cellSize, 
      abs(mouseX - drawingBlockStartingPos.x) - abs(mouseX - drawingBlockStartingPos.x)%this.cellSize, 
      abs(mouseY - drawingBlockStartingPos.y) - abs(mouseY - drawingBlockStartingPos.y)%this.cellSize);
    } else {
      if (finishedBlock) {
        if (mouseX - drawingBlockStartingPos.x != 0 && mouseY - drawingBlockStartingPos.y != 0) {
          
          if (!validBlockLocation) {
            finishedBlock = false;
            return;
          }
          
          Block b = new Block(new PVector(min(drawingBlockStartingPos.x, mouseX) - min(drawingBlockStartingPos.x, mouseX)%this.cellSize, min(drawingBlockStartingPos.y, mouseY) - min(drawingBlockStartingPos.y, mouseY)%this.cellSize), 
          new PVector(0,0), new PVector(abs(mouseX - drawingBlockStartingPos.x) - abs(mouseX - drawingBlockStartingPos.x)%this.cellSize, abs(mouseY - drawingBlockStartingPos.y) - abs(mouseY - drawingBlockStartingPos.y)%this.cellSize), 10, 10, color(0));
          this.blocks.add(b);
        }
        finishedBlock = false;
      }
    }
  }
  
  void userDeletingBlocks() {
    if (deletingBlockMode && deletingBlock) {
      for (Block b : this.blocks) {
        if (mouseX < b.pos.x + b.size.x && mouseX > b.pos.x && mouseY < b.pos.y + b.size.y && mouseY > b.pos.y) {
          this.blocksToBeRemoved.add(b);
          return;
        }
      }
    }
  }
  
  boolean blockCollision(float x1, float y1, float w1, float h1, float x2, float y2, float w2, float h2) {
    if (x1 < x2 + w2 && x1 + w1 > x2 && y1 < y2 + h2 && y1 + h1 > y2) return true;
    return false;
  }
  
}
