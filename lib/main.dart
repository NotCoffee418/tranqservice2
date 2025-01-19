import 'dart:async';
import 'package:flutter/material.dart';
import 'package:tranqservice2/screens/playlist_screen.dart';

// flutter run --dart-define=MODE=service
// flutter run --dart-define=MODE=ui

void main() {
  final mode = const String.fromEnvironment('MODE', defaultValue: 'ui');

  if (mode == 'service') {
    runServiceMode();
  } else {
    runApp(const TranqService2());
  }
}

void runServiceMode() {
  print('Service mode started');
  Timer.periodic(const Duration(seconds: 5), (timer) {
    print('alive');
  });
}

class TranqService2 extends StatelessWidget {
  const TranqService2({super.key});

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
