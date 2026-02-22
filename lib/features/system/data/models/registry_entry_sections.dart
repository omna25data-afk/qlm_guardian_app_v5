import 'package:equatable/equatable.dart';
import 'contract_type.dart';

class RegistryEntrySections extends Equatable {
  final int id;
  final String? uuid;
  final int? remoteId;
  final RegistryBasicInfo basicInfo;
  final RegistryWriterInfo writerInfo;
  final RegistryDocumentInfo documentInfo;
  final RegistryFinancialInfo financialInfo;
  final RegistryGuardianInfo guardianInfo;
  final RegistryStatusInfo statusInfo;
  final RegistryMetadata metadata;
  final Map<String, dynamic>? formData;

  const RegistryEntrySections({
    required this.id,
    this.uuid,
    this.remoteId,
    required this.basicInfo,
    required this.writerInfo,
    required this.documentInfo,
    required this.financialInfo,
    required this.guardianInfo,
    required this.statusInfo,
    required this.metadata,
    this.formData,
  });

  factory RegistryEntrySections.fromJson(Map<String, dynamic> json) {
    return RegistryEntrySections(
      id: json['id'] is int
          ? json['id']
          : int.tryParse(json['id']?.toString() ?? '0') ?? 0,
      uuid: json['uuid'],
      remoteId: json['remote_id'],
      basicInfo: RegistryBasicInfo.fromJson(json),
      writerInfo: RegistryWriterInfo.fromJson(json),
      documentInfo: RegistryDocumentInfo.fromJson(json),
      financialInfo: RegistryFinancialInfo.fromJson(json),
      guardianInfo: RegistryGuardianInfo.fromJson(json),
      statusInfo: RegistryStatusInfo.fromJson(json),
      metadata: RegistryMetadata.fromJson(json),
      formData:
          (json['contract_details'] as Map<String, dynamic>?) ??
          (json['form_data'] as Map<String, dynamic>?),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'uuid': uuid,
      'remote_id': remoteId,
      ...basicInfo.toJson(),
      ...writerInfo.toJson(),
      ...documentInfo.toJson(),
      ...financialInfo.toJson(),
      ...guardianInfo.toJson(),
      ...statusInfo.toJson(),
      ...metadata.toJson(),
      if (formData != null) 'form_data': formData,
    };
  }

  @override
  List<Object?> get props => [
    id,
    uuid,
    remoteId,
    basicInfo,
    writerInfo,
    documentInfo,
    financialInfo,
    guardianInfo,
    statusInfo,
    metadata,
    formData,
  ];
}

/// 1. Basic Information (Contract constraints)
class RegistryBasicInfo extends Equatable {
  final int serialNumber;
  final int hijriYear;
  final int? constraintTypeId;
  final int? contractTypeId;
  final String firstPartyName;
  final String secondPartyName;
  final String? subject;
  final String? content;
  final int? subtype1;
  final int? subtype2;
  final String? registerNumber;
  final ContractType? contractType; // Added relation

  const RegistryBasicInfo({
    required this.serialNumber,
    required this.hijriYear,
    this.constraintTypeId,
    this.contractTypeId,
    required this.firstPartyName,
    required this.secondPartyName,
    this.subject,
    this.content,
    this.subtype1,
    this.subtype2,
    this.registerNumber,
    this.contractType,
  });

