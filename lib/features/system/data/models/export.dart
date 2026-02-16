class Export {
  final int id;
  final String? completedAt;
  final String fileDisk;
  final String? fileName;
  final String exporter;
  final int processedRows;
  final int totalRows;
  final int successfulRows;
  final int userId;
  final String? createdAt;
  final String? updatedAt;

  Export({
    required this.id,
    this.completedAt,
    required this.fileDisk,
    this.fileName,
    required this.exporter,
    required this.processedRows,
    required this.totalRows,
    required this.successfulRows,
    required this.userId,
    this.createdAt,
    this.updatedAt,
  });

  factory Export.fromJson(Map<String, dynamic> json) {
    return Export(
      id: json['id'] != null ? (json['id'] is int ? json['id'] : int.tryParse(json['id'].toString()) ?? 0) : 0,
      completedAt: json['completed_at'] ?? null,
      fileDisk: json['file_disk'] ?? '',
      fileName: json['file_name'] ?? null,
      exporter: json['exporter'] ?? '',
      processedRows: json['processed_rows'] != null ? (json['processed_rows'] is int ? json['processed_rows'] : int.tryParse(json['processed_rows'].toString()) ?? 0) : 0,
      totalRows: json['total_rows'] != null ? (json['total_rows'] is int ? json['total_rows'] : int.tryParse(json['total_rows'].toString()) ?? 0) : 0,
      successfulRows: json['successful_rows'] != null ? (json['successful_rows'] is int ? json['successful_rows'] : int.tryParse(json['successful_rows'].toString()) ?? 0) : 0,
      userId: json['user_id'] != null ? (json['user_id'] is int ? json['user_id'] : int.tryParse(json['user_id'].toString()) ?? 0) : 0,
      createdAt: json['created_at'] ?? null,
      updatedAt: json['updated_at'] ?? null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'completed_at': completedAt,
      'file_disk': fileDisk,
      'file_name': fileName,
      'exporter': exporter,
      'processed_rows': processedRows,
      'total_rows': totalRows,
      'successful_rows': successfulRows,
      'user_id': userId,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }
}
