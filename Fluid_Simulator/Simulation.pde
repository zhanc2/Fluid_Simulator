class Simulation {
  
  Fluid water;
  float gravity;
  Grid grid;
  
  Simulation() {
    this.gravity = 1;
    
    this.water = new Fluid(1, 1, 20, color(0, 0, 255));
    for (int i = 0; i < 7; i++) {
      for (int j = 0; j < 7; j++) {
        this.water.addLiquid(50+40*i, 50+40*j);
      }
    }
    
    this.grid = new Grid(10);
  }
  
  void liquids() {
    water.updateLiquid(gravity);
  }
  
}
