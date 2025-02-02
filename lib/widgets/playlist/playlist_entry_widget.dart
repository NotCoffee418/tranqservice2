import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:io';
import 'package:url_launcher/url_launcher.dart';
import 'package:tranqservice2/models/database_models/playlist_model.dart';
import 'package:tranqservice2/services/database_access/playlist_access.dart';
class PlaylistEntryWidget extends StatelessWidget {
  final VoidCallback onDeleted;
  final Playlist playlist;
  
  const PlaylistEntryWidget({super.key, required this.playlist, required this.onDeleted});

  Future<void> _showOptionsMenu(BuildContext context, TapDownDetails details) async {
    final RenderBox overlay = Overlay.of(context).context.findRenderObject() as RenderBox;
    showMenu(
      context: context,
      position: RelativeRect.fromRect(
        Rect.fromPoints(details.globalPosition, details.globalPosition.translate(1, 1)),
        Offset.zero & overlay.size,
      ),
      items: [
        PopupMenuItem(
          child: ListTile(
            leading: const Icon(Icons.open_in_browser),
            title: const Text('Open Playlist'),
            onTap: () async {
              final Uri playlistUri = Uri.parse(playlist.url);
              if (await canLaunchUrl(playlistUri)) {
                await launchUrl(playlistUri, mode: LaunchMode.externalApplication);
              } else {
                print('Could not open URL: \${playlist.url}');
              }
              Navigator.pop(context);
            },
          ),
        ),
        PopupMenuItem(
          child: ListTile(
            leading: const Icon(Icons.folder_open),
            title: const Text('Open Directory'),
            onTap: () async {
              final directoryPath = playlist.saveDirectory;
              if (Platform.isWindows) {
                await Process.run('explorer', [directoryPath]);
              } else if (Platform.isLinux || Platform.isMacOS) {
                await Process.run('xdg-open', [directoryPath]);
              } else {
                print('Unsupported platform for opening directories.');
              }
              Navigator.pop(context);
            },
          ),
        ),
        PopupMenuItem(
          child: ListTile(
            leading: const Icon(Icons.delete, color: Colors.red),
            title: const Text('Remove Playlist', style: TextStyle(color: Colors.red)),
            onTap: () {
              Navigator.pop(context);
              _confirmDelete(context);
            },
          ),
        ),
      ],
    );
  }

  Future<void> _confirmDelete(BuildContext context) async {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Confirm Deletion'),
          content: const Text('Are you sure you want to remove this playlist?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                Navigator.pop(context);
                await PlaylistAccess.deletePlaylist(playlist.id);
                if (context.mounted) {
                  onDeleted();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Playlist removed successfully')),
                  );
                }
              },
              child: const Text('Delete', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: ListTile(
        leading: playlist.thumbnailBase64 != null && playlist.thumbnailBase64!.isNotEmpty
            ? Image.memory(
                Uri.parse(playlist.thumbnailBase64!).data!.contentAsBytes(),
                width: 50,
                height: 50,
                fit: BoxFit.cover,
              )
            : const Icon(Icons.image_not_supported, size: 50),
        title: Text(playlist.name, style: Theme.of(context).textTheme.titleMedium),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Format: ${playlist.outputFormat}'),
            Text('Save Directory: ${playlist.saveDirectory}'),
            Text('Added: ${DateFormat('yyyy-MM-dd HH:mm').format(playlist.addedAt)}'),
          ],
        ),
        trailing: GestureDetector(
          onTapDown: (details) => _showOptionsMenu(context, details),
          child: const Icon(Icons.more_vert),
        ),
      ),
    );
  }
}
