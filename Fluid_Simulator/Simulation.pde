class Simulation {
  
  Fluid water, honey, redWater;
  Fluid[] fluids;
  Fluid selectedFluidType;
  float gravity;
  int stateSize;
  int cellSize;
  FluidParticle[][] fluidState;
  FluidParticle[][] nextState;
  
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
    
    this.fluids = new Fluid[3];
    this.water = new Fluid(2, n/ss, color(0, 0, 255), 1, "water");
    this.honey = new Fluid(0.12, n/ss, color(255, 219, 13), 2, "honey");
    this.redWater = new Fluid(2, n/ss, color(255, 0, 0), 1, "coloredWater");
    this.fluids[0] = this.water;
    this.fluids[1] = this.honey;
    this.fluids[2] = this.redWater;
    this.selectedFluidType = this.fluids[0];
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
    // Since an arraylist can't be modified while iterating through it, we need to keep a separate arraylist to remember which blocks will be deleted
    for (Block b : this.blocksToBeRemoved) {this.blocks.remove(b);}
    for (int i = 0; i < this.blocks.size(); i++) {
      this.blocks.get(i).move(this.cellSize);
      this.blocks.get(i).gravity(this.gravity);
      this.blocks.get(i).updatePosition(this.cellSize);
      this.blocks.get(i).boundaries();
      // We need to check collisions with every other block than itself
      for (int j = 0; j < this.blocks.size(); j++) {
        if (j != i) {
          this.blocks.get(i).collision(this.blocks.get(j));
        }
      }
      this.blocks.get(i).display();
    }
  }
  
  void updateFluidState() {
    for (int i = 0; i < this.stateSize; i++) {
      boolean firstFound = false;
      for (int j = 0; j < this.stateSize; j++) {
        // We skip if there is no fluid there
        if (this.fluidState[i][j] == null) continue;
        // This keeps track of the highest up fluid particle at each x-value
        // This is for blocks displacing fluid
        if (!firstFound) {
          firstFound = true;
          highestFluidLevel[i] = j;
        }
        
        // Drawing the fluid
        fill(this.fluidState[i][j].c,190);
        strokeWeight(0);
        rect(i*this.cellSize, j*this.cellSize, this.fluidState[i][j].size, this.fluidState[i][j].size);
        
        // Update gravity
        this.fluidState[i][j].gravity(this.gravity);
        
        /*
        
        This is the logic for moving the particles:
        
        Essentially, we move the particle in whatever direction its velocity is until we encounter one of these conditions:
        - We reach a boundary
        - We reach a position occupied by another particle
        - We reach a position occupied by a block
        - We have moved the particle fully to its velocity
        
        Then we move it or reposition accordingly
        
        */
        
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
          if (this.fluidState[i][j-yAmount] != null) {
            yAmount -= 1 + (-2 * int(roundedVelocity.y < 0));
            break;
          }
          for (Block b : this.blocks) {
            if ((j-yAmount)*this.cellSize >= b.pos.y && (j-yAmount)*this.cellSize <= b.pos.y + b.size.y && (i+yAmount)*this.cellSize <= b.pos.x + b.size.x && (i+yAmount)*this.cellSize >= b.pos.x) {
              yAmount -= 1 + (-2 * int(roundedVelocity.y < 0));
              condition=false;
              break;
            }
          }
        }

        // If the space we want to move to isn't occupied, we move to it
        // This solves the problem of multiple particles all trying to move to the same spot
        if (this.nextState[i+xAmount][j-yAmount] == null) {
          this.nextState[i][j] = null;
          this.fluidState[i][j].pos.x += xAmount;
          this.fluidState[i][j].pos.y -= yAmount;  //<>//
          this.nextState[i+xAmount][j-yAmount] = this.fluidState[i][j];
        } else {
          xAmount = 0;
          yAmount = 0;
        }
        
        // If there is a particle under the current particle that is less dense, we swap the 2 particles
        if (j < this.stateSize-1) {
          if (this.fluidState[i][j+1] != null) {
            if (this.fluidState[i][j+1].density < this.fluidState[i][j].density) {
              this.nextState[i][j] = this.fluidState[i][j+1];
              this.nextState[i][j+1] = this.fluidState[i][j];
            }
          }
        }
        
        // If the particle is surrounded by particles, we randomly switch places
        if (i < this.stateSize-1 && i > 0) {
          if (this.fluidState[i+1][j] != null && this.fluidState[i-1][j] != null && this.nextState[i+1][j] != null && this.nextState[i-1][j] != null && this.nextState[i][j] != null) {
            float r = random(0,3);
            if (r < 1 && !this.fluidState[i][j].type.equals(this.fluidState[i+1][j])) {
              this.nextState[i+1][j] = this.fluidState[i][j];
              this.nextState[i][j] = this.fluidState[i+1][j];
            } else if (r < 2 && !this.fluidState[i][j].type.equals(this.fluidState[i-1][j])) {
              this.nextState[i-1][j] = this.fluidState[i][j];
              this.nextState[i][j] = this.fluidState[i-1][j];
            }
          }
        }
        
        // This levels off the liquid
        int randLeveling = randomLeveling(i,j, this.selectedFluidType.viscosity);
        if (randLeveling == 1) {
          this.nextState[i+xAmount][j-yAmount].velocity.x = -1;
        }
        if (randLeveling == 2) {
          this.nextState[i+xAmount][j-yAmount].velocity.x = 1;
        }
        
        /*
        
        In reality, when a block displaces a liquid, all the liquid around is pushed to their new positions
        
        The logic for particles being displaced by blocks in THIS program is much simpler (albeit much less realistic):
        If a particle is inside a block, we teleport it next to the block at the highest level
        
        We try this 5 times. If there are any errors, we just leave it.
        
        
        */
        if (j-yAmount > 0) {
          for (Block b : this.blocks) {
            if ((j-yAmount-1)*this.cellSize < b.pos.y + b.size.y && (j-yAmount-1)*this.cellSize > b.pos.y && (i+yAmount)*this.cellSize < b.pos.x + b.size.x && (i+yAmount)*this.cellSize > b.pos.x) {
              int disToLeftWall = int(b.pos.x);
              int disToRightWall = int(this.stateSize - b.pos.x - b.size.x);
              int displacement;
              boolean findingPlace = true;
              int tries = 0;
              while (findingPlace) {
                tries++;
                if ((i+yAmount) > b.pos.x + b.size.x/2) {
                  displacement = min(disToRightWall/this.cellSize, round(random(1, 2)));
                } else {
                  displacement = -min(disToLeftWall/this.cellSize, round(random(1, 2)));
                }
                if (this.highestFluidLevel[i+yAmount+displacement] > 0) {
                  if (this.nextState[i+yAmount+displacement][this.highestFluidLevel[i+yAmount+displacement]-1] == null) {
                    FluidParticle temp = this.fluidState[i][j];
                    if (temp == null) return;
                    this.nextState[i+xAmount][j-yAmount] = null;
                    this.highestFluidLevel[i+yAmount+displacement]--;
                    this.nextState[i+yAmount+displacement][this.highestFluidLevel[i+yAmount+displacement]] = temp;
                    this.nextState[i+yAmount+displacement][this.highestFluidLevel[i+yAmount+displacement]].setVelocity(0,0);
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
  }
  
  // Levels the fluid depending on if it's against a boundary or if there are particles next to it
  int randomLeveling(int i, int j, float v) {
    if (j != this.stateSize-1) 
      if (this.fluidState[i][j+1] == null) return 0;
    
    if (i == this.stateSize-1) {
      if (this.fluidState[i-1][j] != null) {return 0;}
      float r = random(0,v);
      return int(r > 0.1);
    }
    if (i == 0) {
      if (this.fluidState[i+1][j] != null) {return 0;}
      float r = random(0,v);
      return 2 * int(r > 0.1);
    }
    if (this.fluidState[i+1][j] != null && this.fluidState[i-1][j] != null) return 0;
    if (this.fluidState[i+1][j] != null) {
      float r = random(0,v);
      return int(r > 0.1);
  } else if (this.fluidState[i-1][j] != null) {
      float r = random(0,v);
      return 2 * int(r > 0.1);
    }
    float r = random(0,v+0.1);
    if (r < 0.1) return 0;
    if (r < v/2 + 0.1) return 1;
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
    // Make sure the particle is within the bounds
    if (f.pos.x > -1 && f.pos.x < this.stateSize && f.pos.y > 0 && f.pos.y < this.stateSize) {
      if (this.nextState[int(f.pos.x)][int(f.pos.y)] == null) {
        this.nextState[int(f.pos.x)][int(f.pos.y)] = f;
      } 
    } 
  }
  
  boolean pointInBlock(int x, int y) {
    for (Block b : this.blocks) {
      if (x < b.pos.x + b.size.x && x > b.pos.x && y < b.pos.y + b.size.y && y > b.pos.y) {
        return true;
      }
    }
    return false;
  }
  
  void userAddingLiquids() {
    // If we are not in one of the block modes, we draw a circle around the cursor to show how much liquid will be added/deleted
    if (selectedLiquid != 0) {
      fill(255);
      stroke(0);
      strokeWeight(1);
      circle(mouseX, mouseY, addLiquidAmount*2*this.selectedFluidType.sizeOfLiquidParticles);
    }
    // If we are in the adding liquid mode, we proceed
    if (selectedLiquid > 0 && addingLiquid) {
      // This ensures that the user can't add fluid too quickly
      if (timeSinceLastSpawn > 0.1*frameRate) {
        // We check all points in the square with side length equal to twice the amount of liquid being added to see if they would be in the circle with the same radius
        // If it is, we make a fluid particle there
        for (int i = -round(addLiquidAmount); i < round(addLiquidAmount)+1; i++) {
          for (int j = -round(addLiquidAmount); j < round(addLiquidAmount)+1; j++) {
            if (i*i + j*j <= addLiquidAmount*addLiquidAmount) {
              if (!pointInBlock(mouseX+i*this.cellSize, mouseY+j*this.cellSize)) {
                this.addFluidToState(this.selectedFluidType.createLiquid((mouseX/this.cellSize)+i,(mouseY/this.cellSize)+j));
              }
            }
          }
        }
        // If we added fluid, we reset the time since the last spawn
        timeSinceLastSpawn = 0;
      }
    } else if (selectedLiquid == -1 && deletingLiquid) {
      // The logic here is the same as the logic for adding liquid: check if the points fall in the circle
      for (int i = -round(addLiquidAmount); i < round(addLiquidAmount)+1; i++) {
          for (int j = -round(addLiquidAmount); j < round(addLiquidAmount)+1; j++) {
            if (i*i + j*j <= addLiquidAmount*addLiquidAmount) {
              // We use a try/catch statement to avoid the problems of going out of bounds
              // The reason why we don't need one earlier for adding is because the method for adding the fluid takes care of it
              try {
                this.fluidState[mouseX/this.cellSize+i][mouseY/this.cellSize+j] = null;
                this.nextState[mouseX/this.cellSize+i][mouseY/this.cellSize+j] = null;
              }
              catch (Exception e) {}
            }
          }
        }
    }
    timeSinceLastSpawn++;
  }
  
  void userAddingBlocks() {
    if (drawingBlock) {
      
      // First, we need to check if the proposed position of the new block is valid. If it is, we draw what the block would look like at the proposed position. If it isn't, we draw a translucent red rectangle instead.
      
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
      // What this code that shows up a couple more times does is it locks the block position and size to the grid so that it isn't in between grid lines.
      rect(min(drawingBlockStartingPos.x, mouseX) - min(drawingBlockStartingPos.x, mouseX)%this.cellSize, 
      min(drawingBlockStartingPos.y, mouseY) - min(drawingBlockStartingPos.y, mouseY)%this.cellSize, 
      abs(mouseX - drawingBlockStartingPos.x) - abs(mouseX - drawingBlockStartingPos.x)%this.cellSize, 
      abs(mouseY - drawingBlockStartingPos.y) - abs(mouseY - drawingBlockStartingPos.y)%this.cellSize);
    } else {
      if (finishedBlock) {
        // This prevents a block with size 0
        if (mouseX - drawingBlockStartingPos.x != 0 && mouseY - drawingBlockStartingPos.y != 0) {
          
          if (!validBlockLocation) {
            finishedBlock = false;
            return;
          }
          
          // If all conditions are met, we add a new block to the simulation based on where the user first clicked and where the cursor is when the mouse was released
          
          Block b = new Block(new PVector(min(drawingBlockStartingPos.x, mouseX) - min(drawingBlockStartingPos.x, mouseX)%this.cellSize, min(drawingBlockStartingPos.y, mouseY) - min(drawingBlockStartingPos.y, mouseY)%this.cellSize), 
          new PVector(0,0), new PVector(abs(mouseX - drawingBlockStartingPos.x) - abs(mouseX - drawingBlockStartingPos.x)%this.cellSize, abs(mouseY - drawingBlockStartingPos.y) - abs(mouseY - drawingBlockStartingPos.y)%this.cellSize), 10, 10, color(0));
          this.blocks.add(b);
        }
        finishedBlock = false;
      }
    }
  }
  
  // Checks if a user has deleted a block, if so, add it to the list of blocks to be deleted
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
  
  // Quick Method to check if there's a collision between two rectangles
  boolean blockCollision(float x1, float y1, float w1, float h1, float x2, float y2, float w2, float h2) {
    if (x1 < x2 + w2 && x1 + w1 > x2 && y1 < y2 + h2 && y1 + h1 > y2) return true;
    return false;
  }
  
}
