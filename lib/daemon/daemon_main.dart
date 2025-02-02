import 'dart:async';
import 'dart:io';
import 'package:tranqservice2/services/ytdlp_service.dart';
import 'package:tranqservice2/services/database_service.dart';
import 'package:tranqservice2/services/database_access/log_access.dart';

class DaemonMain {
  static void runDaemon() async {
    
    await LogAccess.addLog(LogVerbosity.debug, 'Daemon Mode: Starting up...');

    await DatabaseService.getDb(); // Ensure database is initialized
    await YtdlpService.ensureYtdlp(); // Update yt-dlp if needed

    await LogAccess.addLog(LogVerbosity.debug, 'Daemon Mode: Running background tasks...');

    while (true) {
      try {
        await _checkForNewVideos();
      } catch (e) {
        await LogAccess.addLog(LogVerbosity.error, 'Daemon encountered an error: \$e');
      }
      await Future.delayed(Duration(minutes: 5)); // Adjust interval as needed
    }
  }

  static Future<void> _checkForNewVideos() async {
    await LogAccess.addLog(LogVerbosity.info, 'Checking for new videos...');
    
    // Fetch all playlists from DB
    final db = await DatabaseService.getDb();
    final playlists = await db.query('playlists');

    for (final playlist in playlists) {
      final url = playlist['url'] as String;
      await LogAccess.addLog(LogVerbosity.info, 'Checking playlist: \$url');
      
      final info = await YtdlpService.fetchPlaylistInfo(url);
      if (info == null) {
        await LogAccess.addLog(LogVerbosity.error, 'Failed to fetch info for playlist: \$url');
        continue;
      }
      
      final videoCount = info['video_count'] as int;
      await LogAccess.addLog(LogVerbosity.info, 'Playlist "${info["title"]}" contains $videoCount videos.');
      
      // Logic to determine new videos & queue downloads goes here
    }
  }

}
