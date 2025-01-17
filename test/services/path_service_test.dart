import 'dart:io';
import 'package:path/path.dart' as p;
import 'package:test/test.dart';
import 'package:tranqservice2/services/path_service.dart';
import 'package:tranqservice2/config.dart';

void main() {
  late PathService pathService;

  // Set up before tests
  setUp(() {
    pathService = PathService();
    Config.workingDirName = 'test_app'; // Set a test-specific app name
  });

  group('PathService Tests', () {
    test('getWorkingDir creates and returns correct path', () async {
      // Arrange
      const testSubDir = 'test_subdir';

      // Act
      final workingDir = await pathService.getWorkingDir([testSubDir]);

      // Assert
      expect(
        workingDir,
        p.join(
          Platform.isWindows
              ? (Platform.environment['APPDATA'] ?? (throw StateError('APPDATA not set')))
              : p.join(Platform.environment['HOME'] ?? (throw StateError('HOME not set')), '.local', 'share'),
          Config.workingDirName,
          testSubDir,
        ),
      );

      // Verify the directory exists
      final dir = Directory(workingDir);
      expect(dir.existsSync(), isTrue);

      // Clean up
      dir.deleteSync(recursive: true);
    });

    test('getWorkingFile creates correct file path', () async {
      // Arrange
      const testFileName = 'config.json';
      const testSubDir = 'other_subdir';

      // Act
      final filePath = await pathService.getWorkingFile(testFileName, [testSubDir]);

      // Assert
      expect(
        filePath,
        p.join(
          Platform.isWindows
              ? (Platform.environment['APPDATA'] ?? (throw StateError('APPDATA not set')))
              : p.join(Platform.environment['HOME'] ?? (throw StateError('HOME not set')), '.local', 'share'),
          Config.workingDirName,
          testSubDir,
          testFileName,
        ),
      );

      // Verify the directory exists
      final dir = Directory(p.dirname(filePath));
      expect(dir.existsSync(), isTrue);

      // Clean up
      dir.deleteSync(recursive: true);
    });

    test('Throws UnsupportedError on unsupported platforms', () async {
      // Mocking unsupported platform logic
      final unsupportedPlatform = !Platform.isWindows && !Platform.isLinux;

      if (unsupportedPlatform) {
        expect(
          () async => await pathService.getWorkingDir(),
          throwsA(isA<UnsupportedError>()),
        );
      }
    });
  });
}
