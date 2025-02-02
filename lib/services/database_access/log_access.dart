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
  // Function to retrieve logs with a minimum verbosity level and an optional limit
  static Future<List<Log>> getLogs({required LogVerbosity minVerbosity, int limit = 100}) async {
    // Get the database instance
    final db = await DatabaseService.getDb();

    // Query logs with verbosity greater than or equal to minVerbosity
    final result = await db.query(
      'logs',
      where: 'verbosity >= ?',
      whereArgs: [minVerbosity.level],
      orderBy: 'timestamp DESC', // Sort by timestamp, newest first
      limit: limit, // Limit the number of logs returned
    );

    // Map the result to a list of Log models
    return result.map((map) => Log.fromMap(map)).toList();
  }

  static Future<void> addLog(LogVerbosity verbosity, String message) async {
    final timestamp = DateTime.now().toIso8601String();
    final logMessage = '[$timestamp][${verbosity.label}] $message';
    
    stdout.writeln(logMessage);

    final db = await DatabaseService.getDb();
    
    await db.insert(
      'logs',
      {
        'verbosity': verbosity.level,
        'timestamp': timestamp,
        'message': message,
      },
    );
  }
}
