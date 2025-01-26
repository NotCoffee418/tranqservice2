import 'package:flutter/material.dart';
import 'package:tranqservice2/widgets/screen_layout.dart';
import 'add_playlist_screen.dart';

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
      body: Stack(
        children: [
          Column(
            children: [
              Text(
                'Playlist page whee',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
            ],
          ),
          Positioned(
            bottom: 16,
            right: 16,
            child: ElevatedButton.icon(
              onPressed: () async {
                // Clear any lingering SnackBars before navigation
                ScaffoldMessenger.of(context).clearSnackBars();

                final bool? playlistAdded = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const AddPlaylistScreen(),
                  ),
                );

                // Show SnackBar if a playlist was added
                if (playlistAdded == true && mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Playlist added successfully!'),
                      behavior: SnackBarBehavior.floating,
                      margin: EdgeInsets.only(
                        bottom: 80,
                        left: 16,
                        right: 16,
                      ),
                      duration: Duration(seconds: 3),
                    ),
                  );
                }
              },
              icon: const Icon(Icons.add),
              label: const Text('Add Playlist'),
            ),
          ),
        ],
      ),
    );
  }
}
