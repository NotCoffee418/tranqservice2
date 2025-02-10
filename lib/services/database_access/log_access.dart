import 'package:tranqservice2/models/database_models/log_model.dart';
import 'package:tranqservice2/services/database_service.dart';
import 'dart:io';

enum LogVerbosity {
  debug(0, 'DEBUG'),
  info(1, 'INFO'),
  warning(2, 'WARNING'),
  error(3, 'ERROR');

  final int level;
  final String label;
  const LogVerbosity(this.level, this.label);
}

class LogAccess {
  // Retrieve logs with a minimum verbosity level and an optional limit
  static List<Log> getLogs({required LogVerbosity minVerbosity, int limit = 100}) {
    final db = DatabaseService.getDb();

    final result = db.select(
      'SELECT * FROM logs WHERE verbosity >= ? ORDER BY timestamp DESC LIMIT ?',
      [minVerbosity.level, limit],
    );

    return result.map((row) => Log.fromMap(row)).toList();
  }

  // Add a log entry to the database
  static void addLog(LogVerbosity verbosity, String message) {
    final timestamp = DateTime.now().toIso8601String();
    final logMessage = '[$timestamp][${verbosity.label}] $message';

    stdout.writeln(logMessage);

    final db = DatabaseService.getDb();

    db.execute(
      'INSERT INTO logs (verbosity, timestamp, message) VALUES (?, ?, ?)',
      [verbosity.level, timestamp, message],
    );
  }
}
