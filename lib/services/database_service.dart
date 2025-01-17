import 'package:sqflite/sqflite.dart';
import 'package:tranqservice2/services/path_service.dart';
import 'package:tranqservice2/services/migration_service.dart';
import 'dart:async';

class DatabaseService {
  static Database? _db;
  static final Completer<void> _initLock = Completer<void>();

  // Get the database instance
  static Future<Database> getDb() async {
    // Already initialized, return it
    if (_db != null) return _db!;

    // Initialization in progress, wait for it
    // first check does not block, subsequent checks do
    if (!_initLock.isCompleted) await _initLock.future;

    final dbPath = await PathService.getWorkingFile('db.sqlite');

    // Determine the database version (highest migration number)
    final appDbVersion = MigrationService.migrations.keys.reduce((a, b) => a > b ? a : b);

    // Open the database
    _db = await openDatabase(
      dbPath,
      version: appDbVersion,
      onCreate: MigrationService.onCreate,
      onUpgrade: MigrationService.onUpgrade,
    );

    // Mark initialization as complete
    _initLock.complete();

    return _db!;
  }
}
