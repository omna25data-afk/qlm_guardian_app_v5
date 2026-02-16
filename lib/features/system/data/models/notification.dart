class Notification {
  final String id;
  final String type;
  final String notifiableType;
  final int notifiableId;
  final String data;
  final String? readAt;
  final String? createdAt;
  final String? updatedAt;

  Notification({
    required this.id,
    required this.type,
    required this.notifiableType,
    required this.notifiableId,
    required this.data,
    this.readAt,
    this.createdAt,
    this.updatedAt,
  });

  factory Notification.fromJson(Map<String, dynamic> json) {
    return Notification(
      id: json['id'] ?? '',
      type: json['type'] ?? '',
      notifiableType: json['notifiable_type'] ?? '',
      notifiableId: json['notifiable_id'] != null ? (json['notifiable_id'] is int ? json['notifiable_id'] : int.tryParse(json['notifiable_id'].toString()) ?? 0) : 0,
      data: json['data'] ?? '',
      readAt: json['read_at'] ?? null,
      createdAt: json['created_at'] ?? null,
      updatedAt: json['updated_at'] ?? null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type,
      'notifiable_type': notifiableType,
      'notifiable_id': notifiableId,
      'data': data,
      'read_at': readAt,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }
}
