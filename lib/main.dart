import 'package:flutter/material.dart';
import 'package:implement_floy_warshall_algorithm/pages/graph_page.dart';
import 'package:implement_floy_warshall_algorithm/providers/graph_provider.dart';
import 'package:implement_floy_warshall_algorithm/services/graph_service.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => GraphProvider(
            GraphService(6),
          ),
        )
      ],
      child: Builder(builder: (context) {
        return const MaterialApp(
          home: GraphPage(),
        );
      }),
    );
  }
}
