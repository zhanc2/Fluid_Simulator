class Grid {
  
  LinkedList[][] cells;
  float cellSize;
  
  Grid(int gridSize) {
    this.cells = new LinkedList[gridSize][gridSize];
    for (int i = 0; i < gridSize; i++) {
      for (int j = 0; j < gridSize; j++) {
        this.cells[i][j] = new LinkedList();
      }
    }
    this.cellSize = (float(n)/float(gridSize));
  }
  
  void add(FluidParticle i) {
    int cellX = int(i.pos.x / this.cellSize);
    int cellY = int(i.pos.y / this.cellSize);
    cells[max(0,min(cellX,9))][max(0,min(cellY,9))].addNode(i);
    i.currentGridCell[0] = max(0,min(cellX,9));
    i.currentGridCell[1] = max(0,min(cellY,9));
  }
  
  void updateCellPosition(FluidParticle i) {
    cells[i.currentGridCell[0]][i.currentGridCell[1]].removeNode(i);
    this.add(i);
  }
  
  void handleCells() {
    for (int i = 0; i < cells.length; i++) {
      for (int j = 0; j < cells.length; j++) {
        for (int u = -1; u < 2; u++) {
          for (int v = -1; v < 2; v++) {
            try {
              handleCell(cells[i+u][j+v]);
            }
            catch(Exception e) {
            
            }
          }
        }
      }
    }
  }
  
  void handleCell(LinkedList l) {
    if (l == null) return;
    if (l.head == null) return;
    Node current = l.head;
    Node next;
    while (current != null) {
      next = current.next;
      while (next != null) {
        current.item.collision(next.item);
        next = next.next;
      }
      current = current.next;
    }
  }
  
}
