import 'package:json_annotation/json_annotation.dart';
import 'package:equatable/equatable.dart';
import 'contract_type_model.dart';

part 'registry_entry_model.g.dart';

@JsonSerializable()
@JsonSerializable()
class RegistryEntryModel extends Equatable {
  final int? id; // Local ID
  final String? uuid;
  @JsonKey(name: 'remote_id')
  final int? remoteId;

  // --- Basic Identifiers ---
  @JsonKey(name: 'guardian_id')
  final int? guardianId;
  @JsonKey(name: 'contract_type_id')
  final int? contractTypeId;
  @JsonKey(name: 'contract_type') // Nested object
  final ContractTypeModel? contractType;
  @JsonKey(name: 'constraint_type_id')
  final int? constraintTypeId; // New
  final String? status; // draft, pending, documented, etc.
  @JsonKey(name: 'serial_number')
  final int? serialNumber;
  @JsonKey(name: 'status_label')
  final String? statusLabel;
  @JsonKey(name: 'status_color')
  final String? statusColor;
  @JsonKey(name: 'delivery_status_label')
  final String? deliveryStatusLabel;
  @JsonKey(name: 'delivery_status_color')
  final String? deliveryStatusColor;

  @JsonKey(name: 'register_number')
  final String? registerNumber;

  // --- Dates ---
  final DateTime? date; // General date
  @JsonKey(name: 'hijri_year')
  final int? hijriYear;
  @JsonKey(name: 'hijri_date')
  final String? hijriDate;

  // --- Content ---
  final String? subject;
  final String? content; // Kept for legacy/display if needed
  final String? notes; // Mapped to backend 'notes'

  // --- Subtypes ---
  @JsonKey(name: 'subtype_1')
  final int? subtype1;
  @JsonKey(name: 'subtype_2')
  final int? subtype2;

  // --- Parties (Flattened) ---
  @JsonKey(name: 'first_party_name')
  final String? firstPartyName;
  @JsonKey(name: 'second_party_name')
  final String? secondPartyName;

  // --- Writer / Editor ---
  @JsonKey(name: 'writer_type')
  final String? writerType; // guardian, documentation, external
  @JsonKey(name: 'writer_id')
  final int? writerId;
  @JsonKey(name: 'other_writer_id')
  final int? otherWriterId;
  @JsonKey(name: 'writer_name')
  final String? writerName;
  @JsonKey(name: 'document_hijri_date')
  final String? documentHijriDate;
  @JsonKey(name: 'document_gregorian_date')
  final DateTime? documentGregorianDate;

  // --- Documentation Record (Court) ---
  @JsonKey(name: 'doc_record_book_id')
  final int? docRecordBookId;

  @JsonKey(name: 'doc_gregorian_date')
  final DateTime? docGregorianDate;
  @JsonKey(name: 'doc_record_book_number')
  final int? docRecordBookNumber;
  @JsonKey(name: 'doc_page_number')
  final int? docPageNumber;
  @JsonKey(name: 'doc_entry_number')
  final int? docEntryNumber;
  @JsonKey(name: 'doc_box_number')
  final int? docBoxNumber;
  @JsonKey(name: 'doc_document_number')
  final int? docDocumentNumber;
  @JsonKey(name: 'doc_hijri_date')
  final String? docHijriDate;

  // --- Guardian Record (Personal) ---
  @JsonKey(name: 'guardian_record_book_id')
  final int? guardianRecordBookId; // Replaces ambiguous recordBookId
  @JsonKey(name: 'guardian_record_book_number')
  final int? guardianRecordBookNumber;
  @JsonKey(name: 'guardian_page_number')
  final int? guardianPageNumber;
  @JsonKey(name: 'guardian_entry_number')
  final int? guardianEntryNumber;
  @JsonKey(name: 'guardian_hijri_date')
  final String? guardianHijriDate;

  // --- Financial & Fees ---
  @JsonKey(name: 'fee_amount')
  final double? feeAmount;
  @JsonKey(name: 'penalty_amount')
  final double? penaltyAmount;
  @JsonKey(name: 'authentication_fee_amount')
  final double? authenticationFeeAmount;
  @JsonKey(name: 'transfer_fee_amount')
  final double? transferFeeAmount;
  @JsonKey(name: 'other_fee_amount')
  final double? otherFeeAmount;
  @JsonKey(name: 'support_amount')
  final double? supportAmount;
  @JsonKey(name: 'sustainability_amount')
  final double? sustainabilityAmount;
  @JsonKey(name: 'total_amount')
  final double totalAmount; // Calculated or stored total
  @JsonKey(name: 'paid_amount')
  final double paidAmount;
  @JsonKey(name: 'receipt_number')
  final String? receiptNumber;
  @JsonKey(name: 'exemption_type')
  final String? exemptionType;
  @JsonKey(name: 'exemption_reason')
  final String? exemptionReason;

