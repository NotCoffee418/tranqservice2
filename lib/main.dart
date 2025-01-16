import 'package:flutter/material.dart';
import 'package:tranqservice2/screens/playlist_screen.dart';

void main() {
  runApp(const TranqService2());
}

class TranqService2 extends StatelessWidget {
  const TranqService2({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TranqService2',
      home: const PlaylistScreen(),
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.red),
        scaffoldBackgroundColor: const Color.fromARGB(255, 75, 75, 75),
        textTheme: const TextTheme(
          bodyMedium: TextStyle(
            color: Colors.white,
            fontSize: 14,
          ),
        ),
      ),
    );
  }
}

