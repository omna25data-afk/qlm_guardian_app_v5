class Role {
  final int id;
  final String name;
  final String guardName;
  final String? createdAt;
  final String? updatedAt;

  Role({
    required this.id,
    required this.name,
    required this.guardName,
    this.createdAt,
    this.updatedAt,
  });

  factory Role.fromJson(Map<String, dynamic> json) {
    return Role(
      id: json['id'] != null
          ? (json['id'] is int
                ? json['id']
                : int.tryParse(json['id'].toString()) ?? 0)
          : 0,
      name: json['name'] ?? '',
      guardName: json['guard_name'] ?? '',
      createdAt: json['created_at'] ?? null,
      updatedAt: json['updated_at'] ?? null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'guard_name': guardName,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }
}
