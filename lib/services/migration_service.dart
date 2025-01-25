import 'package:sqflite/sqflite.dart';

class MigrationService {
  // Define migrations here without transaction
  // Upgrade to dynamic loading assets from SQL files if it becomes too spammy
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
      PRIMARY KEY("id")
    );

    CREATE TABLE IF NOT EXISTS "downloads" (
      "id" INTEGER NOT NULL UNIQUE,
      -- Playlist that requested the download
      "playlist_id" INTEGER NOT NULL,
      --  Consistent `yt-dlp` video ID (e.g., YouTube video ID)
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
