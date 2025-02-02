import 'package:tranqservice2/models/database_models/playlist_model.dart';
import 'package:tranqservice2/services/database_service.dart';
import 'package:sqflite/sqflite.dart';

class PlaylistAccess {
  // Fetch all playlists from the database
  Future<List<Playlist>> getPlaylists() async {
    // Get the database instance
    final db = await DatabaseService.getDb();

    // Query all rows from the "playlists" table
    final result = await db.query('playlists');

    // Map the result to a list of Playlist models
    return result.map((map) => Playlist.fromMap(map)).toList();
  }

  Future<void> addPlaylist(String url, String directory, String format) async {
    final db = await DatabaseService.getDb();

    await db.insert(
      'playlists',
      {
        'url': url,
        'directory': directory,
        'format': format,
        'added_at': DateTime.now().toIso8601String(),
      },
      conflictAlgorithm: ConflictAlgorithm.ignore, // Prevent duplicate URL/Dir/Format combos
    );
  }

}
