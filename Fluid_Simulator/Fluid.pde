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
    for (FluidParticle fp : this.particles) {
      fp.updatePosition();
      fp.gravity(g);
      fp.boundaries();
      fp.display();
    }
  }
  
}
