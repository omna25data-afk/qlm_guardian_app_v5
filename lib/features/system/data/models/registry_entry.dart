class RegistryEntry {
  final int id;
  final int serialNumber;
  final int hijriYear;
  final int? constraintTypeId;
  final int? contractTypeId;
  final String firstPartyName;
  final String secondPartyName;
  final String writerType;
  final int? writerId;
  final int? otherWriterId;
  final String writerName;
  final String? documentHijriDate;
  final String? documentGregorianDate;
  final int? docRecordBookId;
  final int? docRecordBookNumber;
  final int? docPageNumber;
  final int? docEntryNumber;
  final int? docBoxNumber;
  final int? docDocumentNumber;
  final String? docHijriDate;
  final String? docGregorianDate;
  final double feeAmount;
  final double supportAmount;
  final String? receiptNumber;
  final double sustainabilityAmount;
  final int? guardianId;
  final int? guardianRecordBookId;
  final int? guardianRecordBookNumber;
  final int? guardianPageNumber;
  final int? guardianEntryNumber;
  final String? guardianHijriDate;
  final String? constraintableType;
  final int? constraintableId;
  final String status;
  final String deliveryStatus;
  final String? notes;
  final int createdBy;
  final String? createdAt;
  final String? updatedAt;
  final String? deletedAt;

  RegistryEntry({
    required this.id,
    required this.serialNumber,
    required this.hijriYear,
    this.constraintTypeId,
    this.contractTypeId,
    required this.firstPartyName,
    required this.secondPartyName,
    required this.writerType,
    this.writerId,
    this.otherWriterId,
    required this.writerName,
    this.documentHijriDate,
    this.documentGregorianDate,
    this.docRecordBookId,
    this.docRecordBookNumber,
    this.docPageNumber,
    this.docEntryNumber,
    this.docBoxNumber,
    this.docDocumentNumber,
    this.docHijriDate,
    this.docGregorianDate,
    required this.feeAmount,
    required this.supportAmount,
    this.receiptNumber,
    required this.sustainabilityAmount,
    this.guardianId,
    this.guardianRecordBookId,
    this.guardianRecordBookNumber,
    this.guardianPageNumber,
    this.guardianEntryNumber,
    this.guardianHijriDate,
    this.constraintableType,
    this.constraintableId,
    required this.status,
    required this.deliveryStatus,
    this.notes,
    required this.createdBy,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
  });

  factory RegistryEntry.fromJson(Map<String, dynamic> json) {
    return RegistryEntry(
      id: json['id'] != null ? (json['id'] is int ? json['id'] : int.tryParse(json['id'].toString()) ?? 0) : 0,
      serialNumber: json['serial_number'] != null ? (json['serial_number'] is int ? json['serial_number'] : int.tryParse(json['serial_number'].toString()) ?? 0) : 0,
      hijriYear: json['hijri_year'] != null ? (json['hijri_year'] is int ? json['hijri_year'] : int.tryParse(json['hijri_year'].toString()) ?? 0) : 0,
      constraintTypeId: json['constraint_type_id'] != null ? (json['constraint_type_id'] is int ? json['constraint_type_id'] : int.tryParse(json['constraint_type_id'].toString()) ?? null) : null,
      contractTypeId: json['contract_type_id'] != null ? (json['contract_type_id'] is int ? json['contract_type_id'] : int.tryParse(json['contract_type_id'].toString()) ?? null) : null,
      firstPartyName: json['first_party_name'] ?? '',
      secondPartyName: json['second_party_name'] ?? '',
      writerType: json['writer_type'] ?? '',
      writerId: json['writer_id'] != null ? (json['writer_id'] is int ? json['writer_id'] : int.tryParse(json['writer_id'].toString()) ?? null) : null,
      otherWriterId: json['other_writer_id'] != null ? (json['other_writer_id'] is int ? json['other_writer_id'] : int.tryParse(json['other_writer_id'].toString()) ?? null) : null,
      writerName: json['writer_name'] ?? '',
      documentHijriDate: json['document_hijri_date'] ?? null,
      documentGregorianDate: json['document_gregorian_date'] ?? null,
      docRecordBookId: json['doc_record_book_id'] != null ? (json['doc_record_book_id'] is int ? json['doc_record_book_id'] : int.tryParse(json['doc_record_book_id'].toString()) ?? null) : null,
      docRecordBookNumber: json['doc_record_book_number'] != null ? (json['doc_record_book_number'] is int ? json['doc_record_book_number'] : int.tryParse(json['doc_record_book_number'].toString()) ?? null) : null,
      docPageNumber: json['doc_page_number'] != null ? (json['doc_page_number'] is int ? json['doc_page_number'] : int.tryParse(json['doc_page_number'].toString()) ?? null) : null,
      docEntryNumber: json['doc_entry_number'] != null ? (json['doc_entry_number'] is int ? json['doc_entry_number'] : int.tryParse(json['doc_entry_number'].toString()) ?? null) : null,
      docBoxNumber: json['doc_box_number'] != null ? (json['doc_box_number'] is int ? json['doc_box_number'] : int.tryParse(json['doc_box_number'].toString()) ?? null) : null,
      docDocumentNumber: json['doc_document_number'] != null ? (json['doc_document_number'] is int ? json['doc_document_number'] : int.tryParse(json['doc_document_number'].toString()) ?? null) : null,
      docHijriDate: json['doc_hijri_date'] ?? null,
      docGregorianDate: json['doc_gregorian_date'] ?? null,
      feeAmount: json['fee_amount'] != null ? (json['fee_amount'] is num ? json['fee_amount'].toDouble() : double.tryParse(json['fee_amount'].toString()) ?? 0.0) : 0.0,
      supportAmount: json['support_amount'] != null ? (json['support_amount'] is num ? json['support_amount'].toDouble() : double.tryParse(json['support_amount'].toString()) ?? 0.0) : 0.0,
      receiptNumber: json['receipt_number'] ?? null,
      sustainabilityAmount: json['sustainability_amount'] != null ? (json['sustainability_amount'] is num ? json['sustainability_amount'].toDouble() : double.tryParse(json['sustainability_amount'].toString()) ?? 0.0) : 0.0,
      guardianId: json['guardian_id'] != null ? (json['guardian_id'] is int ? json['guardian_id'] : int.tryParse(json['guardian_id'].toString()) ?? null) : null,
      guardianRecordBookId: json['guardian_record_book_id'] != null ? (json['guardian_record_book_id'] is int ? json['guardian_record_book_id'] : int.tryParse(json['guardian_record_book_id'].toString()) ?? null) : null,
      guardianRecordBookNumber: json['guardian_record_book_number'] != null ? (json['guardian_record_book_number'] is int ? json['guardian_record_book_number'] : int.tryParse(json['guardian_record_book_number'].toString()) ?? null) : null,
      guardianPageNumber: json['guardian_page_number'] != null ? (json['guardian_page_number'] is int ? json['guardian_page_number'] : int.tryParse(json['guardian_page_number'].toString()) ?? null) : null,
      guardianEntryNumber: json['guardian_entry_number'] != null ? (json['guardian_entry_number'] is int ? json['guardian_entry_number'] : int.tryParse(json['guardian_entry_number'].toString()) ?? null) : null,
      guardianHijriDate: json['guardian_hijri_date'] ?? null,
      constraintableType: json['constraintable_type'] ?? null,
      constraintableId: json['constraintable_id'] != null ? (json['constraintable_id'] is int ? json['constraintable_id'] : int.tryParse(json['constraintable_id'].toString()) ?? null) : null,
      status: json['status'] ?? '',
      deliveryStatus: json['delivery_status'] ?? '',
      notes: json['notes'] ?? null,
      createdBy: json['created_by'] != null ? (json['created_by'] is int ? json['created_by'] : int.tryParse(json['created_by'].toString()) ?? 0) : 0,
      createdAt: json['created_at'] ?? null,
      updatedAt: json['updated_at'] ?? null,
      deletedAt: json['deleted_at'] ?? null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'serial_number': serialNumber,
      'hijri_year': hijriYear,
      'constraint_type_id': constraintTypeId,
      'contract_type_id': contractTypeId,
      'first_party_name': firstPartyName,
      'second_party_name': secondPartyName,
      'writer_type': writerType,
      'writer_id': writerId,
      'other_writer_id': otherWriterId,
      'writer_name': writerName,
      'document_hijri_date': documentHijriDate,
      'document_gregorian_date': documentGregorianDate,
      'doc_record_book_id': docRecordBookId,
      'doc_record_book_number': docRecordBookNumber,
      'doc_page_number': docPageNumber,
      'doc_entry_number': docEntryNumber,
      'doc_box_number': docBoxNumber,
      'doc_document_number': docDocumentNumber,
      'doc_hijri_date': docHijriDate,
      'doc_gregorian_date': docGregorianDate,
      'fee_amount': feeAmount,
      'support_amount': supportAmount,
      'receipt_number': receiptNumber,
      'sustainability_amount': sustainabilityAmount,
      'guardian_id': guardianId,
      'guardian_record_book_id': guardianRecordBookId,
      'guardian_record_book_number': guardianRecordBookNumber,
      'guardian_page_number': guardianPageNumber,
      'guardian_entry_number': guardianEntryNumber,
      'guardian_hijri_date': guardianHijriDate,
      'constraintable_type': constraintableType,
      'constraintable_id': constraintableId,
      'status': status,
      'delivery_status': deliveryStatus,
      'notes': notes,
      'created_by': createdBy,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'deleted_at': deletedAt,
    };
  }
}
