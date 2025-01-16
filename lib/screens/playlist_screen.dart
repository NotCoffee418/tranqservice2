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
    return ScreenLayout(
      title: PlaylistScreen.title,
      body: Column(
        children: [
          Text('Playlist page whee'),
        ],
      ),
    );
  }
}