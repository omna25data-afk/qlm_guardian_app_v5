class Constraint {
  final int id;
  final int? originalConstraintId;
  final int recordBookId;
  final int? recordBookProcedureId;
  final int? recordBookTypeId;
  final int constraintNumber;
  final String? documentNumber;
  final String documentDate;
  final String? documentationDate;
  final String hijriDate;
  final String? category;
  final int pageNumber;
  final int? boxNumber;
  final int? contractTypeId;
  final int? legitimateGuardianId;
  final String? documentType;
  final String writerType;
  final int? writerId;
  final String? writerName;
  final String? partiesData;
  final String? financialData;
  final String? documentationData;
  final String? guardianData;
  final String documentStatus;
  final String? deliveryData;
  final String? deliveryReceiptDate;
  final String? deliveryReceiptNumber;
  final String? deliveryReceiptImage;
  final String? deliveryNotes;
  final String? notes;
  final String? reviewNotes;
  final String? attachments;
  final int createdBy;
  final bool isActive;
  final String? createdAt;
  final String? updatedAt;
  final String? deletedAt;
  final int? constraintTypeId;
  final String? constraintableType;
  final int? constraintableId;

  Constraint({
    required this.id,
    this.originalConstraintId,
    required this.recordBookId,
    this.recordBookProcedureId,
    this.recordBookTypeId,
    required this.constraintNumber,
    this.documentNumber,
    required this.documentDate,
    this.documentationDate,
    required this.hijriDate,
    this.category,
    required this.pageNumber,
    this.boxNumber,
    this.contractTypeId,
    this.legitimateGuardianId,
    this.documentType,
    required this.writerType,
    this.writerId,
    this.writerName,
    this.partiesData,
    this.financialData,
    this.documentationData,
    this.guardianData,
    required this.documentStatus,
    this.deliveryData,
    this.deliveryReceiptDate,
    this.deliveryReceiptNumber,
    this.deliveryReceiptImage,
    this.deliveryNotes,
    this.notes,
    this.reviewNotes,
    this.attachments,
    required this.createdBy,
    required this.isActive,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
    this.constraintTypeId,
    this.constraintableType,
    this.constraintableId,
  });

  factory Constraint.fromJson(Map<String, dynamic> json) {
    return Constraint(
      id: json['id'] != null ? (json['id'] is int ? json['id'] : int.tryParse(json['id'].toString()) ?? 0) : 0,
      originalConstraintId: json['original_constraint_id'] != null ? (json['original_constraint_id'] is int ? json['original_constraint_id'] : int.tryParse(json['original_constraint_id'].toString()) ?? null) : null,
      recordBookId: json['record_book_id'] != null ? (json['record_book_id'] is int ? json['record_book_id'] : int.tryParse(json['record_book_id'].toString()) ?? 0) : 0,
      recordBookProcedureId: json['record_book_procedure_id'] != null ? (json['record_book_procedure_id'] is int ? json['record_book_procedure_id'] : int.tryParse(json['record_book_procedure_id'].toString()) ?? null) : null,
      recordBookTypeId: json['record_book_type_id'] != null ? (json['record_book_type_id'] is int ? json['record_book_type_id'] : int.tryParse(json['record_book_type_id'].toString()) ?? null) : null,
      constraintNumber: json['constraint_number'] != null ? (json['constraint_number'] is int ? json['constraint_number'] : int.tryParse(json['constraint_number'].toString()) ?? 0) : 0,
      documentNumber: json['document_number'] ?? null,
      documentDate: json['document_date'] ?? '',
      documentationDate: json['documentation_date'] ?? null,
      hijriDate: json['hijri_date'] ?? '',
      category: json['category'] ?? null,
      pageNumber: json['page_number'] != null ? (json['page_number'] is int ? json['page_number'] : int.tryParse(json['page_number'].toString()) ?? 0) : 0,
      boxNumber: json['box_number'] != null ? (json['box_number'] is int ? json['box_number'] : int.tryParse(json['box_number'].toString()) ?? null) : null,
      contractTypeId: json['contract_type_id'] != null ? (json['contract_type_id'] is int ? json['contract_type_id'] : int.tryParse(json['contract_type_id'].toString()) ?? null) : null,
      legitimateGuardianId: json['legitimate_guardian_id'] != null ? (json['legitimate_guardian_id'] is int ? json['legitimate_guardian_id'] : int.tryParse(json['legitimate_guardian_id'].toString()) ?? null) : null,
      documentType: json['document_type'] ?? null,
      writerType: json['writer_type'] ?? '',
      writerId: json['writer_id'] != null ? (json['writer_id'] is int ? json['writer_id'] : int.tryParse(json['writer_id'].toString()) ?? null) : null,
      writerName: json['writer_name'] ?? null,
      partiesData: json['parties_data'] ?? null,
      financialData: json['financial_data'] ?? null,
      documentationData: json['documentation_data'] ?? null,
      guardianData: json['guardian_data'] ?? null,
      documentStatus: json['document_status'] ?? '',
      deliveryData: json['delivery_data'] ?? null,
      deliveryReceiptDate: json['delivery_receipt_date'] ?? null,
      deliveryReceiptNumber: json['delivery_receipt_number'] ?? null,
      deliveryReceiptImage: json['delivery_receipt_image'] ?? null,
      deliveryNotes: json['delivery_notes'] ?? null,
      notes: json['notes'] ?? null,
      reviewNotes: json['review_notes'] ?? null,
      attachments: json['attachments'] ?? null,
      createdBy: json['created_by'] != null ? (json['created_by'] is int ? json['created_by'] : int.tryParse(json['created_by'].toString()) ?? 0) : 0,
      isActive: json['is_active'] == 1 || json['is_active'] == true || json['is_active'] == '1',
      createdAt: json['created_at'] ?? null,
      updatedAt: json['updated_at'] ?? null,
      deletedAt: json['deleted_at'] ?? null,
      constraintTypeId: json['constraint_type_id'] != null ? (json['constraint_type_id'] is int ? json['constraint_type_id'] : int.tryParse(json['constraint_type_id'].toString()) ?? null) : null,
      constraintableType: json['constraintable_type'] ?? null,
      constraintableId: json['constraintable_id'] != null ? (json['constraintable_id'] is int ? json['constraintable_id'] : int.tryParse(json['constraintable_id'].toString()) ?? null) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'original_constraint_id': originalConstraintId,
      'record_book_id': recordBookId,
      'record_book_procedure_id': recordBookProcedureId,
      'record_book_type_id': recordBookTypeId,
      'constraint_number': constraintNumber,
      'document_number': documentNumber,
      'document_date': documentDate,
      'documentation_date': documentationDate,
      'hijri_date': hijriDate,
      'category': category,
      'page_number': pageNumber,
      'box_number': boxNumber,
      'contract_type_id': contractTypeId,
      'legitimate_guardian_id': legitimateGuardianId,
      'document_type': documentType,
      'writer_type': writerType,
      'writer_id': writerId,
      'writer_name': writerName,
      'parties_data': partiesData,
      'financial_data': financialData,
      'documentation_data': documentationData,
      'guardian_data': guardianData,
      'document_status': documentStatus,
      'delivery_data': deliveryData,
      'delivery_receipt_date': deliveryReceiptDate,
      'delivery_receipt_number': deliveryReceiptNumber,
      'delivery_receipt_image': deliveryReceiptImage,
      'delivery_notes': deliveryNotes,
      'notes': notes,
      'review_notes': reviewNotes,
      'attachments': attachments,
      'created_by': createdBy,
      'is_active': isActive,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'deleted_at': deletedAt,
      'constraint_type_id': constraintTypeId,
      'constraintable_type': constraintableType,
      'constraintable_id': constraintableId,
    };
  }
}
