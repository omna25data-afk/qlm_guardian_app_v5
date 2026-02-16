class ArchiveFile {
  final int id;
  final String name;
  final String originalName;
  final String? type;
  final String status;
  final String path;
  final int rowsCount;
  final String? errorMessage;
  final int? uploadedBy;
  final String? createdAt;
  final String? updatedAt;
  final String? deletedAt;

  ArchiveFile({
    required this.id,
    required this.name,
    required this.originalName,
    this.type,
    required this.status,
    required this.path,
    required this.rowsCount,
    this.errorMessage,
    this.uploadedBy,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
  });

  factory ArchiveFile.fromJson(Map<String, dynamic> json) {
    return ArchiveFile(
      id: json['id'] != null ? (json['id'] is int ? json['id'] : int.tryParse(json['id'].toString()) ?? 0) : 0,
      name: json['name'] ?? '',
      originalName: json['original_name'] ?? '',
      type: json['type'] ?? null,
      status: json['status'] ?? '',
      path: json['path'] ?? '',
      rowsCount: json['rows_count'] != null ? (json['rows_count'] is int ? json['rows_count'] : int.tryParse(json['rows_count'].toString()) ?? 0) : 0,
      errorMessage: json['error_message'] ?? null,
      uploadedBy: json['uploaded_by'] != null ? (json['uploaded_by'] is int ? json['uploaded_by'] : int.tryParse(json['uploaded_by'].toString()) ?? null) : null,
      createdAt: json['created_at'] ?? null,
      updatedAt: json['updated_at'] ?? null,
      deletedAt: json['deleted_at'] ?? null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'original_name': originalName,
      'type': type,
      'status': status,
      'path': path,
      'rows_count': rowsCount,
      'error_message': errorMessage,
      'uploaded_by': uploadedBy,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'deleted_at': deletedAt,
    };
  }
}
