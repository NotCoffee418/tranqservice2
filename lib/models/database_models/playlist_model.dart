class Playlist {
  final int id;
  final String name;
  final String url;
  final String outputFormat;
  final String saveDirectory;
  final String? thumbnailBase64;
  final bool isEnabled;
  final DateTime addedAt;

  Playlist({
    required this.id,
    required this.name,
    required this.url,
    required this.outputFormat,
    required this.saveDirectory,
    this.thumbnailBase64,
    this.isEnabled = true,
    required this.addedAt,
  });

  // Convert from database map to Playlist model
  factory Playlist.fromMap(Map<String, dynamic> map) {
    return Playlist(
      id: map['id'] as int,
      name: map['name'] as String,
      url: map['url'] as String,
      outputFormat: map['output_format'] as String,
      saveDirectory: map['save_directory'] as String,
      thumbnailBase64: map['thumbnail_base64'] as String?,
      isEnabled: (map['is_enabled'] as int) == 1, // SQLite stores booleans as 0/1
      addedAt: DateTime.parse(map['added_at'] as String),
    );
  }

  // Convert Playlist model to a database map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'url': url,
      'output_format': outputFormat,
      'save_directory': saveDirectory,
      'thumbnail_base64': thumbnailBase64,
      'is_enabled': isEnabled ? 1 : 0,
      'added_at': addedAt.toIso8601String(),
    };
  }
}
