class Fluid {
 
  float density;
  float viscosity;
  float sizeOfLiquidParticles;
  color c;
  
  Fluid(float d, float v, float sOLP, color C) {
    this.density = d;
    this.viscosity = v;
    this.sizeOfLiquidParticles = sOLP;
    this.c = C;
  }
  
  FluidParticle createLiquid(float x, float y) {
    FluidParticle p = new FluidParticle(new PVector(x, y), color(0, 0, 255), this.sizeOfLiquidParticles);
    return p;
  }
  
}
