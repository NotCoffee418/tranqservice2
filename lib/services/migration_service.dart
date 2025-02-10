import 'package:sqlite3/sqlite3.dart';

class MigrationService {
  // Define migrations here
  static const Map<int, String> migrations = {
    1: '''
    CREATE TABLE IF NOT EXISTS "playlists" (
      "id" INTEGER NOT NULL UNIQUE,
      "name" VARCHAR NOT NULL,
      "url" VARCHAR NOT NULL,
      "output_format" VARCHAR NOT NULL,
      "save_directory" VARCHAR NOT NULL,
      "thumbnail_base64" TEXT DEFAULT NULL,
      "is_enabled" BOOLEAN NOT NULL DEFAULT TRUE,
      "added_at" TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
      PRIMARY KEY("id")
    );

    CREATE TABLE IF NOT EXISTS "downloads" (
      "id" INTEGER NOT NULL UNIQUE,
      "playlist_id" INTEGER NOT NULL,
      "video_id" VARCHAR NOT NULL,
      "status" INTEGER NOT NULL,
      "format_downloaded" VARCHAR NOT NULL,
      "md5" VARCHAR,
      "last_attempt" TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
      "fail_message" VARCHAR,
      "attempt_count" INTEGER NOT NULL,
      PRIMARY KEY("id"),
      FOREIGN KEY ("playlist_id") REFERENCES "playlists"("id")
      ON UPDATE RESTRICT ON DELETE RESTRICT
    );

    CREATE INDEX IF NOT EXISTS "downloads_index_0"
    ON "downloads" ("playlist_id", "video_id", "md5");

    CREATE TABLE IF NOT EXISTS "logs" (
      "id" INTEGER NOT NULL UNIQUE,
      "verbosity" INTEGER NOT NULL,
      "timestamp" TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
      "message" TEXT NOT NULL,
      PRIMARY KEY("id")
    );
    ''',
  };

  // On create runs all migrations
  static void onCreate(Database db) {
    onUpgrade(db, 0, migrations.length);
  }

  // Apply all new migrations
  static void onUpgrade(Database db, int oldVersion, int newVersion) {
    for (var i = oldVersion + 1; i <= newVersion; i++) {
      if (!migrations.containsKey(i)) {
        throw Exception('Migration $i not found. Migrations should not skip numbers.');
      }
      print("🟡 Running Migration $i...");
      db.execute(migrations[i]!);
    }
    print("✅ All migrations applied.");
  }
}
