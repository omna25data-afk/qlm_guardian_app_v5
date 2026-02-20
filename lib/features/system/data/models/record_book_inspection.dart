class RecordBookInspection {
  final int id;
  final int recordBookId;
  final int inspectorUserId;
  final String inspectionDate;
  final String? inspectionNumber;
  final int hijriYear;
  final int quarter;
  final String? quarterStartDate;
  final String? quarterEndDate;
  final String? generalNotes;
  final String status;
  final String? createdAt;
  final String? updatedAt;
  final String? deletedAt;

  RecordBookInspection({
    required this.id,
    required this.recordBookId,
    required this.inspectorUserId,
    required this.inspectionDate,
    this.inspectionNumber,
    required this.hijriYear,
    required this.quarter,
    this.quarterStartDate,
    this.quarterEndDate,
    this.generalNotes,
    required this.status,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
  });

  factory RecordBookInspection.fromJson(Map<String, dynamic> json) {
    return RecordBookInspection(
      id: json['id'] != null
          ? (json['id'] is int
                ? json['id']
                : int.tryParse(json['id'].toString()) ?? 0)
          : 0,
      recordBookId: json['record_book_id'] != null
          ? (json['record_book_id'] is int
                ? json['record_book_id']
                : int.tryParse(json['record_book_id'].toString()) ?? 0)
          : 0,
      inspectorUserId: json['inspector_user_id'] != null
          ? (json['inspector_user_id'] is int
                ? json['inspector_user_id']
                : int.tryParse(json['inspector_user_id'].toString()) ?? 0)
          : 0,
      inspectionDate: json['inspection_date'] ?? '',
      inspectionNumber: json['inspection_number'] ?? null,
      hijriYear: json['hijri_year'] != null
          ? (json['hijri_year'] is int
                ? json['hijri_year']
                : int.tryParse(json['hijri_year'].toString()) ?? 0)
          : 0,
      quarter: json['quarter'] != null
          ? (json['quarter'] is int
                ? json['quarter']
                : int.tryParse(json['quarter'].toString()) ?? 0)
          : 0,
      quarterStartDate: json['quarter_start_date'] ?? null,
      quarterEndDate: json['quarter_end_date'] ?? null,
      generalNotes: json['general_notes'] ?? null,
      status: json['status'] ?? '',
      createdAt: json['created_at'] ?? null,
      updatedAt: json['updated_at'] ?? null,
      deletedAt: json['deleted_at'] ?? null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'record_book_id': recordBookId,
      'inspector_user_id': inspectorUserId,
      'inspection_date': inspectionDate,
      'inspection_number': inspectionNumber,
      'hijri_year': hijriYear,
      'quarter': quarter,
      'quarter_start_date': quarterStartDate,
      'quarter_end_date': quarterEndDate,
      'general_notes': generalNotes,
      'status': status,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'deleted_at': deletedAt,
    };
  }
}
