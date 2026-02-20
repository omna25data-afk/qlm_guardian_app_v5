class Import {
  final int id;
  final String? completedAt;
  final String fileName;
  final String filePath;
  final String importer;
  final int processedRows;
  final int totalRows;
  final int successfulRows;
  final int userId;
  final String? createdAt;
  final String? updatedAt;

  Import({
    required this.id,
    this.completedAt,
    required this.fileName,
    required this.filePath,
    required this.importer,
    required this.processedRows,
    required this.totalRows,
    required this.successfulRows,
    required this.userId,
    this.createdAt,
    this.updatedAt,
  });

  factory Import.fromJson(Map<String, dynamic> json) {
    return Import(
      id: json['id'] != null
          ? (json['id'] is int
                ? json['id']
                : int.tryParse(json['id'].toString()) ?? 0)
          : 0,
      completedAt: json['completed_at'] ?? null,
      fileName: json['file_name'] ?? '',
      filePath: json['file_path'] ?? '',
      importer: json['importer'] ?? '',
      processedRows: json['processed_rows'] != null
          ? (json['processed_rows'] is int
                ? json['processed_rows']
                : int.tryParse(json['processed_rows'].toString()) ?? 0)
          : 0,
      totalRows: json['total_rows'] != null
          ? (json['total_rows'] is int
                ? json['total_rows']
                : int.tryParse(json['total_rows'].toString()) ?? 0)
          : 0,
      successfulRows: json['successful_rows'] != null
          ? (json['successful_rows'] is int
                ? json['successful_rows']
                : int.tryParse(json['successful_rows'].toString()) ?? 0)
          : 0,
      userId: json['user_id'] != null
          ? (json['user_id'] is int
                ? json['user_id']
                : int.tryParse(json['user_id'].toString()) ?? 0)
          : 0,
      createdAt: json['created_at'] ?? null,
      updatedAt: json['updated_at'] ?? null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'completed_at': completedAt,
      'file_name': fileName,
      'file_path': filePath,
      'importer': importer,
      'processed_rows': processedRows,
      'total_rows': totalRows,
      'successful_rows': successfulRows,
      'user_id': userId,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }
}