  // --- Advanced Relations ---
  @JsonKey(name: 'constraintable_type')
  final String? constraintableType;
  @JsonKey(name: 'constraintable_id')
  final int? constraintableId;
  @JsonKey(name: 'delivery_status')
  final String? deliveryStatus; // kept, delivered

  // --- System ---
  @JsonKey(name: 'created_at')
  final DateTime? createdAt;

  // Use form_data for dynamic fields to match backend
  @JsonKey(name: 'form_data')
  final Map<String, dynamic>? formData;

  // Deprecated: kept for backward compatibility if needed locally, but verified upstream uses form_data
  @JsonKey(name: 'extra_attributes')
  final Map<String, dynamic>? extraAttributes;

  const RegistryEntryModel({
    this.id,
    this.uuid,
    this.remoteId,
    this.guardianId,
    this.contractTypeId,
    this.contractType,
    this.constraintTypeId,
    this.status = 'draft',
    this.statusLabel,
    this.statusColor,
    this.deliveryStatusLabel,
    this.deliveryStatusColor,
    this.serialNumber,
    this.registerNumber,
    this.date,
    this.hijriYear,
    this.hijriDate,
    this.subject,
    this.content,
    this.notes,
    this.subtype1,
    this.subtype2,
    this.firstPartyName,
    this.secondPartyName,
    this.writerType,
    this.writerId,
    this.otherWriterId,
    this.writerName,
    this.documentHijriDate,
    this.documentGregorianDate,
    this.docGregorianDate,
    this.docRecordBookId,
    this.docRecordBookNumber,
    this.docPageNumber,
    this.docEntryNumber,
    this.docBoxNumber,
    this.docDocumentNumber,
    this.docHijriDate,
    this.guardianRecordBookId,
    this.guardianRecordBookNumber,
    this.guardianPageNumber,
    this.guardianEntryNumber,
    this.guardianHijriDate,
    this.feeAmount,
    this.penaltyAmount,
    this.authenticationFeeAmount,
    this.transferFeeAmount,
    this.otherFeeAmount,
    this.supportAmount,
    this.sustainabilityAmount,
    this.totalAmount = 0.0,
    this.paidAmount = 0.0,
    this.receiptNumber,
    this.exemptionType,
    this.exemptionReason,
    this.constraintableType,
    this.constraintableId,
    this.deliveryStatus,
    this.createdAt,
    this.formData,
    this.extraAttributes,
  });

  factory RegistryEntryModel.fromJson(Map<String, dynamic> json) {
    final data = Map<String, dynamic>.from(json);
    void stripTime(String key) {
      if (data[key] != null && data[key] is String) {
        data[key] = data[key].toString().split('T').first;
      }
    }

    stripTime('document_hijri_date');
    stripTime('doc_hijri_date');
    stripTime('guardian_hijri_date');
    stripTime('hijri_date');

    return _$RegistryEntryModelFromJson(data);
  }
  Map<String, dynamic> toJson() => _$RegistryEntryModelToJson(this);

  @override
  List<Object?> get props => [
    uuid,
    remoteId,
    status,
    statusLabel,
    statusColor,
    serialNumber,
    guardianRecordBookId,
    contractTypeId,
    contractType,
    extraAttributes,
    formData,
    notes,
    subtype1,
    subtype2,
    firstPartyName,
    secondPartyName,
    writerType,
    totalAmount,
    subject,
    content,
    hijriYear,
    registerNumber,
    feeAmount,
    penaltyAmount,
    authenticationFeeAmount,
    transferFeeAmount,
    otherFeeAmount,
    exemptionReason,
  ];

