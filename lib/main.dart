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
        scaffoldBackgroundColor: const Color.fromARGB(255, 75, 75, 75),
        textTheme: const TextTheme(
          bodyMedium: TextStyle(
            color: Colors.white,
            fontSize: 14,
          ),
          headlineSmall: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        
        inputDecorationTheme: const InputDecorationTheme(
          filled: true,
          fillColor: Color.fromARGB(255, 50, 50, 50), // Default darker gray for input fields
          border: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(8)),
            borderSide: BorderSide(color: Colors.white30), // Subtle gray border for inactive fields
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(8)),
            borderSide: BorderSide(color: Colors.white30), // Same for non-focused active
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(8)),
            borderSide: BorderSide(color: Colors.white70, width: 2), // Bright white for focus
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(8)),
            borderSide: BorderSide(color: Colors.red, width: 2), // Red strictly for validation errors
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(8)),
            borderSide: BorderSide(color: Colors.red, width: 2), // Red for focused errors only
          ),
          labelStyle: TextStyle(color: Colors.white70), // Subtle label when inactive
          floatingLabelStyle: TextStyle(color: Colors.white), // White label when focused
          hintStyle: TextStyle(color: Colors.white54), // Subtle gray for hint text
        ),


        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(24),
            ),
            elevation: 6,
          ),
        ),
        snackBarTheme: const SnackBarThemeData(
          backgroundColor: Colors.grey,
          contentTextStyle: TextStyle(color: Colors.white),
          behavior: SnackBarBehavior.floating,
          elevation: 6,
        ),
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: Colors.red,
          foregroundColor: Colors.white,
        ),
      ),

    );
  }
}
