import 'package:tranqservice2/models/database_models/playlist_model.dart';
import 'package:tranqservice2/services/ytdlp_service.dart';
import 'package:tranqservice2/services/database_access/playlist_access.dart';
import 'package:tranqservice2/services/database_access/log_access.dart';

class PlaylistChecks {
  static Future<void> verifyAndUpdatePlaylist(Playlist playlist, Map<String, dynamic>? fetchedInfo) async {
    LogAccess.addLog(LogVerbosity.info, 'Checking playlist: ${playlist.url}');
    
    if (fetchedInfo == null) {
      LogAccess.addLog(LogVerbosity.error, 'Fetched info for playlist is null: ${playlist.url}');
      return;
    }
    bool needsUpdate = false;

    // Check if name has changed
    if (playlist.name != fetchedInfo['title']) {
      LogAccess.addLog(LogVerbosity.info, 'Updating playlist name: ${playlist.name} -> ${fetchedInfo['title']}');
      PlaylistAccess.updatePlaylistName(playlist.id, fetchedInfo['title']);
      needsUpdate = true;
    }

    // Check if thumbnail is missing and update it
    if ((playlist.thumbnailBase64 == null || playlist.thumbnailBase64!.isEmpty) && fetchedInfo['thumbnail'] != null) {
      LogAccess.addLog(LogVerbosity.info, 'Updating missing thumbnail for playlist: ${playlist.name}');
      final thumbnailBase64 = await YtdlpService.fetchAndConvertThumbnail(fetchedInfo['thumbnail']);
      if (thumbnailBase64.isNotEmpty) {
        PlaylistAccess.updatePlaylistThumbnail(playlist.id, thumbnailBase64);
        needsUpdate = true;
      }
    }

    if (!needsUpdate) {
      LogAccess.addLog(LogVerbosity.debug, 'No updates needed for playlist: ${playlist.name}');
    }
  }
}
