class Fluid {
 
  float density;
  float viscosity;
  float sizeOfLiquidParticles;
  color c;
  
  ArrayList<FluidParticle> particles;
  
  Fluid(float d, float v, float sOLP, color C) {
    this.density = d;
    this.viscosity = v;
    this.sizeOfLiquidParticles = sOLP;
    this.c = C;
    
    this.particles = new ArrayList<FluidParticle>();
  }
  
  void updateLiquid(float g) {
    for (int i = 0; i < this.particles.size(); i++) {
      this.particles.get(i).gravity(g);
      this.particles.get(i).applyForces();
      for (int j = i+1; j < this.particles.size(); j++) {
        this.particles.get(i).collision(this.particles.get(j));
      }
      this.particles.get(i).boundaries();
      this.particles.get(i).display();
      //println(this.particles.get(i).pos.x, this.particles.get(i).pos.y);
    }
  }
  
}
