class ArchiveRow {
  final int id;
  final int archiveFileId;
  final int rowIndex;
  final String data;
  final String? fullText;
  final bool isProcessed;
  final String? processedAt;
  final String? createdAt;
  final String? updatedAt;

  ArchiveRow({
    required this.id,
    required this.archiveFileId,
    required this.rowIndex,
    required this.data,
    this.fullText,
    required this.isProcessed,
    this.processedAt,
    this.createdAt,
    this.updatedAt,
  });

  factory ArchiveRow.fromJson(Map<String, dynamic> json) {
    return ArchiveRow(
      id: json['id'] != null
          ? (json['id'] is int
                ? json['id']
                : int.tryParse(json['id'].toString()) ?? 0)
          : 0,
      archiveFileId: json['archive_file_id'] != null
          ? (json['archive_file_id'] is int
                ? json['archive_file_id']
                : int.tryParse(json['archive_file_id'].toString()) ?? 0)
          : 0,
      rowIndex: json['row_index'] != null
          ? (json['row_index'] is int
                ? json['row_index']
                : int.tryParse(json['row_index'].toString()) ?? 0)
          : 0,
      data: json['data'] ?? '',
      fullText: json['full_text'] ?? null,
      isProcessed:
          json['is_processed'] == 1 ||
          json['is_processed'] == true ||
          json['is_processed'] == '1',
      processedAt: json['processed_at'] ?? null,
      createdAt: json['created_at'] ?? null,
      updatedAt: json['updated_at'] ?? null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'archive_file_id': archiveFileId,
      'row_index': rowIndex,
      'data': data,
      'full_text': fullText,
      'is_processed': isProcessed,
      'processed_at': processedAt,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }
}
