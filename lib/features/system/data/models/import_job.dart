class ImportJob {
  final int id;
  final String uuid;
  final String type;
  final String status;
  final String title;
  final String? description;
  final String filePath;
  final String originalFilename;
  final String mimeType;
  final int fileSize;
  final int totalRows;
  final int processedRows;
  final int successfulRows;
  final int failedRows;
  final int skippedRows;
  final String? headers;
  final String? columnMapping;
  final String? validationRules;
  final String? options;
  final String? errorMessage;
  final String? errorDetails;
  final String? statistics;
  final String? startedAt;
  final String? completedAt;
  final String? failedAt;
  final String? cancelledAt;
  final double progressPercentage;
  final int? estimatedTimeRemaining;
  final String? batchId;
  final int userId;
  final int? cancelledById;
  final String? createdAt;
  final String? updatedAt;

  ImportJob({
    required this.id,
    required this.uuid,
    required this.type,
    required this.status,
    required this.title,
    this.description,
    required this.filePath,
    required this.originalFilename,
    required this.mimeType,
    required this.fileSize,
    required this.totalRows,
    required this.processedRows,
    required this.successfulRows,
    required this.failedRows,
    required this.skippedRows,
    this.headers,
    this.columnMapping,
    this.validationRules,
    this.options,
    this.errorMessage,
    this.errorDetails,
    this.statistics,
    this.startedAt,
    this.completedAt,
    this.failedAt,
    this.cancelledAt,
    required this.progressPercentage,
    this.estimatedTimeRemaining,
    this.batchId,
    required this.userId,
    this.cancelledById,
    this.createdAt,
    this.updatedAt,
  });

  factory ImportJob.fromJson(Map<String, dynamic> json) {
    return ImportJob(
      id: json['id'] != null ? (json['id'] is int ? json['id'] : int.tryParse(json['id'].toString()) ?? 0) : 0,
      uuid: json['uuid'] ?? '',
      type: json['type'] ?? '',
      status: json['status'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? null,
      filePath: json['file_path'] ?? '',
      originalFilename: json['original_filename'] ?? '',
      mimeType: json['mime_type'] ?? '',
      fileSize: json['file_size'] != null ? (json['file_size'] is int ? json['file_size'] : int.tryParse(json['file_size'].toString()) ?? 0) : 0,
      totalRows: json['total_rows'] != null ? (json['total_rows'] is int ? json['total_rows'] : int.tryParse(json['total_rows'].toString()) ?? 0) : 0,
      processedRows: json['processed_rows'] != null ? (json['processed_rows'] is int ? json['processed_rows'] : int.tryParse(json['processed_rows'].toString()) ?? 0) : 0,
      successfulRows: json['successful_rows'] != null ? (json['successful_rows'] is int ? json['successful_rows'] : int.tryParse(json['successful_rows'].toString()) ?? 0) : 0,
      failedRows: json['failed_rows'] != null ? (json['failed_rows'] is int ? json['failed_rows'] : int.tryParse(json['failed_rows'].toString()) ?? 0) : 0,
      skippedRows: json['skipped_rows'] != null ? (json['skipped_rows'] is int ? json['skipped_rows'] : int.tryParse(json['skipped_rows'].toString()) ?? 0) : 0,
      headers: json['headers'] ?? null,
      columnMapping: json['column_mapping'] ?? null,
      validationRules: json['validation_rules'] ?? null,
      options: json['options'] ?? null,
      errorMessage: json['error_message'] ?? null,
      errorDetails: json['error_details'] ?? null,
      statistics: json['statistics'] ?? null,
      startedAt: json['started_at'] ?? null,
      completedAt: json['completed_at'] ?? null,
      failedAt: json['failed_at'] ?? null,
      cancelledAt: json['cancelled_at'] ?? null,
      progressPercentage: json['progress_percentage'] != null ? (json['progress_percentage'] is num ? json['progress_percentage'].toDouble() : double.tryParse(json['progress_percentage'].toString()) ?? 0.0) : 0.0,
      estimatedTimeRemaining: json['estimated_time_remaining'] != null ? (json['estimated_time_remaining'] is int ? json['estimated_time_remaining'] : int.tryParse(json['estimated_time_remaining'].toString()) ?? null) : null,
      batchId: json['batch_id'] ?? null,
      userId: json['user_id'] != null ? (json['user_id'] is int ? json['user_id'] : int.tryParse(json['user_id'].toString()) ?? 0) : 0,
      cancelledById: json['cancelled_by_id'] != null ? (json['cancelled_by_id'] is int ? json['cancelled_by_id'] : int.tryParse(json['cancelled_by_id'].toString()) ?? null) : null,
      createdAt: json['created_at'] ?? null,
      updatedAt: json['updated_at'] ?? null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'uuid': uuid,
      'type': type,
      'status': status,
      'title': title,
      'description': description,
      'file_path': filePath,
      'original_filename': originalFilename,
      'mime_type': mimeType,
      'file_size': fileSize,
      'total_rows': totalRows,
      'processed_rows': processedRows,
      'successful_rows': successfulRows,
      'failed_rows': failedRows,
      'skipped_rows': skippedRows,
      'headers': headers,
      'column_mapping': columnMapping,
      'validation_rules': validationRules,
      'options': options,
      'error_message': errorMessage,
      'error_details': errorDetails,
      'statistics': statistics,
      'started_at': startedAt,
      'completed_at': completedAt,
      'failed_at': failedAt,
      'cancelled_at': cancelledAt,
      'progress_percentage': progressPercentage,
      'estimated_time_remaining': estimatedTimeRemaining,
      'batch_id': batchId,
      'user_id': userId,
      'cancelled_by_id': cancelledById,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }
}
