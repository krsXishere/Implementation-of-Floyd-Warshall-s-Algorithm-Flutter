// ignore_for_file: prefer_const_constructors

import 'dart:math';
import 'package:flutter/material.dart';
import 'package:implement_floy_warshall_algorithm/providers/graph_provider.dart';
import 'package:implement_floy_warshall_algorithm/services/graph_service.dart';
import 'package:provider/provider.dart';

class GraphPage extends StatefulWidget {
  const GraphPage({super.key});

  @override
  State<GraphPage> createState() => _GraphPageState();
}

class _GraphPageState extends State<GraphPage> {
  final int numberOfVertices = 6; 
 // Ganti dengan jumlah simpul yang sesuai
  List<TextEditingController> controllers = [];

  @override
  void initState() {
    super.initState();
    controllers = List.generate(numberOfVertices * numberOfVertices, (index) => TextEditingController());
  }

  List<List<int>> getMatrix() {
    List<List<int>> matrix = List.generate(numberOfVertices, (_) => List.filled(numberOfVertices, GraphService.infinity));
    for (int i = 0; i < numberOfVertices; i++) {
      for (int j = 0; j < numberOfVertices; j++) {
        int value = int.tryParse(controllers[i * numberOfVertices + j].text) ?? GraphService.infinity;
        if (value == -1) {
          value = GraphService.infinity;
        }
        matrix[i][j] = value;
      }
    }
    return matrix;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Graph Input'),
      ),
      body: Column(
        children: [
         Expanded(
            child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: numberOfVertices),
              itemCount: numberOfVertices * numberOfVertices,
              itemBuilder: (context, index) {
                return TextField(
                  controller: controllers[index],
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: '0 atau -1', // Berikan petunjuk untuk nilai tak terbatas
                  ),
                );
              },
            ),
          ),
          ElevatedButton(
            onPressed: () {
              List<List<int>> matrix = getMatrix();
              Provider.of<GraphProvider>(context, listen: false).setMatrix(matrix);
              Provider.of<GraphProvider>(context, listen: false).computeShortestPaths();
            },
            child: const Text('Compute Shortest Paths'),
          ),
          Expanded(
            child: Consumer<GraphProvider>(
              builder: (context, graphProvider, child) {
                return ListView.builder(
                  itemCount: graphProvider.distance.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(graphProvider.distance[index].toString()),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class GraphPainter extends CustomPainter {
  final GraphService graph;

  GraphPainter(this.graph);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.blue
      ..strokeWidth = 2;

    final textPainter = TextPainter(
      textAlign: TextAlign.center,
      textDirection: TextDirection.ltr,
    );

    double centerX = size.width / 2;
    double centerY = size.height / 2;
    double radius = 20;
    double angleStep = 2 * pi / graph.numberOfVertices;

    List<Offset> vertices = [];

    for (int i = 0; i < graph.numberOfVertices; i++) {
      double angle = i * angleStep;
      double x = centerX + (size.width / 3) * cos(angle);
      double y = centerY + (size.height / 3) * sin(angle);
      vertices.add(Offset(x, y));
    }

    // Draw edges
    for (int i = 0; i < graph.numberOfVertices; i++) {
      for (int j = 0; j < graph.numberOfVertices; j++) {
        if (graph.adjacencyMatrix![i][j] != GraphService.infinity) {
          canvas.drawLine(vertices[i], vertices[j], paint);

          // Draw weight
          double midX = (vertices[i].dx + vertices[j].dx) / 2;
          double midY = (vertices[i].dy + vertices[j].dy) / 2;
          textPainter.text = TextSpan(
            text: graph.adjacencyMatrix![i][j].toString(),
            style: const TextStyle(color: Colors.black, fontSize: 12),
          );
          textPainter.layout();
          textPainter.paint(canvas, Offset(midX, midY));
        }
      }
    }

    // Draw vertices
    for (int i = 0; i < vertices.length; i++) {
      canvas.drawCircle(vertices[i], radius, paint);
      textPainter.text = TextSpan(
        text: '$i',
        style: const TextStyle(color: Colors.white, fontSize: 16),
      );
      textPainter.layout();
      textPainter.paint(
        canvas,
        Offset(vertices[i].dx - textPainter.width / 2,
            vertices[i].dy - textPainter.height / 2),
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
