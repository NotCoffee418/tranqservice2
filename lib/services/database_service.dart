import 'dart:io';
import 'package:sqlite3/sqlite3.dart';
import 'package:sqlite3_flutter_libs/sqlite3_flutter_libs.dart';
import 'package:path/path.dart';
import 'package:tranqservice2/services/path_service.dart';
import 'package:tranqservice2/services/migration_service.dart';

class DatabaseService {
  static Database? _db;
  static String? _dbPath;

  static Future<void> init() async {
    if (_db != null) return;

    print("🟡 Fetching database path...");
    _dbPath = await PathService.getWorkingFile('db.sqlite');
    print("📂 Database path: $_dbPath");

    final dbFile = File(_dbPath!);
    final bool dbExists = dbFile.existsSync();

    if (!dbExists) {
      print("⚠️ Database file does NOT exist. Creating a new one.");
      dbFile.createSync(recursive: true);
    }

    print("🟡 Opening SQLite database...");
    _db = sqlite3.open(_dbPath!);
    print("✅ SQLite database opened successfully.");

    print("🟡 Running migrations...");
    _runMigrations(dbExists);
    print("✅ Migrations applied.");
  }

  static Database getDb() {
    if (_db == null) {
      throw Exception("❌ DatabaseService.init() must be called before getDb()!");
    }
    return _db!;
  }

  static void _runMigrations(bool dbExists) {
    if (!dbExists) {
      print("🟡 Running initial schema...");
      MigrationService.onCreate(_db!);
    } else {
      print("🟡 Running upgrade migrations...");
      MigrationService.onUpgrade(_db!, 1, 1); // Adjust versioning as needed
    }
  }
}
