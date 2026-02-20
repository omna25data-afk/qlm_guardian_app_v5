class OtherWriter {
  final int id;
  final String name;
  final String? notes;
  final bool isActive;
  final String? createdAt;
  final String? updatedAt;
  final String? deletedAt;

  OtherWriter({
    required this.id,
    required this.name,
    this.notes,
    required this.isActive,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
  });

  factory OtherWriter.fromJson(Map<String, dynamic> json) {
    return OtherWriter(
      id: json['id'] != null
          ? (json['id'] is int
                ? json['id']
                : int.tryParse(json['id'].toString()) ?? 0)
          : 0,
      name: json['name'] ?? '',
      notes: json['notes'] ?? null,
      isActive:
          json['is_active'] == 1 ||
          json['is_active'] == true ||
          json['is_active'] == '1',
      createdAt: json['created_at'] ?? null,
      updatedAt: json['updated_at'] ?? null,
      deletedAt: json['deleted_at'] ?? null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'notes': notes,
      'is_active': isActive,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'deleted_at': deletedAt,
    };
  }
}
