import 'package:flutter/material.dart';
import 'package:implement_floy_warshall_algorithm/services/graph_service.dart';

class GraphProvider with ChangeNotifier {
  final GraphService? _graphService;
  GraphService? get graphService => _graphService;

  GraphProvider(this._graphService);

  List<List<int>> _distance = [];
  List<List<int>> get distance => _distance;

  final List<String> _tracks = [];
  List<String> get tracks => _tracks;

  final List<String> _msts = [];
  List<String> get msts => _msts;

  int _totalWeight = 0;
  int get totalWeight => _totalWeight;

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

  void computeShortestPathsPlus() {
    int V = _graphService!.numberOfVertices;
    var dist = List.generate(
        V, (i) => List<int>.from(_graphService.adjacencyMatrix![i]));
    var next =
        List.generate(V, (i) => List<int>.filled(V, -1), growable: false);

    for (int i = 0; i < V; i++) {
      for (int j = 0; j < V; j++) {
        if (i != j && dist[i][j] != GraphService.infinity) {
          next[i][j] = j;
        }
      }
    }

    for (int k = 0; k < V; k++) {
      for (int i = 0; i < V; i++) {
        for (int j = 0; j < V; j++) {
          if (dist[i][j] > dist[i][k] + dist[k][j]) {
            dist[i][j] = dist[i][k] + dist[k][j];
            next[i][j] = next[i][k];
          }
        }
      }
    }

    for (int i = 0; i < V; i++) {
      for (int j = 0; j < V; j++) {
        if (i != j) {
          // print('Path from $i to $j: ${constructPath(i, j, next)}');
          _tracks.add('Path from $i to $j: ${constructPath(i, j, next)}');
        }
      }
    }
  }

  List<int> constructPath(int u, int v, List<List<int>> next) {
    var path = [u];
    while (u != v) {
      u = next[u][v];
      path.add(u);
    }
    return path;
  }

  void primMST() {
    final data = _graphService!.primMST();
    _totalWeight = 0;
    _msts.clear();
    for (int i = 1; i < _graphService.numberOfVertices; i++) {
      _msts.add(
          '${data[i]} - $i \t${_graphService.adjacencyMatrix![i][data[i]]}');
      _totalWeight += _graphService.adjacencyMatrix![i][data[i]];
    }
    notifyListeners();
  }
}
