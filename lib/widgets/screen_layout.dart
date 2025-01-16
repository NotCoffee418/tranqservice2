import 'package:flutter/material.dart';
import 'top_nav.dart';

class ScreenLayout extends StatelessWidget {
  final String title;
  final Widget body;

  const ScreenLayout({
    super.key,
    required this.title,
    required this.body,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TopNav(activeScreenTitle: title),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: DefaultTextStyle(
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                ),
                child: body,
              ),
            ),
          ),
        ],
      ),
    );
  }
}