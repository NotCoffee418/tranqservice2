import 'package:flutter/material.dart';
import 'package:tranqservice2/widgets/screen_layout.dart';
class SettingsScreen extends StatefulWidget {
  static const title = 'Settings';
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    return const ScreenLayout(
      title: SettingsScreen.title,
      body: Column(
        children: [
          Text('Settings page whee'),
        ],
      ),
    );
  }
}