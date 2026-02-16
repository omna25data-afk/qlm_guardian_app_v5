class IdentityCardRenewal {
  final int id;
  final int legitimateGuardianId;
  final int renewalNumber;
  final String renewalDate;
  final String? receiptNumber;
  final double? receiptAmount;
  final String? receiptDate;
  final String expiryDate;
  final String? notes;
  final int createdBy;
  final String? createdAt;
  final String? updatedAt;
  final String? deletedAt;

  IdentityCardRenewal({
    required this.id,
    required this.legitimateGuardianId,
    required this.renewalNumber,
    required this.renewalDate,
    this.receiptNumber,
    this.receiptAmount,
    this.receiptDate,
    required this.expiryDate,
    this.notes,
    required this.createdBy,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
  });

  factory IdentityCardRenewal.fromJson(Map<String, dynamic> json) {
    return IdentityCardRenewal(
      id: json['id'] != null ? (json['id'] is int ? json['id'] : int.tryParse(json['id'].toString()) ?? 0) : 0,
      legitimateGuardianId: json['legitimate_guardian_id'] != null ? (json['legitimate_guardian_id'] is int ? json['legitimate_guardian_id'] : int.tryParse(json['legitimate_guardian_id'].toString()) ?? 0) : 0,
      renewalNumber: json['renewal_number'] != null ? (json['renewal_number'] is int ? json['renewal_number'] : int.tryParse(json['renewal_number'].toString()) ?? 0) : 0,
      renewalDate: json['renewal_date'] ?? '',
      receiptNumber: json['receipt_number'] ?? null,
      receiptAmount: json['receipt_amount'] != null ? (json['receipt_amount'] is num ? json['receipt_amount'].toDouble() : double.tryParse(json['receipt_amount'].toString()) ?? null) : null,
      receiptDate: json['receipt_date'] ?? null,
      expiryDate: json['expiry_date'] ?? '',
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
      'legitimate_guardian_id': legitimateGuardianId,
      'renewal_number': renewalNumber,
      'renewal_date': renewalDate,
      'receipt_number': receiptNumber,
      'receipt_amount': receiptAmount,
      'receipt_date': receiptDate,
      'expiry_date': expiryDate,
      'notes': notes,
      'created_by': createdBy,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'deleted_at': deletedAt,
    };
  }
}
