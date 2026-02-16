class RoleHasPermission {
  final int permissionId;
  final int roleId;
  final String? createdAt;
  final String? updatedAt;

  RoleHasPermission({
    required this.permissionId,
    required this.roleId,
    this.createdAt,
    this.updatedAt,
  });

  factory RoleHasPermission.fromJson(Map<String, dynamic> json) {
    return RoleHasPermission(
      permissionId: json['permission_id'] != null ? (json['permission_id'] is int ? json['permission_id'] : int.tryParse(json['permission_id'].toString()) ?? 0) : 0,
      roleId: json['role_id'] != null ? (json['role_id'] is int ? json['role_id'] : int.tryParse(json['role_id'].toString()) ?? 0) : 0,
      createdAt: json['created_at'] ?? null,
      updatedAt: json['updated_at'] ?? null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'permission_id': permissionId,
      'role_id': roleId,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }
}
