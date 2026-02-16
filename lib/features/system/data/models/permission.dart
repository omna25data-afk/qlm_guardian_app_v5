class Permission {
  final int id;
  final String name;
  final String? nameAr;
  final String guardName;
  final String? category;
  final String? createdAt;
  final String? updatedAt;

  Permission({
    required this.id,
    required this.name,
    this.nameAr,
    required this.guardName,
    this.category,
    this.createdAt,
    this.updatedAt,
  });

  factory Permission.fromJson(Map<String, dynamic> json) {
    return Permission(
      id: json['id'] != null ? (json['id'] is int ? json['id'] : int.tryParse(json['id'].toString()) ?? 0) : 0,
      name: json['name'] ?? '',
      nameAr: json['name_ar'] ?? null,
      guardName: json['guard_name'] ?? '',
      category: json['category'] ?? null,
      createdAt: json['created_at'] ?? null,
      updatedAt: json['updated_at'] ?? null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'name_ar': nameAr,
      'guard_name': guardName,
      'category': category,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }
}
