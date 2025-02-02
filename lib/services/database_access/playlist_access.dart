import 'package:tranqservice2/models/database_models/playlist_model.dart';
import 'package:tranqservice2/services/database_service.dart';
import 'package:sqflite/sqflite.dart';

class PlaylistAccess {
  // Fetch all playlists from the database
  static Future<List<Playlist>> getPlaylists() async {
    final db = await DatabaseService.getDb();
    final result = await db.query('playlists');
    return result.map((map) => Playlist.fromMap(map)).toList();
  }

  static Future<void> addPlaylist(String name, String url, String directory, String format, String thumbnail) async {
    final db = await DatabaseService.getDb();

    await db.insert(
      'playlists',
      {
        'name': name,
        'url': url,
        'output_format': format,
        'save_directory': directory,
        'thumbnail_base64': thumbnail,
        'is_enabled': 1, // Default to enabled
        'added_at': DateTime.now().toIso8601String(),
      },
      conflictAlgorithm: ConflictAlgorithm.ignore, // Prevent duplicate URL/Dir/Format combos
    );
  }
}
