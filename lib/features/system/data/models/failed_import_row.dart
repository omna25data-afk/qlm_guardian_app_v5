class FailedImportRow {
  final int id;
  final String data;
  final int importId;
  final String? validationError;
  final String? createdAt;
  final String? updatedAt;

  FailedImportRow({
    required this.id,
    required this.data,
    required this.importId,
    this.validationError,
    this.createdAt,
    this.updatedAt,
  });

  factory FailedImportRow.fromJson(Map<String, dynamic> json) {
    return FailedImportRow(
      id: json['id'] != null
          ? (json['id'] is int
                ? json['id']
                : int.tryParse(json['id'].toString()) ?? 0)
          : 0,
      data: json['data'] ?? '',
      importId: json['import_id'] != null
          ? (json['import_id'] is int
                ? json['import_id']
                : int.tryParse(json['import_id'].toString()) ?? 0)
          : 0,
      validationError: json['validation_error'] ?? null,
      createdAt: json['created_at'] ?? null,
      updatedAt: json['updated_at'] ?? null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'data': data,
      'import_id': importId,
      'validation_error': validationError,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }
}
