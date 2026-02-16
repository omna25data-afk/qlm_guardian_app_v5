class RecordBook {
  final int id;
  final int? recordBookTypeId;
  final int? recordBookTemplateId;
  final String name;
  final String category;
  final int? contractTypeId;
  final int? legitimateGuardianId;
  final int bookNumber;
  final String? ministryRecordNumber;
  final String? formNumber;
  final int hijriYear;
  final int totalPages;
  final int constraintsPerPage;
  final int startConstraintNumber;
  final int endConstraintNumber;
  final int? assignedTo;
  final int createdBy;
  final String status;
  final int? issuedProcedureId;
  final int? currentOpeningProcedureId;
  final String? openingProcedureDate;
  final String? openingProcedureDateHijri;
  final String? closingProcedureDate;
  final String? closureType;
  final String? closureReason;
  final String? closingProcedureDateHijri;
  final String? notes;
  final bool isActive;
  final String? createdAt;
  final String? updatedAt;
  final String? deletedAt;
  final String? recordGroup;
  final String? recordCategory;

  RecordBook({
    required this.id,
    this.recordBookTypeId,
    this.recordBookTemplateId,
    required this.name,
    required this.category,
    this.contractTypeId,
    this.legitimateGuardianId,
    required this.bookNumber,
    this.ministryRecordNumber,
    this.formNumber,
    required this.hijriYear,
    required this.totalPages,
    required this.constraintsPerPage,
    required this.startConstraintNumber,
    required this.endConstraintNumber,
    this.assignedTo,
    required this.createdBy,
    required this.status,
    this.issuedProcedureId,
    this.currentOpeningProcedureId,
    this.openingProcedureDate,
    this.openingProcedureDateHijri,
    this.closingProcedureDate,
    this.closureType,
    this.closureReason,
    this.closingProcedureDateHijri,
    this.notes,
    required this.isActive,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
    this.recordGroup,
    this.recordCategory,
  });

  factory RecordBook.fromJson(Map<String, dynamic> json) {
    return RecordBook(
      id: json['id'] != null ? (json['id'] is int ? json['id'] : int.tryParse(json['id'].toString()) ?? 0) : 0,
      recordBookTypeId: json['record_book_type_id'] != null ? (json['record_book_type_id'] is int ? json['record_book_type_id'] : int.tryParse(json['record_book_type_id'].toString()) ?? null) : null,
      recordBookTemplateId: json['record_book_template_id'] != null ? (json['record_book_template_id'] is int ? json['record_book_template_id'] : int.tryParse(json['record_book_template_id'].toString()) ?? null) : null,
      name: json['name'] ?? '',
      category: json['category'] ?? '',
      contractTypeId: json['contract_type_id'] != null ? (json['contract_type_id'] is int ? json['contract_type_id'] : int.tryParse(json['contract_type_id'].toString()) ?? null) : null,
      legitimateGuardianId: json['legitimate_guardian_id'] != null ? (json['legitimate_guardian_id'] is int ? json['legitimate_guardian_id'] : int.tryParse(json['legitimate_guardian_id'].toString()) ?? null) : null,
      bookNumber: json['book_number'] != null ? (json['book_number'] is int ? json['book_number'] : int.tryParse(json['book_number'].toString()) ?? 0) : 0,
      ministryRecordNumber: json['ministry_record_number'] ?? null,
      formNumber: json['form_number'] ?? null,
      hijriYear: json['hijri_year'] != null ? (json['hijri_year'] is int ? json['hijri_year'] : int.tryParse(json['hijri_year'].toString()) ?? 0) : 0,
      totalPages: json['total_pages'] != null ? (json['total_pages'] is int ? json['total_pages'] : int.tryParse(json['total_pages'].toString()) ?? 0) : 0,
      constraintsPerPage: json['constraints_per_page'] != null ? (json['constraints_per_page'] is int ? json['constraints_per_page'] : int.tryParse(json['constraints_per_page'].toString()) ?? 0) : 0,
      startConstraintNumber: json['start_constraint_number'] != null ? (json['start_constraint_number'] is int ? json['start_constraint_number'] : int.tryParse(json['start_constraint_number'].toString()) ?? 0) : 0,
      endConstraintNumber: json['end_constraint_number'] != null ? (json['end_constraint_number'] is int ? json['end_constraint_number'] : int.tryParse(json['end_constraint_number'].toString()) ?? 0) : 0,
      assignedTo: json['assigned_to'] != null ? (json['assigned_to'] is int ? json['assigned_to'] : int.tryParse(json['assigned_to'].toString()) ?? null) : null,
      createdBy: json['created_by'] != null ? (json['created_by'] is int ? json['created_by'] : int.tryParse(json['created_by'].toString()) ?? 0) : 0,
      status: json['status'] ?? '',
      issuedProcedureId: json['issued_procedure_id'] != null ? (json['issued_procedure_id'] is int ? json['issued_procedure_id'] : int.tryParse(json['issued_procedure_id'].toString()) ?? null) : null,
      currentOpeningProcedureId: json['current_opening_procedure_id'] != null ? (json['current_opening_procedure_id'] is int ? json['current_opening_procedure_id'] : int.tryParse(json['current_opening_procedure_id'].toString()) ?? null) : null,
      openingProcedureDate: json['opening_procedure_date'] ?? null,
      openingProcedureDateHijri: json['opening_procedure_date_hijri'] ?? null,
      closingProcedureDate: json['closing_procedure_date'] ?? null,
      closureType: json['closure_type'] ?? null,
      closureReason: json['closure_reason'] ?? null,
      closingProcedureDateHijri: json['closing_procedure_date_hijri'] ?? null,
      notes: json['notes'] ?? null,
      isActive: json['is_active'] == 1 || json['is_active'] == true || json['is_active'] == '1',
      createdAt: json['created_at'] ?? null,
      updatedAt: json['updated_at'] ?? null,
      deletedAt: json['deleted_at'] ?? null,
      recordGroup: json['record_group'] ?? null,
      recordCategory: json['record_category'] ?? null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'record_book_type_id': recordBookTypeId,
      'record_book_template_id': recordBookTemplateId,
      'name': name,
      'category': category,
      'contract_type_id': contractTypeId,
      'legitimate_guardian_id': legitimateGuardianId,
      'book_number': bookNumber,
      'ministry_record_number': ministryRecordNumber,
      'form_number': formNumber,
      'hijri_year': hijriYear,
      'total_pages': totalPages,
      'constraints_per_page': constraintsPerPage,
      'start_constraint_number': startConstraintNumber,
      'end_constraint_number': endConstraintNumber,
      'assigned_to': assignedTo,
      'created_by': createdBy,
      'status': status,
      'issued_procedure_id': issuedProcedureId,
      'current_opening_procedure_id': currentOpeningProcedureId,
      'opening_procedure_date': openingProcedureDate,
      'opening_procedure_date_hijri': openingProcedureDateHijri,
      'closing_procedure_date': closingProcedureDate,
      'closure_type': closureType,
      'closure_reason': closureReason,
      'closing_procedure_date_hijri': closingProcedureDateHijri,
      'notes': notes,
      'is_active': isActive,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'deleted_at': deletedAt,
      'record_group': recordGroup,
      'record_category': recordCategory,
    };
  }
}
