class Job {
  final int id;
  final String queue;
  final String payload;
  final int attempts;
  final int? reservedAt;
  final int availableAt;
  final int createdAt;

  Job({
    required this.id,
    required this.queue,
    required this.payload,
    required this.attempts,
    this.reservedAt,
    required this.availableAt,
    required this.createdAt,
  });

  factory Job.fromJson(Map<String, dynamic> json) {
    return Job(
      id: json['id'] != null ? (json['id'] is int ? json['id'] : int.tryParse(json['id'].toString()) ?? 0) : 0,
      queue: json['queue'] ?? '',
      payload: json['payload'] ?? '',
      attempts: json['attempts'] != null ? (json['attempts'] is int ? json['attempts'] : int.tryParse(json['attempts'].toString()) ?? 0) : 0,
      reservedAt: json['reserved_at'] != null ? (json['reserved_at'] is int ? json['reserved_at'] : int.tryParse(json['reserved_at'].toString()) ?? null) : null,
      availableAt: json['available_at'] != null ? (json['available_at'] is int ? json['available_at'] : int.tryParse(json['available_at'].toString()) ?? 0) : 0,
      createdAt: json['created_at'] != null ? (json['created_at'] is int ? json['created_at'] : int.tryParse(json['created_at'].toString()) ?? 0) : 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'queue': queue,
      'payload': payload,
      'attempts': attempts,
      'reserved_at': reservedAt,
      'available_at': availableAt,
      'created_at': createdAt,
    };
  }
}
