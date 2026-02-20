class FailedJob {
  final int id;
  final String uuid;
  final String connection;
  final String queue;
  final String payload;
  final String exception;
  final String failedAt;

  FailedJob({
    required this.id,
    required this.uuid,
    required this.connection,
    required this.queue,
    required this.payload,
    required this.exception,
    required this.failedAt,
  });

  factory FailedJob.fromJson(Map<String, dynamic> json) {
    return FailedJob(
      id: json['id'] != null
          ? (json['id'] is int
                ? json['id']
                : int.tryParse(json['id'].toString()) ?? 0)
          : 0,
      uuid: json['uuid'] ?? '',
      connection: json['connection'] ?? '',
      queue: json['queue'] ?? '',
      payload: json['payload'] ?? '',
      exception: json['exception'] ?? '',
      failedAt: json['failed_at'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'uuid': uuid,
      'connection': connection,
      'queue': queue,
      'payload': payload,
      'exception': exception,
      'failed_at': failedAt,
    };
  }
}
