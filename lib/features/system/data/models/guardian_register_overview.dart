class GuardianRegisterOverview {
  final int id;
  final int guardianId;
  final int evaluationPeriodId;
  final String registerType;
  final int totalRecordBooksUsed;
  final int totalDocumentsRegistered;
  final int reviewedRecordBooksCount;
  final int reviewedPagesCount;
  final int reviewedIssuedDocumentsCount;
  final int reviewedRegisteredDocumentsCount;
  final String? firstEntryDate;
  final String? lastEntryDate;
  final String? notes;
  final String? createdAt;
  final String? updatedAt;

  GuardianRegisterOverview({
    required this.id,
    required this.guardianId,
    required this.evaluationPeriodId,
    required this.registerType,
    required this.totalRecordBooksUsed,
    required this.totalDocumentsRegistered,
    required this.reviewedRecordBooksCount,
    required this.reviewedPagesCount,
    required this.reviewedIssuedDocumentsCount,
    required this.reviewedRegisteredDocumentsCount,
    this.firstEntryDate,
    this.lastEntryDate,
    this.notes,
    this.createdAt,
    this.updatedAt,
  });

  factory GuardianRegisterOverview.fromJson(Map<String, dynamic> json) {
    return GuardianRegisterOverview(
      id: json['id'] != null ? (json['id'] is int ? json['id'] : int.tryParse(json['id'].toString()) ?? 0) : 0,
      guardianId: json['guardian_id'] != null ? (json['guardian_id'] is int ? json['guardian_id'] : int.tryParse(json['guardian_id'].toString()) ?? 0) : 0,
      evaluationPeriodId: json['evaluation_period_id'] != null ? (json['evaluation_period_id'] is int ? json['evaluation_period_id'] : int.tryParse(json['evaluation_period_id'].toString()) ?? 0) : 0,
      registerType: json['register_type'] ?? '',
      totalRecordBooksUsed: json['total_record_books_used'] != null ? (json['total_record_books_used'] is int ? json['total_record_books_used'] : int.tryParse(json['total_record_books_used'].toString()) ?? 0) : 0,
      totalDocumentsRegistered: json['total_documents_registered'] != null ? (json['total_documents_registered'] is int ? json['total_documents_registered'] : int.tryParse(json['total_documents_registered'].toString()) ?? 0) : 0,
      reviewedRecordBooksCount: json['reviewed_record_books_count'] != null ? (json['reviewed_record_books_count'] is int ? json['reviewed_record_books_count'] : int.tryParse(json['reviewed_record_books_count'].toString()) ?? 0) : 0,
      reviewedPagesCount: json['reviewed_pages_count'] != null ? (json['reviewed_pages_count'] is int ? json['reviewed_pages_count'] : int.tryParse(json['reviewed_pages_count'].toString()) ?? 0) : 0,
      reviewedIssuedDocumentsCount: json['reviewed_issued_documents_count'] != null ? (json['reviewed_issued_documents_count'] is int ? json['reviewed_issued_documents_count'] : int.tryParse(json['reviewed_issued_documents_count'].toString()) ?? 0) : 0,
      reviewedRegisteredDocumentsCount: json['reviewed_registered_documents_count'] != null ? (json['reviewed_registered_documents_count'] is int ? json['reviewed_registered_documents_count'] : int.tryParse(json['reviewed_registered_documents_count'].toString()) ?? 0) : 0,
      firstEntryDate: json['first_entry_date'] ?? null,
      lastEntryDate: json['last_entry_date'] ?? null,
      notes: json['notes'] ?? null,
      createdAt: json['created_at'] ?? null,
      updatedAt: json['updated_at'] ?? null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'guardian_id': guardianId,
      'evaluation_period_id': evaluationPeriodId,
      'register_type': registerType,
      'total_record_books_used': totalRecordBooksUsed,
      'total_documents_registered': totalDocumentsRegistered,
      'reviewed_record_books_count': reviewedRecordBooksCount,
      'reviewed_pages_count': reviewedPagesCount,
      'reviewed_issued_documents_count': reviewedIssuedDocumentsCount,
      'reviewed_registered_documents_count': reviewedRegisteredDocumentsCount,
      'first_entry_date': firstEntryDate,
      'last_entry_date': lastEntryDate,
      'notes': notes,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }
}
