class MarriageImportStaging {
  final int id;
  final String? serialNumber;
  final String? husbandName;
  final String? wifeName;
  final String? guardianName;
  final String? writerName;
  final String? guardianRecordBookNumber;
  final String? guardianPageNumber;
  final String? guardianEntryNumber;
  final String? docRecordBookNumber;
  final String? docPageNumber;
  final String? docEntryNumber;
  final String? docBoxNumber;
  final String? docDocumentNumber;
  final String? docHijriDate;
  final String? documentHijriDate;
  final String? receiptNumber;
  final String? feeAmount;
  final String? sustainabilityAmount;
  final String? supportAmount;
  final String? groomNationalId;
  final String? brideNationalId;
  final String? groomAge;
  final String? brideAge;
  final String? dowryPaid;
  final String? dowryDeferred;
  final String status;
  final String? errorMessage;
  final int? registryEntryId;
  final String? createdAt;
  final String? updatedAt;

  MarriageImportStaging({
    required this.id,
    this.serialNumber,
    this.husbandName,
    this.wifeName,
    this.guardianName,
    this.writerName,
    this.guardianRecordBookNumber,
    this.guardianPageNumber,
    this.guardianEntryNumber,
    this.docRecordBookNumber,
    this.docPageNumber,
    this.docEntryNumber,
    this.docBoxNumber,
    this.docDocumentNumber,
    this.docHijriDate,
    this.documentHijriDate,
    this.receiptNumber,
    this.feeAmount,
    this.sustainabilityAmount,
    this.supportAmount,
    this.groomNationalId,
    this.brideNationalId,
    this.groomAge,
    this.brideAge,
    this.dowryPaid,
    this.dowryDeferred,
    required this.status,
    this.errorMessage,
    this.registryEntryId,
    this.createdAt,
    this.updatedAt,
  });

  factory MarriageImportStaging.fromJson(Map<String, dynamic> json) {
    return MarriageImportStaging(
      id: json['id'] != null
          ? (json['id'] is int
                ? json['id']
                : int.tryParse(json['id'].toString()) ?? 0)
          : 0,
      serialNumber: json['serial_number'] ?? null,
      husbandName: json['husband_name'] ?? null,
      wifeName: json['wife_name'] ?? null,
      guardianName: json['guardian_name'] ?? null,
      writerName: json['writer_name'] ?? null,
      guardianRecordBookNumber: json['guardian_record_book_number'] ?? null,
      guardianPageNumber: json['guardian_page_number'] ?? null,
      guardianEntryNumber: json['guardian_entry_number'] ?? null,
      docRecordBookNumber: json['doc_record_book_number'] ?? null,
      docPageNumber: json['doc_page_number'] ?? null,
      docEntryNumber: json['doc_entry_number'] ?? null,
      docBoxNumber: json['doc_box_number'] ?? null,
      docDocumentNumber: json['doc_document_number'] ?? null,
      docHijriDate: json['doc_hijri_date'] ?? null,
      documentHijriDate: json['document_hijri_date'] ?? null,
      receiptNumber: json['receipt_number'] ?? null,
      feeAmount: json['fee_amount'] ?? null,
      sustainabilityAmount: json['sustainability_amount'] ?? null,
      supportAmount: json['support_amount'] ?? null,
      groomNationalId: json['groom_national_id'] ?? null,
      brideNationalId: json['bride_national_id'] ?? null,
      groomAge: json['groom_age'] ?? null,
      brideAge: json['bride_age'] ?? null,
      dowryPaid: json['dowry_paid'] ?? null,
      dowryDeferred: json['dowry_deferred'] ?? null,
      status: json['status'] ?? '',
      errorMessage: json['error_message'] ?? null,
      registryEntryId: json['registry_entry_id'] != null
          ? (json['registry_entry_id'] is int
                ? json['registry_entry_id']
                : int.tryParse(json['registry_entry_id'].toString()) ?? null)
          : null,
      createdAt: json['created_at'] ?? null,
      updatedAt: json['updated_at'] ?? null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'serial_number': serialNumber,
      'husband_name': husbandName,
      'wife_name': wifeName,
      'guardian_name': guardianName,
      'writer_name': writerName,
      'guardian_record_book_number': guardianRecordBookNumber,
      'guardian_page_number': guardianPageNumber,
      'guardian_entry_number': guardianEntryNumber,
      'doc_record_book_number': docRecordBookNumber,
      'doc_page_number': docPageNumber,
      'doc_entry_number': docEntryNumber,
      'doc_box_number': docBoxNumber,
      'doc_document_number': docDocumentNumber,
      'doc_hijri_date': docHijriDate,
      'document_hijri_date': documentHijriDate,
      'receipt_number': receiptNumber,
      'fee_amount': feeAmount,
      'sustainability_amount': sustainabilityAmount,
      'support_amount': supportAmount,
      'groom_national_id': groomNationalId,
      'bride_national_id': brideNationalId,
      'groom_age': groomAge,
      'bride_age': brideAge,
      'dowry_paid': dowryPaid,
      'dowry_deferred': dowryDeferred,
      'status': status,
      'error_message': errorMessage,
      'registry_entry_id': registryEntryId,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }
}
