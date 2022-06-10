class Simulation {
  
  Fluid water;
  float gravity;
  Grid grid;
  
  float timeSinceLastSpawn;
  
  Simulation() {
    this.gravity = 1;
    this.timeSinceLastSpawn = 60;
    
    this.water = new Fluid(1, 1, 20, color(0, 0, 255));
    //for (int i = 0; i < 7; i++) {
    //  for (int j = 0; j < 3; j++) {
    //    this.water.addLiquid(50+40*i, 50+40*j);
    //  }
    //}
    
    this.grid = new Grid(10);
  }
  
  void run() {
    this.liquids();
    this.userAddingLiquids();
  }
  
  void liquids() {
    this.water.updateLiquid(gravity);
    this.grid.handleCells();
  }
  
  void userAddingLiquids() {
    if (selectedLiquid == 1 && addingLiquid) {
      if (timeSinceLastSpawn > 0.05*frameRate) {
        water.addLiquid(mouseX,mouseY);
        timeSinceLastSpawn = 0;
      }
      else timeSinceLastSpawn++;
    }
  }
  
}
