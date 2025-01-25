import 'dart:io';
import 'package:path/path.dart' as p;
import 'package:tranqservice2/config.dart';

class PathService {
  static Future<String> getWorkingFile(String fileName, [List<String> parts = const []]) async {
    final workingDir = await getWorkingDir(parts);
    return p.join(workingDir, fileName);
  }

  static Future<String> getWorkingDir([List<String> parts = const []]) async {
    final String baseDir;

    if (Platform.isWindows) {
      baseDir = Platform.environment['LOCALAPPDATA'] ??
          (throw StateError('LOCALAPPDATA environment variable is not set.'));
    } else if (Platform.isLinux) {
      final home = Platform.environment['HOME'] ??
          (throw StateError('HOME environment variable is not set.'));
      baseDir = p.join(home, '.local', 'share');
    } else {
      throw UnsupportedError('Unsupported platform.');
    }

    final targetDir = parts.isEmpty
        ? p.join(baseDir, Config.workingDirName)
        : p.joinAll([baseDir, Config.workingDirName, ...parts]);

    final directory = Directory(targetDir);
    if (!await directory.exists()) {
      await directory.create(recursive: true);
    }

    return targetDir;
  }

}
