import 'package:tranqservice2/models/database_models/playlist_model.dart';
import 'package:tranqservice2/services/database_service.dart';
import 'package:sqlite3/sqlite3.dart';

class PlaylistAccess {
  static void updatePlaylistName(int id, String newName) {
    final db = DatabaseService.getDb();
    db.execute('UPDATE playlists SET name = ? WHERE id = ?', [newName, id]);
    print("✅ Playlist name updated (ID: $id)");
  }

  static void deletePlaylist(int id) {
    final db = DatabaseService.getDb();
    db.execute('DELETE FROM playlists WHERE id = ?', [id]);
    print("✅ Playlist deleted (ID: $id)");
  }

  static void updatePlaylistThumbnail(int id, String thumbnailBase64) {
    final db = DatabaseService.getDb();
    db.execute('UPDATE playlists SET thumbnail_base64 = ? WHERE id = ?', [thumbnailBase64, id]);
    print("✅ Playlist thumbnail updated (ID: $id)");
  }

  static List<Playlist> getPlaylists() {
    final db = DatabaseService.getDb();
    final result = db.select('SELECT * FROM playlists');

    return result.map((row) => Playlist.fromMap(row)).toList();
  }

  static void addPlaylist(String name, String url, String directory, String format, String thumbnail) {
    final db = DatabaseService.getDb();

    db.execute(
      '''
      INSERT INTO playlists (name, url, output_format, save_directory, thumbnail_base64, is_enabled, added_at)
      VALUES (?, ?, ?, ?, ?, 1, ?)
      ''',
      [name, url, format, directory, thumbnail, DateTime.now().toIso8601String()],
    );

    print("✅ Playlist added: $name");
  }
}
