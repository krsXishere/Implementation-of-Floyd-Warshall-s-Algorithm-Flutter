import 'package:flutter/material.dart';
import 'package:implement_floy_warshall_algorithm/services/graph_service.dart';

class GraphProvider with ChangeNotifier {
  final GraphService? _graphService;
  GraphService? get graphService => _graphService;

  GraphProvider(this._graphService);

  List<List<int>> _distance = [];
  List<List<int>> get distance => _distance;

  void setMatrix(List<List<int>> matrix) {
    _graphService!.setMatrix(matrix);
    notifyListeners();
  }

  void computeShortestPaths() {
    _distance = List.generate(
      _graphService!.numberOfVertices,
      (i) => List<int>.from(
        _graphService.adjacencyMatrix![i],
      ),
    );

    for (int intermediateVertex = 0;
        intermediateVertex < _graphService.numberOfVertices;
        intermediateVertex++) {
      for (int startVertex = 0;
          startVertex < _graphService.numberOfVertices;
          startVertex++) {
        for (int endVertex = 0;
            endVertex < _graphService.numberOfVertices;
            endVertex++) {
          if (_distance[startVertex][endVertex] >
              _distance[startVertex][intermediateVertex] +
                  _distance[intermediateVertex][endVertex]) {
            _distance[startVertex][endVertex] = _distance[startVertex]
                    [intermediateVertex] +
                _distance[intermediateVertex][endVertex];
          }
        }
      }
    }
    notifyListeners();
  }
}
