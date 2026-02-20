class ModelHasRole {
  final int roleId;
  final String modelType;
  final int modelId;
  final String? createdAt;
  final String? updatedAt;

  ModelHasRole({
    required this.roleId,
    required this.modelType,
    required this.modelId,
    this.createdAt,
    this.updatedAt,
  });

  factory ModelHasRole.fromJson(Map<String, dynamic> json) {
    return ModelHasRole(
      roleId: json['role_id'] != null
          ? (json['role_id'] is int
                ? json['role_id']
                : int.tryParse(json['role_id'].toString()) ?? 0)
          : 0,
      modelType: json['model_type'] ?? '',
      modelId: json['model_id'] != null
          ? (json['model_id'] is int
                ? json['model_id']
                : int.tryParse(json['model_id'].toString()) ?? 0)
          : 0,
      createdAt: json['created_at'] ?? null,
      updatedAt: json['updated_at'] ?? null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'role_id': roleId,
      'model_type': modelType,
      'model_id': modelId,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }
}
