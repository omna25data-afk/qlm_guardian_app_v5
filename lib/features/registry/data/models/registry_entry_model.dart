import 'package:json_annotation/json_annotation.dart';
import 'package:equatable/equatable.dart';

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
  @JsonKey(name: 'constraint_type_id')
  final int? constraintTypeId; // New
  final String? status; // draft, pending, documented, etc.
  @JsonKey(name: 'serial_number')
  final int? serialNumber;
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
  final String? content;

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
  @JsonKey(name: 'extra_attributes')
  final Map<String, dynamic>? extraAttributes;

  const RegistryEntryModel({
    this.id,
    this.uuid,
    this.remoteId,
    this.guardianId,
    this.contractTypeId,
    this.constraintTypeId,
    this.status = 'draft',
    this.serialNumber,
    this.registerNumber,
    this.date,
    this.hijriYear,
    this.hijriDate,
    this.subject,
    this.content,
    this.firstPartyName,
    this.secondPartyName,
    this.writerType,
    this.writerId,
    this.otherWriterId,
    this.writerName,
    this.documentHijriDate,
    this.documentGregorianDate,
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
    this.supportAmount,
    this.sustainabilityAmount,
    this.totalAmount = 0.0,
    this.paidAmount = 0.0,
    this.receiptNumber,
    this.exemptionType,
    this.constraintableType,
    this.constraintableId,
    this.deliveryStatus,
    this.createdAt,
    this.extraAttributes,
  });

  factory RegistryEntryModel.fromJson(Map<String, dynamic> json) =>
      _$RegistryEntryModelFromJson(json);
  Map<String, dynamic> toJson() => _$RegistryEntryModelToJson(this);

  @override
  List<Object?> get props => [
    uuid,
    remoteId,
    status,
    serialNumber,
    guardianRecordBookId,
    contractTypeId,
    extraAttributes,
    firstPartyName,
    secondPartyName,
    writerType,
    totalAmount,
  ];

  RegistryEntryModel copyWith({
    int? id,
    String? uuid,
    int? remoteId,
    int? guardianId,
    int? contractTypeId,
    int? constraintTypeId,
    String? status,
    int? serialNumber,
    String? registerNumber,
    DateTime? date,
    int? hijriYear,
    String? hijriDate,
    String? subject,
    String? content,
    String? firstPartyName,
    String? secondPartyName,
    String? writerType,
    int? writerId,
    int? otherWriterId,
    String? writerName,
    String? documentHijriDate,
    DateTime? documentGregorianDate,
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
    double? supportAmount,
    double? sustainabilityAmount,
    double? totalAmount,
    double? paidAmount,
    String? receiptNumber,
    String? exemptionType,
    String? constraintableType,
    int? constraintableId,
    String? deliveryStatus,
    DateTime? createdAt,
    Map<String, dynamic>? extraAttributes,
  }) {
    return RegistryEntryModel(
      id: id ?? this.id,
      uuid: uuid ?? this.uuid,
      remoteId: remoteId ?? this.remoteId,
      guardianId: guardianId ?? this.guardianId,
      contractTypeId: contractTypeId ?? this.contractTypeId,
      constraintTypeId: constraintTypeId ?? this.constraintTypeId,
      status: status ?? this.status,
      serialNumber: serialNumber ?? this.serialNumber,
      registerNumber: registerNumber ?? this.registerNumber,
      date: date ?? this.date,
      hijriYear: hijriYear ?? this.hijriYear,
      hijriDate: hijriDate ?? this.hijriDate,
      subject: subject ?? this.subject,
      content: content ?? this.content,
      firstPartyName: firstPartyName ?? this.firstPartyName,
      secondPartyName: secondPartyName ?? this.secondPartyName,
      writerType: writerType ?? this.writerType,
      writerId: writerId ?? this.writerId,
      otherWriterId: otherWriterId ?? this.otherWriterId,
      writerName: writerName ?? this.writerName,
      documentHijriDate: documentHijriDate ?? this.documentHijriDate,
      documentGregorianDate:
          documentGregorianDate ?? this.documentGregorianDate,
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
      supportAmount: supportAmount ?? this.supportAmount,
      sustainabilityAmount: sustainabilityAmount ?? this.sustainabilityAmount,
      totalAmount: totalAmount ?? this.totalAmount,
      paidAmount: paidAmount ?? this.paidAmount,
      receiptNumber: receiptNumber ?? this.receiptNumber,
      exemptionType: exemptionType ?? this.exemptionType,
      constraintableType: constraintableType ?? this.constraintableType,
      constraintableId: constraintableId ?? this.constraintableId,
      deliveryStatus: deliveryStatus ?? this.deliveryStatus,
      createdAt: createdAt ?? this.createdAt,
      extraAttributes: extraAttributes ?? this.extraAttributes,
    );
  }
}
