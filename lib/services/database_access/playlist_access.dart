import 'package:tranqservice2/models/database_models/playlist_model.dart';
import 'package:tranqservice2/services/database_service.dart';

class PlaylistRepository {
  // Fetch all playlists from the database
  Future<List<Playlist>> getPlaylists() async {
    // Get the database instance
    final db = await DatabaseService.getDb();

    // Query all rows from the "playlists" table
    final result = await db.query('playlists');

    // Map the result to a list of Playlist models
    return result.map((map) => Playlist.fromMap(map)).toList();
  }
}
