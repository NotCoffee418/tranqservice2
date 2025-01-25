class Log {
  final int id;
  final int verbosity;
  final DateTime timestamp;
  final String message;

  Log({
    required this.id,
    required this.verbosity,
    required this.timestamp,
    required this.message,
  });

  // Convert from database map to Log model
  factory Log.fromMap(Map<String, dynamic> map) {
    return Log(
      id: map['id'] as int,
      verbosity: map['verbosity'] as int,
      timestamp: DateTime.parse(map['timestamp'] as String),
      message: map['message'] as String,
    );
  }

  // Convert Log model to a database map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'verbosity': verbosity,
      'timestamp': timestamp.toIso8601String(),
      'message': message,
    };
  }
}
