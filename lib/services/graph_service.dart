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
}
