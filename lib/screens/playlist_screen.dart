import 'package:flutter/material.dart';
import 'package:tranqservice2/widgets/screen_layout.dart';

class PlaylistScreen extends StatefulWidget {
  static const title = 'Playlists';
  const PlaylistScreen({super.key});

  @override
  State<PlaylistScreen> createState() => _PlaylistScreenState();
}

class _PlaylistScreenState extends State<PlaylistScreen> {
  @override
  Widget build(BuildContext context) {
    return const ScreenLayout(
      title: PlaylistScreen.title,
      body: Center(
        child: Text('Playlist page whee'),
      ),
    );
  }
}