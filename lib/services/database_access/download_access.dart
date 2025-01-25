import 'package:tranqservice2/models/database_models/download_model.dart';
import 'package:tranqservice2/services/database_service.dart';

class DownloadRepository {  
  // Function to retrieve all downloads sorted by descending last_attempt with an optional limit
  Future<List<Download>> getAllDownloads({int limit = 100}) async {
    // Get the database instance
    final db = await DatabaseService.getDb();

    // Query downloads sorted by last_attempt descending
    final result = await db.query(
      'downloads',
      orderBy: 'last_attempt DESC', // Sort by last_attempt in descending order
      limit: limit, // Optional limit
    );

    // Map the result to a list of Download models
    return result.map((map) => Download.fromMap(map)).toList();
  }

  // Fetch all downloads for a specific playlist
  Future<List<Download>> getDownloadsForPlaylist(int playlistId) async {
    // Get the database instance
    final db = await DatabaseService.getDb();

    // Query the "downloads" table for rows matching the playlistId
    final result = await db.query(
      'downloads',
      where: 'playlist_id = ?',
      whereArgs: [playlistId],
    );

    // Map the result to a list of Download models
    return result.map((map) => Download.fromMap(map)).toList();
  }

  Future<int> updateDownloadStatus({
  required int id,
  required int newStatus,
  String? failMessage,
  }) async {
    final db = await DatabaseService.getDb();

    return await db.rawUpdate(
      '''
      UPDATE downloads
      SET 
        status = ?,
        fail_message = COALESCE(?, fail_message),
        last_attempt = CURRENT_TIMESTAMP,
        attempt_count = attempt_count + 1
      WHERE id = ?
      ''',
      [newStatus, failMessage, id],
    );
  }

}
