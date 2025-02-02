import 'dart:async';
import 'dart:io';
import 'package:tranqservice2/services/ytdlp_service.dart';
import 'package:tranqservice2/services/database_service.dart';
import 'package:tranqservice2/services/database_access/log_access.dart';
import 'package:tranqservice2/services/database_access/playlist_access.dart';
import 'package:tranqservice2/daemon/playlist_checks.dart';

class DaemonMain {
  static void runDaemon() async {
    
    await LogAccess.addLog(LogVerbosity.debug, 'Daemon Mode: Starting up...');

    await DatabaseService.getDb(); // Ensure database is initialized
    await YtdlpService.ensureYtdlp(); // Update yt-dlp if needed

    await LogAccess.addLog(LogVerbosity.debug, 'Daemon Mode: Running background tasks...');

    while (true) {
      try {
        await _runDaemonIteration();
      } catch (e) {
        await LogAccess.addLog(LogVerbosity.error, 'Daemon encountered an error: \$e');
      }
      await Future.delayed(Duration(minutes: 5)); // Adjust interval as needed
    }
  }

  static Future<void> _runDaemonIteration() async {
    await LogAccess.addLog(LogVerbosity.info, 'Checking for new videos...');
    
    // Fetch all playlists from DB
    final playlists = await PlaylistAccess.getPlaylists();

    for (final playlist in playlists) {
      await LogAccess.addLog(LogVerbosity.info, 'Checking playlist: ${playlist.url}');
      
      // Fetch info from yt-dlp
      final info = await YtdlpService.fetchPlaylistInfo(playlist.url);
      if (info == null) {
        await LogAccess.addLog(LogVerbosity.error, 'Failed to fetch info for playlist: \$url');
        continue;
      }

      // Check if playlist needs to be updated
      await PlaylistChecks.verifyAndUpdatePlaylist(playlist, info);


      // Check video count
      final videoCount = info['video_count'] as int;
      await LogAccess.addLog(LogVerbosity.debug, 'Playlist "${info["title"]}" contains $videoCount videos.');
      
      // Logic to determine new videos & queue downloads goes here
    }
  }

}
