class NotificationModel {
  final String id;
  final String title;
  final String body;
  final String type; // info, warning, success, error
  final bool isRead;
  final DateTime createdAt;
  final Map<String, dynamic>? data;

  const NotificationModel({
    required this.id,
    required this.title,
    required this.body,
    required this.type,
    required this.isRead,
    required this.createdAt,
    this.data,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      id: json['id']?.toString() ?? '',
      title: json['title'] ?? '',
      body: json['body'] ?? '',
      type: json['type'] ?? 'info',
      isRead: json['read_at'] != null,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : DateTime.now(),
      data: json['data'] as Map<String, dynamic>?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'body': body,
      'type': type,
      'read_at': isRead ? DateTime.now().toIso8601String() : null,
      'created_at': createdAt.toIso8601String(),
      'data': data,
    };
  }
}
