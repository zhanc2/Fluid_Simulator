class LinkedList {
  
  LinkedList() {
    
  }
  
  Node head, tail = null;
  
  void addNode(FluidParticle i) {
    Node node = new Node(i);
    
    if (head == null) {
      this.head = node;
      this.tail = node;
      
      this.head.prev = null;
      this.tail.next = null;
    } else {
      this.tail.next = node;
      node.prev = tail;
      this.tail = node;
      this.tail.next = null;
    }
  }
  
  void removeNode(FluidParticle i) {
    if (this.head.item == i) {
      if (this.head.next == null) {
        this.head = null;
        return;
      }
      this.head.next.prev = null;
      this.head = this.head.next;
      return;
    }
    if (this.tail.item == i) {
      this.tail.prev.next = null;
      this.tail = this.tail.prev;
      return;
    }
    
    Node current = this.head;
    while (current.next != null) {
      if (current.item == i) {
        current.prev.next = current.next;
        current.next.prev = current.prev;
        return;
      }
      current = current.next;
    }
  }
  
  void printNodes() {
    Node current = this.head;
    while (current != null) {
      println(current.item.pos);
      current = current.next;
    }
  }
  
}
