class DispositionRecord {
  final int id;
  final int? registryEntryId;
  final int? constraintId;
  final String disposerName;
  final String disposedToName;
  final String? dispositionType;
  final String? dispositionSubject;
  final double? taxAmount;
  final String? taxReceiptNumber;
  final String? createdAt;
  final String? updatedAt;
  final String? deletedAt;
  final String? subtype1;
  final String? subtype2;

  DispositionRecord({
    required this.id,
    this.registryEntryId,
    this.constraintId,
    required this.disposerName,
    required this.disposedToName,
    this.dispositionType,
    this.dispositionSubject,
    this.taxAmount,
    this.taxReceiptNumber,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
    this.subtype1,
    this.subtype2,
  });

  factory DispositionRecord.fromJson(Map<String, dynamic> json) {
    return DispositionRecord(
      id: json['id'] != null ? (json['id'] is int ? json['id'] : int.tryParse(json['id'].toString()) ?? 0) : 0,
      registryEntryId: json['registry_entry_id'] != null ? (json['registry_entry_id'] is int ? json['registry_entry_id'] : int.tryParse(json['registry_entry_id'].toString()) ?? null) : null,
      constraintId: json['constraint_id'] != null ? (json['constraint_id'] is int ? json['constraint_id'] : int.tryParse(json['constraint_id'].toString()) ?? null) : null,
      disposerName: json['disposer_name'] ?? '',
      disposedToName: json['disposed_to_name'] ?? '',
      dispositionType: json['disposition_type'] ?? null,
      dispositionSubject: json['disposition_subject'] ?? null,
      taxAmount: json['tax_amount'] != null ? (json['tax_amount'] is num ? json['tax_amount'].toDouble() : double.tryParse(json['tax_amount'].toString()) ?? null) : null,
      taxReceiptNumber: json['tax_receipt_number'] ?? null,
      createdAt: json['created_at'] ?? null,
      updatedAt: json['updated_at'] ?? null,
      deletedAt: json['deleted_at'] ?? null,
      subtype1: json['subtype_1'] ?? null,
      subtype2: json['subtype_2'] ?? null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'registry_entry_id': registryEntryId,
      'constraint_id': constraintId,
      'disposer_name': disposerName,
      'disposed_to_name': disposedToName,
      'disposition_type': dispositionType,
      'disposition_subject': dispositionSubject,
      'tax_amount': taxAmount,
      'tax_receipt_number': taxReceiptNumber,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'deleted_at': deletedAt,
      'subtype_1': subtype1,
      'subtype_2': subtype2,
    };
  }
}
