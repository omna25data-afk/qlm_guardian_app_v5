class Session {
  final String id;
  final int? userId;
  final String? ipAddress;
  final String? userAgent;
  final String payload;
  final int lastActivity;

  Session({
    required this.id,
    this.userId,
    this.ipAddress,
    this.userAgent,
    required this.payload,
    required this.lastActivity,
  });

  factory Session.fromJson(Map<String, dynamic> json) {
    return Session(
      id: json['id'] ?? '',
      userId: json['user_id'] != null
          ? (json['user_id'] is int
                ? json['user_id']
                : int.tryParse(json['user_id'].toString()) ?? null)
          : null,
      ipAddress: json['ip_address'] ?? null,
      userAgent: json['user_agent'] ?? null,
      payload: json['payload'] ?? '',
      lastActivity: json['last_activity'] != null
          ? (json['last_activity'] is int
                ? json['last_activity']
                : int.tryParse(json['last_activity'].toString()) ?? 0)
          : 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'ip_address': ipAddress,
      'user_agent': userAgent,
      'payload': payload,
      'last_activity': lastActivity,
    };
  }
}
