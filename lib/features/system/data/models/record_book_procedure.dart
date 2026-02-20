class RecordBookProcedure {
  final int id;
  final int recordBookId;
  final String procedureType;
  final int hijriYear;
  final String procedureDate;
  final String? procedureDateHijri;
  final int? startPage;
  final int? endPage;
  final int? startConstraintNumber;
  final int? endConstraintNumber;
  final int performedBy;
  final String? notes;
  final String? createdAt;
  final String? updatedAt;
  final String? deletedAt;

  RecordBookProcedure({
    required this.id,
    required this.recordBookId,
    required this.procedureType,
    required this.hijriYear,
    required this.procedureDate,
    this.procedureDateHijri,
    this.startPage,
    this.endPage,
    this.startConstraintNumber,
    this.endConstraintNumber,
    required this.performedBy,
    this.notes,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
  });

  factory RecordBookProcedure.fromJson(Map<String, dynamic> json) {
    return RecordBookProcedure(
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
      procedureType: json['procedure_type'] ?? '',
      hijriYear: json['hijri_year'] != null
          ? (json['hijri_year'] is int
                ? json['hijri_year']
                : int.tryParse(json['hijri_year'].toString()) ?? 0)
          : 0,
      procedureDate: json['procedure_date'] ?? '',
      procedureDateHijri: json['procedure_date_hijri'] ?? null,
      startPage: json['start_page'] != null
          ? (json['start_page'] is int
                ? json['start_page']
                : int.tryParse(json['start_page'].toString()) ?? null)
          : null,
      endPage: json['end_page'] != null
          ? (json['end_page'] is int
                ? json['end_page']
                : int.tryParse(json['end_page'].toString()) ?? null)
          : null,
      startConstraintNumber: json['start_constraint_number'] != null
          ? (json['start_constraint_number'] is int
                ? json['start_constraint_number']
                : int.tryParse(json['start_constraint_number'].toString()) ??
                      null)
          : null,
      endConstraintNumber: json['end_constraint_number'] != null
          ? (json['end_constraint_number'] is int
                ? json['end_constraint_number']
                : int.tryParse(json['end_constraint_number'].toString()) ??
                      null)
          : null,
      performedBy: json['performed_by'] != null
          ? (json['performed_by'] is int
                ? json['performed_by']
                : int.tryParse(json['performed_by'].toString()) ?? 0)
          : 0,
      notes: json['notes'] ?? null,
      createdAt: json['created_at'] ?? null,
      updatedAt: json['updated_at'] ?? null,
      deletedAt: json['deleted_at'] ?? null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'record_book_id': recordBookId,
      'procedure_type': procedureType,
      'hijri_year': hijriYear,
      'procedure_date': procedureDate,
      'procedure_date_hijri': procedureDateHijri,
      'start_page': startPage,
      'end_page': endPage,
      'start_constraint_number': startConstraintNumber,
      'end_constraint_number': endConstraintNumber,
      'performed_by': performedBy,
      'notes': notes,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'deleted_at': deletedAt,
    };
  }
}
