import 'package:flutter/material.dart';
import 'package:implement_floy_warshall_algorithm/models/edge_model.dart';

class MSTProvider with ChangeNotifier {
  List<EdgeModel> _listEdge = [];
  List<EdgeModel> get listEdge => _listEdge;

  void setMSTEdge(List<EdgeModel> edges) {
    _listEdge = edges;
    notifyListeners();
  }
}