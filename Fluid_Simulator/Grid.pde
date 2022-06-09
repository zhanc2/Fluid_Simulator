class Grid {
  
  LinkedList[][] cells;
  float cellSize;
  
  Grid(int gridSize) {
    this.cells = new LinkedList[gridSize][gridSize];
    this.cellSize = n/(gridSize);
  }
  
  void add(FluidParticle i) {
    int cellX = int(i.pos.x / this.cellSize);
    int cellY = int(i.pos.y / this.cellSize);
    cells[cellX][cellY].addNode(i);
  }
  
  void updateCellPosition(FluidParticle i) {
    cells[i.currentGridCell[0]][i.currentGridCell[1]].removeNode(i);
    this.add(i);
  }
  
}
