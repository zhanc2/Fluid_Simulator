class Fluid {
 
  float density;
  float viscosity;
  float sizeOfLiquidParticles;
  color c;
  
  //ArrayList<FluidParticle> particles;
  
  Fluid(float d, float v, float sOLP, color C) {
    this.density = d;
    this.viscosity = v;
    this.sizeOfLiquidParticles = sOLP;
    this.c = C;
    
    //this.particles = new ArrayList<FluidParticle>();
  }
  
  void addLiquid(float x, float y, Grid g) {
    FluidParticle p = new FluidParticle(new PVector(x, y), color(0, 0, 255), this.sizeOfLiquidParticles);
    //this.particles.add(p);
    g.add(p);
  }
  
  FluidParticle createLiquid(float x, float y) {
    FluidParticle p = new FluidParticle(new PVector(x, y), color(0, 0, 255), this.sizeOfLiquidParticles);
    return p;
  }
  
  //void updateLiquid(float g, Grid grid, float ssA) {
    //for (int i = 0; i < this.particles.size(); i++) {
    //  for (int j = 0; j < ssA; j++) this.particles.get(i).update(g, ssA, grid);
    //  this.particles.get(i).display();
    //  //println(this.particles.get(i).pos.x, this.particles.get(i).pos.y);
    //}
  //}
  
  //void updateLiquid(float g, Grid grid) {
  //  for (int i = 0; i < this.particles.size(); i++) {
  //    this.particles.get(i).gravity(g);
  //    this.particles.get(i).applyForces();
  //    grid.updateCellPosition(this.particles.get(i));
  //    //for (int j = i+1; j < this.particles.size(); j++) {
  //    //  this.particles.get(i).collision(this.particles.get(j));
  //    //}
  //    this.particles.get(i).boundaries();
  //    this.particles.get(i).display();
  //    //println(this.particles.get(i).pos.x, this.particles.get(i).pos.y);
  //  }
  //}
  
}
