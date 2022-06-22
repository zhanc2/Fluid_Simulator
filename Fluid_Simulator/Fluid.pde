class Fluid {
  float viscosity;
  float sizeOfLiquidParticles;
  color c;
  float density;
  
  String name;
  
  Fluid(float v, float sOLP, color C, float d, String n) {
    this.viscosity = v;
    this.sizeOfLiquidParticles = sOLP;
    this.c = C;
    this.density = d;
    this.name = n;
  }
  
  FluidParticle createLiquid(float x, float y) {
    FluidParticle p = new FluidParticle(new PVector(x, y), this.c, this.sizeOfLiquidParticles, this.density, this.name);
    return p;
  }
  
}
