class ConstraintType {
  final int id;
  final String name;
  final String code;
  final bool isActive;
  final String? createdAt;
  final String? updatedAt;
  final String? deletedAt;

  ConstraintType({
    required this.id,
    required this.name,
    required this.code,
    required this.isActive,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
  });

  factory ConstraintType.fromJson(Map<String, dynamic> json) {
    return ConstraintType(
      id: json['id'] != null ? (json['id'] is int ? json['id'] : int.tryParse(json['id'].toString()) ?? 0) : 0,
      name: json['name'] ?? '',
      code: json['code'] ?? '',
      isActive: json['is_active'] == 1 || json['is_active'] == true || json['is_active'] == '1',
      createdAt: json['created_at'] ?? null,
      updatedAt: json['updated_at'] ?? null,
      deletedAt: json['deleted_at'] ?? null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'code': code,
      'is_active': isActive,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'deleted_at': deletedAt,
    };
  }
}
