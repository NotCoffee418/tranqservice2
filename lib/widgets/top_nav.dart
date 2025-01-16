import 'package:flutter/material.dart';
import '../config.dart';

class TopNav extends StatelessWidget {
  final String activeScreenTitle;

  const TopNav({
    super.key,
    required this.activeScreenTitle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.red,
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start, // Align items to the left
        children: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Text(
              Config.appName,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
          ),
          ...Config.topNavRoutes.map((route) {
          final isActive = route.title == activeScreenTitle;

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: TextButton(
              onPressed: () {
                if (!isActive) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => route.screenBuilder()),
                  );
                }

              },
              style: TextButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                minimumSize: const Size(0, 0),
              ),
              child: Text(
                route.title,
                style: TextStyle(
                  color: isActive ? Colors.limeAccent : Colors.white,
                  fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
                  fontSize: 16,
                ),
              ),
            ),
          );
        }),
        ],
      ),
    );
  }
}
