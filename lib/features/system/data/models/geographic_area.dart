class GeographicArea {
  final int id;
  final String name;
  final String type;
  final int? parentId;
  final int? level;
  final bool isActive;
  final String? description;
  final String? createdAt;
  final String? updatedAt;
  final String? deletedAt;

  GeographicArea({
    required this.id,
    required this.name,
    required this.type,
    this.parentId,
    this.level,
    required this.isActive,
    this.description,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
  });

  factory GeographicArea.fromJson(Map<String, dynamic> json) {
    return GeographicArea(
      id: json['id'] != null ? (json['id'] is int ? json['id'] : int.tryParse(json['id'].toString()) ?? 0) : 0,
      name: json['name'] ?? '',
      type: json['type'] ?? '',
      parentId: json['parent_id'] != null ? (json['parent_id'] is int ? json['parent_id'] : int.tryParse(json['parent_id'].toString()) ?? null) : null,
      level: json['level'] != null ? (json['level'] is int ? json['level'] : int.tryParse(json['level'].toString()) ?? null) : null,
      isActive: json['is_active'] == 1 || json['is_active'] == true || json['is_active'] == '1',
      description: json['description'] ?? null,
      createdAt: json['created_at'] ?? null,
      updatedAt: json['updated_at'] ?? null,
      deletedAt: json['deleted_at'] ?? null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'type': type,
      'parent_id': parentId,
      'level': level,
      'is_active': isActive,
      'description': description,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'deleted_at': deletedAt,
    };
  }
}
