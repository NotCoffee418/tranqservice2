import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:tranqservice2/services/database_access/log_access.dart';
import 'package:tranqservice2/services/path_service.dart';

class YtdlpService {
  /// Determines the correct yt-dlp download URL based on the OS
  static String get _ytDlpReleaseUrl {
    return Platform.isWindows
        ? 'https://github.com/yt-dlp/yt-dlp/releases/latest/download/yt-dlp.exe'
        : 'https://github.com/yt-dlp/yt-dlp/releases/latest/download/yt-dlp';
  }

  /// Get the path to yt-dlp in the local working directory
  static Future<String> getYtdlpPath() async {
    final fileName = Platform.isWindows ? 'yt-dlp.exe' : 'yt-dlp';
    return PathService.getWorkingFile(fileName);
  }

  /// Run yt-dlp and return its version as a string
  static Future<String?> getLocalVersion() async {
    final ytdlpPath = await getYtdlpPath();
    final file = File(ytdlpPath);

    if (!await file.exists()) return null;

    try {
      final result = await Process.run(ytdlpPath, ['--version'], stdoutEncoding: utf8);

      if (result.exitCode == 0) {
        return result.stdout.trim();
      }
    } catch (_) {}

    return null;
  }

  /// Fetch latest yt-dlp version from GitHub
  static Future<String?> getLatestVersion() async {
    try {
      final response = await http.get(Uri.parse('https://api.github.com/repos/yt-dlp/yt-dlp/releases/latest'));

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        return jsonData['tag_name'].replaceAll('yt-dlp ', '').trim();
      }
    } catch (_) {}

    return null;
  }

  /// Check if the local yt-dlp is outdated
  static Future<bool> isYtdlpOutdated() async {
    final localVersion = await getLocalVersion();
    final latestVersion = await getLatestVersion();

    if (localVersion == null || latestVersion == null) {
      return true; // If we can't determine, assume outdated
    }

    return localVersion != latestVersion;
  }

  /// Download or update yt-dlp if outdated
  static Future<bool> ensureYtdlp() async {
    final ytdlpPath = await getYtdlpPath();
    final file = File(ytdlpPath);

    if (!await isYtdlpOutdated()) {
      return true; // Already up to date
    }

    try {
      final response = await http.get(Uri.parse(_ytDlpReleaseUrl));

      if (response.statusCode != 200) {
        return false;
      }

      await file.writeAsBytes(response.bodyBytes);
      if (!Platform.isWindows) {
        await Process.run('chmod', ['+x', ytdlpPath]);
      }

      return true;
    } catch (_) {
      return false;
    }
  }

  /// Fetch playlist info using yt-dlp
  static Future<Map<String, dynamic>?> fetchPlaylistInfo(String url) async {
    if (!await ensureYtdlp()) {
      return null;
    }

    try {
      final ytdlpPath = await getYtdlpPath();

      final result = await Process.run(
        ytdlpPath,
        ['--flat-playlist', '--dump-single-json', url],
        stdoutEncoding: utf8,
        stderrEncoding: utf8,
      );

      if (result.exitCode != 0) {
        return null;
      }

      final jsonData = jsonDecode(result.stdout);

      if (!jsonData.containsKey('entries')) {
        return null;
      }

      return {
        'title': jsonData['title'] ?? 'Unknown Playlist',
        'thumbnail': jsonData['thumbnail'] ?? '',
        'video_count': jsonData['entries'].length,
      };
    } catch (_) {
      LogAccess.addLog(LogVerbosity.debug, 'Error fetching playlist info: $_');
      return null;
    }
  }

  static Future<String> fetchAndConvertThumbnail(String url) async {
    if (url.isEmpty) {
      return '';
    }

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        return base64Encode(response.bodyBytes);
      } else {
        LogAccess.addLog(LogVerbosity.debug, 'Failed to fetch thumbnail: ${response.statusCode}');
      }
    } catch (e) {
      LogAccess.addLog(LogVerbosity.debug, 'Error fetching thumbnail: $e');
    }
    return '';
  }
}