  RegistryEntryModel copyWith({
    int? id,
    String? uuid,
    int? remoteId,
    int? guardianId,
    int? contractTypeId,
    ContractTypeModel? contractType,
    int? constraintTypeId,
    String? status,
    String? statusLabel,
    String? statusColor,
    String? deliveryStatusLabel,
    String? deliveryStatusColor,
    int? serialNumber,
    String? registerNumber,
    DateTime? date,
    int? hijriYear,
    String? hijriDate,
    String? subject,
    String? content,
    String? notes,
    int? subtype1,
    int? subtype2,
    String? firstPartyName,
    String? secondPartyName,
    String? writerType,
    int? writerId,
    int? otherWriterId,
    String? writerName,
    String? documentHijriDate,
    DateTime? documentGregorianDate,
    DateTime? docGregorianDate,
    int? docRecordBookId,
    int? docRecordBookNumber,
    int? docPageNumber,
    int? docEntryNumber,
    int? docBoxNumber,
    int? docDocumentNumber,
    String? docHijriDate,
    int? guardianRecordBookId,
    int? guardianRecordBookNumber,
    int? guardianPageNumber,
    int? guardianEntryNumber,
    String? guardianHijriDate,
    double? feeAmount,
    double? penaltyAmount,
    double? authenticationFeeAmount,
    double? transferFeeAmount,
    double? otherFeeAmount,
    double? supportAmount,
    double? sustainabilityAmount,
    double? totalAmount,
    double? paidAmount,
    String? receiptNumber,
    String? exemptionType,
    String? exemptionReason,
    String? constraintableType,
    int? constraintableId,
    String? deliveryStatus,
    DateTime? createdAt,
    Map<String, dynamic>? formData,
    Map<String, dynamic>? extraAttributes,
  }) {
    return RegistryEntryModel(
      id: id ?? this.id,
      uuid: uuid ?? this.uuid,
      remoteId: remoteId ?? this.remoteId,
      guardianId: guardianId ?? this.guardianId,
      contractTypeId: contractTypeId ?? this.contractTypeId,
      contractType: contractType ?? this.contractType,
      constraintTypeId: constraintTypeId ?? this.constraintTypeId,
      status: status ?? this.status,
      statusLabel: statusLabel ?? this.statusLabel,
      statusColor: statusColor ?? this.statusColor,
      deliveryStatusLabel: deliveryStatusLabel ?? this.deliveryStatusLabel,
      deliveryStatusColor: deliveryStatusColor ?? this.deliveryStatusColor,
      serialNumber: serialNumber ?? this.serialNumber,
      registerNumber: registerNumber ?? this.registerNumber,
      date: date ?? this.date,
      hijriYear: hijriYear ?? this.hijriYear,
      hijriDate: hijriDate ?? this.hijriDate,
      subject: subject ?? this.subject,
      content: content ?? this.content,
      notes: notes ?? this.notes,
      subtype1: subtype1 ?? this.subtype1,
      subtype2: subtype2 ?? this.subtype2,
      firstPartyName: firstPartyName ?? this.firstPartyName,
      secondPartyName: secondPartyName ?? this.secondPartyName,
      writerType: writerType ?? this.writerType,
      writerId: writerId ?? this.writerId,
      otherWriterId: otherWriterId ?? this.otherWriterId,
      writerName: writerName ?? this.writerName,
      documentHijriDate: documentHijriDate ?? this.documentHijriDate,
      documentGregorianDate:
          documentGregorianDate ?? this.documentGregorianDate,
      docGregorianDate: docGregorianDate ?? this.docGregorianDate,
      docRecordBookId: docRecordBookId ?? this.docRecordBookId,
      docRecordBookNumber: docRecordBookNumber ?? this.docRecordBookNumber,
      docPageNumber: docPageNumber ?? this.docPageNumber,
      docEntryNumber: docEntryNumber ?? this.docEntryNumber,
      docBoxNumber: docBoxNumber ?? this.docBoxNumber,
      docDocumentNumber: docDocumentNumber ?? this.docDocumentNumber,
      docHijriDate: docHijriDate ?? this.docHijriDate,
      guardianRecordBookId: guardianRecordBookId ?? this.guardianRecordBookId,
      guardianRecordBookNumber:
          guardianRecordBookNumber ?? this.guardianRecordBookNumber,
      guardianPageNumber: guardianPageNumber ?? this.guardianPageNumber,
      guardianEntryNumber: guardianEntryNumber ?? this.guardianEntryNumber,
      guardianHijriDate: guardianHijriDate ?? this.guardianHijriDate,
      feeAmount: feeAmount ?? this.feeAmount,
      penaltyAmount: penaltyAmount ?? this.penaltyAmount,
      authenticationFeeAmount:
          authenticationFeeAmount ?? this.authenticationFeeAmount,
      transferFeeAmount: transferFeeAmount ?? this.transferFeeAmount,
      otherFeeAmount: otherFeeAmount ?? this.otherFeeAmount,
      supportAmount: supportAmount ?? this.supportAmount,
      sustainabilityAmount: sustainabilityAmount ?? this.sustainabilityAmount,
      totalAmount: totalAmount ?? this.totalAmount,
      paidAmount: paidAmount ?? this.paidAmount,
      receiptNumber: receiptNumber ?? this.receiptNumber,
      exemptionType: exemptionType ?? this.exemptionType,
      exemptionReason: exemptionReason ?? this.exemptionReason,
      constraintableType: constraintableType ?? this.constraintableType,
      constraintableId: constraintableId ?? this.constraintableId,
      deliveryStatus: deliveryStatus ?? this.deliveryStatus,
      createdAt: createdAt ?? this.createdAt,
      formData: formData ?? this.formData,
      extraAttributes: extraAttributes ?? this.extraAttributes,
    );
  }
}
