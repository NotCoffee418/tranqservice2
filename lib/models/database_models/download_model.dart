enum DownloadStatus {
  unused,     // 0 - Processing or unused (shouldn't really be used)
  success,    // 1 - Successful download
  failed,     // 2 - Failed download
  dismissed,  // 3 - Failed and dismissed by the user
}

class Download {
  final int id;
  final int playlistId;
  final String videoId;
  final DownloadStatus status;
  final String formatDownloaded;
  final String? md5;
  final DateTime lastAttempt;
  final String? failMessage;
  final int attemptCount;

  Download({
    required this.id,
    required this.playlistId,
    required this.videoId,
    required this.status,
    required this.formatDownloaded,
    this.md5,
    required this.lastAttempt,
    this.failMessage,
    required this.attemptCount,
  });

  // Convert from database map to Download model
  factory Download.fromMap(Map<String, dynamic> map) {
    return Download(
      id: map['id'] as int,
      playlistId: map['playlist_id'] as int,
      videoId: map['video_id'] as String,
      status: DownloadStatus.values[map['status'] as int],
      formatDownloaded: map['format_downloaded'] as String,
      md5: map['md5'] as String?,
      lastAttempt: DateTime.parse(map['last_attempt'] as String),
      failMessage: map['fail_message'] as String?,
      attemptCount: map['attempt_count'] as int,
    );
  }

  // Convert Download model to a database map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'playlist_id': playlistId,
      'video_id': videoId,
      'status': status.index, // Use the index of the enum for database storage
      'format_downloaded': formatDownloaded,
      'md5': md5,
      'last_attempt': lastAttempt.toIso8601String(),
      'fail_message': failMessage,
      'attempt_count': attemptCount,
    };
  }
}