  factory RegistryBasicInfo.fromJson(Map<String, dynamic> json) {
    return RegistryBasicInfo(
      serialNumber: json['serial_number'] is int
          ? json['serial_number']
          : int.tryParse(json['serial_number']?.toString() ?? '0') ?? 0,
      hijriYear: json['hijri_year'] is int
          ? json['hijri_year']
          : int.tryParse(json['hijri_year']?.toString() ?? '0') ?? 0,
      constraintTypeId: json['constraint_type_id'],
      contractTypeId: json['contract_type_id'],
      firstPartyName: json['first_party_name'] ?? '',
      secondPartyName: json['second_party_name'] ?? '',
      subject: json['subject'],
      content: json['content'],
      subtype1: json['subtype_1'],
      subtype2: json['subtype_2'],
      registerNumber: json['register_number'],
      contractType: json['contract_type'] != null
          ? ContractType.fromJson(json['contract_type'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'serial_number': serialNumber,
      'hijri_year': hijriYear,
      'constraint_type_id': constraintTypeId,
      'contract_type_id': contractTypeId,
      'first_party_name': firstPartyName,
      'second_party_name': secondPartyName,
      'subject': subject,
      'content': content,
      'subtype_1': subtype1,
      'subtype_2': subtype2,
      'register_number': registerNumber,
      if (contractType != null) 'contract_type': contractType!.toJson(),
    };
  }

  @override
  List<Object?> get props => [
    serialNumber,
    hijriYear,
    constraintTypeId,
    contractTypeId,
    firstPartyName,
    secondPartyName,
    subject,
    content,
    subtype1,
    subtype2,
    registerNumber,
    contractType,
  ];
}

/// 2. Writer Information
class RegistryWriterInfo extends Equatable {
  final String? writerType;
  final int? writerId;
  final int? otherWriterId;
  final String? writerName;

  const RegistryWriterInfo({
    this.writerType,
    this.writerId,
    this.otherWriterId,
    this.writerName,
  });

  factory RegistryWriterInfo.fromJson(Map<String, dynamic> json) {
    return RegistryWriterInfo(
      writerType: json['writer_type'],
      writerId: json['writer_id'],
      otherWriterId: json['other_writer_id'],
      writerName: json['writer_name'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'writer_type': writerType,
      'writer_id': writerId,
      'other_writer_id': otherWriterId,
      'writer_name': writerName,
    };
  }

  @override
  List<Object?> get props => [writerType, writerId, otherWriterId, writerName];
}

/// 3. Document Information (Court/Archive)
class RegistryDocumentInfo extends Equatable {
  final String? docHijriDate; // e.g., 1445-01-01
  final String? docGregorianDate; // e.g., 2023-01-01
  final int? docRecordBookId;
  final int? docRecordBookNumber;
  final int? docPageNumber;
  final int? docEntryNumber;
  final int? docBoxNumber;
  final int? docDocumentNumber;
  // Aliases for compatibility with some views using 'document_..._date'
  final String? documentHijriDate;
  final String? documentGregorianDate;

  const RegistryDocumentInfo({
    this.docHijriDate,
    this.docGregorianDate,
    this.docRecordBookId,
    this.docRecordBookNumber,
    this.docPageNumber,
    this.docEntryNumber,
    this.docBoxNumber,
    this.docDocumentNumber,
    this.documentHijriDate,
    this.documentGregorianDate,
  });

  factory RegistryDocumentInfo.fromJson(Map<String, dynamic> json) {
    final hDate = json['doc_hijri_date'] ?? json['document_hijri_date'];
    final gDate = json['doc_gregorian_date'] ?? json['document_gregorian_date'];

    return RegistryDocumentInfo(
      docHijriDate: hDate,
      docGregorianDate: gDate,
      documentHijriDate: hDate,
      documentGregorianDate: gDate,
      docRecordBookId: json['doc_record_book_id'],
      docRecordBookNumber: json['doc_record_book_number'],
      docPageNumber: json['doc_page_number'],
      docEntryNumber: json['doc_entry_number'],
      docBoxNumber: json['doc_box_number'],
      docDocumentNumber: json['doc_document_number'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'doc_hijri_date': docHijriDate,
      'doc_gregorian_date': docGregorianDate,
      'doc_record_book_id': docRecordBookId,
      'doc_record_book_number': docRecordBookNumber,
      'doc_page_number': docPageNumber,
      'doc_entry_number': docEntryNumber,
      'doc_box_number': docBoxNumber,
      'doc_document_number': docDocumentNumber,
      'document_hijri_date': documentHijriDate,
      'document_gregorian_date': documentGregorianDate,
    };
  }

  @override
  List<Object?> get props => [
    docHijriDate,
    docGregorianDate,
    docRecordBookId,
    docRecordBookNumber,
    docPageNumber,
    docEntryNumber,
    docBoxNumber,
    docDocumentNumber,
  ];
}

/// 4. Financial Information
class RegistryFinancialInfo extends Equatable {
  final double? feeAmount;
  final double? supportAmount;
  final double? sustainabilityAmount;
  final double? penaltyAmount;
  final double? authenticationFeeAmount;
  final double? transferFeeAmount;
  final double? otherFeeAmount;
  final String? exemptionType;
  final String? exemptionReason;
  final String? receiptNumber;
  final double totalAmount;
  final double paidAmount;

  const RegistryFinancialInfo({
    this.feeAmount,
    this.supportAmount,
    this.sustainabilityAmount,
    this.penaltyAmount,
    this.authenticationFeeAmount,
    this.transferFeeAmount,
    this.otherFeeAmount,
    this.exemptionType,
    this.exemptionReason,
    this.receiptNumber,
    this.totalAmount = 0.0,
    this.paidAmount = 0.0,
  });

  factory RegistryFinancialInfo.fromJson(Map<String, dynamic> json) {
    double parseDouble(dynamic val) {
      if (val == null) return 0.0;
      if (val is double) return val;
      if (val is int) return val.toDouble();
      return double.tryParse(val.toString()) ?? 0.0;
    }

    return RegistryFinancialInfo(
      feeAmount: parseDouble(json['fee_amount']),
      supportAmount: parseDouble(json['support_amount']),
      sustainabilityAmount: parseDouble(json['sustainability_amount']),
      penaltyAmount: parseDouble(json['penalty_amount']),
      authenticationFeeAmount: parseDouble(json['authentication_fee_amount']),
      transferFeeAmount: parseDouble(json['transfer_fee_amount']),
      otherFeeAmount: parseDouble(json['other_fee_amount']),
      exemptionType: json['exemption_type'],
      exemptionReason: json['exemption_reason'],
      receiptNumber: json['receipt_number'],
      totalAmount: parseDouble(json['total_amount']),
      paidAmount: parseDouble(json['paid_amount']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'fee_amount': feeAmount,
      'support_amount': supportAmount,
      'sustainability_amount': sustainabilityAmount,
      'penalty_amount': penaltyAmount,
      'authentication_fee_amount': authenticationFeeAmount,
      'transfer_fee_amount': transferFeeAmount,
      'other_fee_amount': otherFeeAmount,
      'exemption_type': exemptionType,
      'exemption_reason': exemptionReason,
      'receipt_number': receiptNumber,
      'total_amount': totalAmount,
      'paid_amount': paidAmount,
    };
  }

  @override
  List<Object?> get props => [
    feeAmount,
    supportAmount,
    sustainabilityAmount,
    penaltyAmount,
    authenticationFeeAmount,
    transferFeeAmount,
    otherFeeAmount,
    exemptionType,
    exemptionReason,
    receiptNumber,
    totalAmount,
    paidAmount,
  ];
}

/// 5. Guardian Information
class RegistryGuardianInfo extends Equatable {
  final int? guardianId;
  final int? guardianRecordBookId;
  final int? guardianRecordBookNumber;
  final int? guardianPageNumber;
  final int? guardianEntryNumber;
  final String? guardianHijriDate;

  const RegistryGuardianInfo({
    this.guardianId,
    this.guardianRecordBookId,
    this.guardianRecordBookNumber,
    this.guardianPageNumber,
    this.guardianEntryNumber,
    this.guardianHijriDate,
  });

  factory RegistryGuardianInfo.fromJson(Map<String, dynamic> json) {
    return RegistryGuardianInfo(
      guardianId: json['guardian_id'],
      guardianRecordBookId: json['guardian_record_book_id'],
      guardianRecordBookNumber: json['guardian_record_book_number'],
      guardianPageNumber: json['guardian_page_number'],
      guardianEntryNumber: json['guardian_entry_number'],
      guardianHijriDate: json['guardian_hijri_date'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'guardian_id': guardianId,
      'guardian_record_book_id': guardianRecordBookId,
      'guardian_record_book_number': guardianRecordBookNumber,
      'guardian_page_number': guardianPageNumber,
      'guardian_entry_number': guardianEntryNumber,
      'guardian_hijri_date': guardianHijriDate,
    };
  }

  @override
  List<Object?> get props => [
    guardianId,
    guardianRecordBookId,
    guardianRecordBookNumber,
    guardianPageNumber,
    guardianEntryNumber,
    guardianHijriDate,
  ];
}

/// 6. Status & Metadata
class RegistryStatusInfo extends Equatable {
  final String status;
  final String deliveryStatus;
  final String? statusLabel;
  final String? statusColor;
  final String? deliveryStatusLabel;
  final String? deliveryStatusColor;
  final String? notes;

  const RegistryStatusInfo({
    this.status = 'draft',
    this.deliveryStatus = 'preserved',
    this.statusLabel,
    this.statusColor,
    this.deliveryStatusLabel,
    this.deliveryStatusColor,
    this.notes,
  });

  factory RegistryStatusInfo.fromJson(Map<String, dynamic> json) {
    return RegistryStatusInfo(
      status: json['status'] ?? 'draft',
      deliveryStatus: json['delivery_status'] ?? 'preserved',
      statusLabel: json['status_label'],
      statusColor: json['status_color'],
      deliveryStatusLabel: json['delivery_status_label'],
      deliveryStatusColor: json['delivery_status_color'],
      notes: json['notes'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'delivery_status': deliveryStatus,
      'status_label': statusLabel,
      'status_color': statusColor,
      'delivery_status_label': deliveryStatusLabel,
      'delivery_status_color': deliveryStatusColor,
      'notes': notes,
    };
  }

  @override
  List<Object?> get props => [
    status,
    deliveryStatus,
    statusLabel,
    statusColor,
    deliveryStatusLabel,
    deliveryStatusColor,
    notes,
  ];
}

class RegistryMetadata extends Equatable {
  final int? createdBy;
  final int? updatedBy;
  final String? createdAt;
  final String? updatedAt;
  final bool isDeleted;

  const RegistryMetadata({
    this.createdBy,
    this.updatedBy,
    this.createdAt,
    this.updatedAt,
    this.isDeleted = false,
  });

  factory RegistryMetadata.fromJson(Map<String, dynamic> json) {
    return RegistryMetadata(
      createdBy: json['created_by'],
      updatedBy: json['updated_by'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      isDeleted: json['is_deleted'] == true || json['is_deleted'] == 1,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'created_by': createdBy,
      'updated_by': updatedBy,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'is_deleted': isDeleted,
    };
  }

  @override
  List<Object?> get props => [
    createdBy,
    updatedBy,
    createdAt,
    updatedAt,
    isDeleted,
  ];
}
