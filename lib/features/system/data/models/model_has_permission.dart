class ModelHasPermission {
  final int permissionId;
  final String modelType;
  final int modelId;
  final String? createdAt;
  final String? updatedAt;

  ModelHasPermission({
    required this.permissionId,
    required this.modelType,
    required this.modelId,
    this.createdAt,
    this.updatedAt,
  });

  factory ModelHasPermission.fromJson(Map<String, dynamic> json) {
    return ModelHasPermission(
      permissionId: json['permission_id'] != null
          ? (json['permission_id'] is int
                ? json['permission_id']
                : int.tryParse(json['permission_id'].toString()) ?? 0)
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
      'permission_id': permissionId,
      'model_type': modelType,
      'model_id': modelId,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }
}
