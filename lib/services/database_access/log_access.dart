import 'package:tranqservice2/models/database_models/log_model.dart';
import 'package:tranqservice2/services/database_service.dart';

class LogRepository {
 // Function to retrieve logs with a minimum verbosity level and an optional limit
  Future<List<Log>> getLogs({required int minVerbosity, int limit = 100}) async {
    // Get the database instance
    final db = await DatabaseService.getDb();

    // Query logs with verbosity greater than or equal to minVerbosity
    final result = await db.query(
      'logs',
      where: 'verbosity >= ?',
      whereArgs: [minVerbosity],
      orderBy: 'timestamp DESC', // Sort by timestamp, newest first
      limit: limit, // Limit the number of logs returned
    );

    // Map the result to a list of Log models
    return result.map((map) => Log.fromMap(map)).toList();
  }
}
