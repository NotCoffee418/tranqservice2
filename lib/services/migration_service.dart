import 'package:sqflite/sqflite.dart';

class MigrationService {
  // Define migrations here without transaction
  // Upgrade to dynamic loading assets from SQL files if it becomes too spammy
  static const Map<int, String> migrations = {
    // 1: '''
    // CREATE TABLE IF NOT EXISTS users (id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT, email TEXT);
    // ''',
  };


  // On create calls onUpgrade with 0 as the old version
  static Future<void> onCreate(Database db, int version) async {
    await onUpgrade(db, 0, version);
  }

  // Apply all new migrations as a transaction
  static Future<void> onUpgrade(Database db, int oldVersion, int newVersion) async {
    await db.transaction((txn) async {
      for (var i = oldVersion + 1; i <= newVersion; i++) {
        if (!migrations.containsKey(i)) {
          throw Exception('Migration $i not found. Migrations should not skip numbers.');
        }
        await txn.execute(migrations[i]!);
      }
    });
  }
}
