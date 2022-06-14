class Grid {
  
  ArrayList<FluidParticle>[][] cells;
  float cellSize;
  
  Grid(int gridSize) {
    this.cells = new ArrayList[gridSize][gridSize];
    for (int i = 0; i < gridSize; i++) {
      for (int j = 0; j < gridSize; j++) {
        this.cells[i][j] = new ArrayList<FluidParticle>();
      }
    }
    this.cellSize = (float(n)/float(gridSize));
  }
  
  void add(FluidParticle i) {
    int cellX = int(i.pos.x / this.cellSize);
    int cellY = int(i.pos.y / this.cellSize);
    cells[max(0,min(cellX,9))][max(0,min(cellY,9))].add(i);
    i.currentGridCell[0] = max(0,min(cellX,9));
    i.currentGridCell[1] = max(0,min(cellY,9));
  }
  
  void updateCellPosition(FluidParticle i) {
    cells[i.currentGridCell[0]][i.currentGridCell[1]].remove(i);
    this.add(i);
  }
  
  void handleCells(float gravity, float subStepAmount) {
    for (int i = 0; i < cells.length; i++) {
      for (int j = 0; j < cells.length; j++) {
        try {
          handleCell(cells[i][j], gravity, subStepAmount, i, j);
        }
        catch(Exception e) {
            
        }
      }
    }
  }
  
  void handleCell(ArrayList<FluidParticle> l, float gravity, float subStepAmount, int iIndex, int jIndex) {
    for (int i = 0; i < l.size(); i++) {
      for (int k = 0; k < subStepAmount; k++) {
        l.get(i).update(gravity, subStepAmount);
        this.updateCellPosition(l.get(i));
        for (int j = 0; j < l.size(); j++) {
          if (i != j) {
            l.get(i).collision(l.get(j), false);
            l.get(i).boundaries();
          }
        }
        for (int u = -1; u < 2; u++) {
          for (int  v = -1; v < 2; v++) {
            if (u != 0 && v != 0) {
              try {
                for (int j = 0; j < cells[iIndex+u][jIndex+v].size(); j++) {
                  l.get(i).collision(cells[iIndex+u][jIndex+v].get(j), false);
                  l.get(i).boundaries();
                }
              }
              catch (Exception e) {}
            }
          }
        }
        l.get(i).boundaries();
      }
      l.get(i).display();
    }
  }
  
}
