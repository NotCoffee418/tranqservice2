import 'package:tranqservice2/models/database_models/download_model.dart';
import 'package:tranqservice2/services/database_service.dart';

class DownloadRepository {
  // Retrieve all downloads sorted by descending last_attempt with an optional limit
  static List<Download> getAllDownloads({int limit = 100}) {
    final db = DatabaseService.getDb();

    final result = db.select(
      'SELECT * FROM downloads ORDER BY last_attempt DESC LIMIT ?',
      [limit],
    );

    return result.map((row) => Download.fromMap(row)).toList();
  }

  // Fetch all downloads for a specific playlist
  static List<Download> getDownloadsForPlaylist(int playlistId) {
    final db = DatabaseService.getDb();

    final result = db.select(
      'SELECT * FROM downloads WHERE playlist_id = ?',
      [playlistId],
    );

    return result.map((row) => Download.fromMap(row)).toList();
  }

  // Update the status of a download
  static void updateDownloadStatus({
    required int id,
    required int newStatus,
    String? failMessage,
  }) {
    final db = DatabaseService.getDb();

    db.execute(
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
    
    print("✅ Download status updated (ID: $id, Status: $newStatus)");
  }
}
