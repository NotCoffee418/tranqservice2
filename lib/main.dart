import 'dart:async';
import 'package:flutter/material.dart';
import 'package:tranqservice2/screens/playlist_screen.dart';
import 'package:tranqservice2/services/database_service.dart';

// flutter run --dart-define=MODE=service
// flutter run --dart-define=MODE=ui

void main() {
  final mode = const String.fromEnvironment('MODE', defaultValue: 'ui');

  // background init database
  DatabaseService.getDb();

  // Run app in defined mode
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
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.red,
          brightness: Brightness.dark,
        ),
        snackBarTheme: const SnackBarThemeData(
          behavior: SnackBarBehavior.floating, // Make all SnackBars floating globally
          backgroundColor: Colors.grey,
          contentTextStyle: TextStyle(color: Colors.white),
          elevation: 6,
        ),
        scaffoldBackgroundColor: const Color.fromARGB(255, 75, 75, 75),
        inputDecorationTheme: const InputDecorationTheme(
          filled: true,
          fillColor: Color.fromARGB(255, 50, 50, 50),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(8)),
            borderSide: BorderSide(color: Colors.white30),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(8)),
            borderSide: BorderSide(color: Colors.white70, width: 2),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(8)),
            borderSide: BorderSide(color: Colors.red, width: 2),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(8)),
            borderSide: BorderSide(color: Colors.red, width: 2),
          ),
          labelStyle: TextStyle(color: Colors.white70),
          floatingLabelStyle: TextStyle(color: Colors.white),
          hintStyle: TextStyle(color: Colors.white54),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red, // Button background color
            foregroundColor: Colors.white, // Button text color
            minimumSize: const Size(0, 48), // Matches the height of text fields
            padding: const EdgeInsets.symmetric(horizontal: 16), // Horizontal padding
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8), // Consistent corner radius with text fields
            ),
            elevation: 2, // Slight elevation for depth
          ),
        ),
      ),
    );
  }
}
