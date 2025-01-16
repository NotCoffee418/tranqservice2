import 'package:flutter/material.dart';
import 'package:tranqservice2/widgets/screen_layout.dart';
class HistoryScreen extends StatefulWidget {
  static const title = 'History';
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  @override
  Widget build(BuildContext context) {
    return const ScreenLayout(
      title: HistoryScreen.title,
      body: Column(
        children: [
          Text("History page whee"),
        ],
      ),
    );
  }
}