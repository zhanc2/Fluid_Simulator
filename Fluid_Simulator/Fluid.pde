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
  }
  
}
