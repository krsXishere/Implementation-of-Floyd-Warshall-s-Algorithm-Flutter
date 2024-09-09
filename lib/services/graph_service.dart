class GraphService {
  final int numberOfVertices;
  List<List<int>>? adjacencyMatrix;
  static const int infinity = 1000000;

  GraphService(this.numberOfVertices) {
    adjacencyMatrix = List.generate(
      numberOfVertices,
      (_) => List.filled(
        numberOfVertices,
        infinity,
      ),
    );
    for (int i = 0; i < numberOfVertices; i++) {
      adjacencyMatrix![i][i] = 0;
    }
  }

  void setMatrix(List<List<int>> matrix) {
    for (int i = 0; i < numberOfVertices; i++) {
      for (int j = 0; j < numberOfVertices; j++) {
        if (matrix[i][j] == -1) {
          adjacencyMatrix![i][j] = infinity;
        } else {
          adjacencyMatrix![i][j] = matrix[i][j];
        }
      }
    }
  }

   List<int> primMST() {
    int V = numberOfVertices;
    var key = List<int>.filled(V, GraphService.infinity);
    var parent = List<int>.filled(V, -1);
    var mstSet = List<bool>.filled(V, false);

    key[0] = 0;

    for (int count = 0; count < V - 1; count++) {
      int u = _minKey(key, mstSet);
      mstSet[u] = true;

      for (int v = 0; v < V; v++) {
        if (adjacencyMatrix![u][v] != 0 && adjacencyMatrix![u][v] != GraphService.infinity && !mstSet[v] && adjacencyMatrix![u][v] < key[v]) {
          parent[v] = u;
          key[v] = adjacencyMatrix![u][v];
        }
      }
    }

    _printMST(parent);

    return parent;
  }

  int _minKey(List<int> key, List<bool> mstSet) {
    int min = GraphService.infinity, minIndex = -1;

    for (int v = 0; v < numberOfVertices; v++) {
      if (!mstSet[v] && key[v] < min) {
        min = key[v];
        minIndex = v;
      }
    }

    return minIndex;
  }

  void _printMST(List<int> parent) {
    // print('Edge \tWeight');
    // int totalWeight = 0;
    for (int i = 1; i < numberOfVertices; i++) {
      // print('${parent[i]} - $i \t${adjacencyMatrix![i][parent[i]]}');
      // totalWeight += adjacencyMatrix![i][parent[i]];
    }
    // print('Total Weight: $totalWeight');
  }
}
