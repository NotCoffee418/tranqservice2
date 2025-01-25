import 'dart:math';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:tranqservice2/services/path_service.dart';
import 'package:tranqservice2/services/migration_service.dart';
import 'dart:async';

class DatabaseService {
  // We keep a single Future that represents our "open DB" operation
  static Future<Database>? _dbFuture;
  static Database? _db;

  static Future<Database> getDb() {
    // If we've already got a DB instance, return it immediately
    if (_db != null) {
      return Future.value(_db);
    }

    // If we are in the process of opening the DB (i.e. _dbFuture != null),
    // just return that same Future and let callers await it.
    if (_dbFuture != null) {
      return _dbFuture!;
    }

    // Otherwise, create the Future and store it so subsequent calls will
    // wait on the same operation instead of trying to open the DB again
    _dbFuture = _openDb();
    return _dbFuture!;
  }

  // Actual database opening logic
  static Future<Database> _openDb() async {
    // Initialize FFI
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;

    // Get the database path
    final dbPath = await PathService.getWorkingFile('db.sqlite');

    // Compute the app database version
    final appDbVersion = MigrationService.migrations.keys.reduce(max);

    _db = await openDatabase(
      dbPath,
      version: appDbVersion,
      onCreate: MigrationService.onCreate,
      onUpgrade: MigrationService.onUpgrade,
      singleInstance: true,
    );
    return _db!;
  }
}
