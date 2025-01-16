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
        children: [
          TopNav(activeScreenTitle: title),
          body,
        ],
      ),
    );
  }
}