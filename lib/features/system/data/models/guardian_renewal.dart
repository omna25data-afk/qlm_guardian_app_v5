class GuardianRenewal {
  final int id;
  final int guardianId;
  final String renewalType;
  final String renewalDate;
  final String expiryDate;
  final String status;
  final String? documents;
  final double? fees;
  final int? approvedBy;
  final String? notes;
  final String? createdAt;
  final String? updatedAt;
  final String? deletedAt;

  GuardianRenewal({
    required this.id,
    required this.guardianId,
    required this.renewalType,
    required this.renewalDate,
    required this.expiryDate,
    required this.status,
    this.documents,
    this.fees,
    this.approvedBy,
    this.notes,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
  });

  factory GuardianRenewal.fromJson(Map<String, dynamic> json) {
    return GuardianRenewal(
      id: json['id'] != null ? (json['id'] is int ? json['id'] : int.tryParse(json['id'].toString()) ?? 0) : 0,
      guardianId: json['guardian_id'] != null ? (json['guardian_id'] is int ? json['guardian_id'] : int.tryParse(json['guardian_id'].toString()) ?? 0) : 0,
      renewalType: json['renewal_type'] ?? '',
      renewalDate: json['renewal_date'] ?? '',
      expiryDate: json['expiry_date'] ?? '',
      status: json['status'] ?? '',
      documents: json['documents'] ?? null,
      fees: json['fees'] != null ? (json['fees'] is num ? json['fees'].toDouble() : double.tryParse(json['fees'].toString()) ?? null) : null,
      approvedBy: json['approved_by'] != null ? (json['approved_by'] is int ? json['approved_by'] : int.tryParse(json['approved_by'].toString()) ?? null) : null,
      notes: json['notes'] ?? null,
      createdAt: json['created_at'] ?? null,
      updatedAt: json['updated_at'] ?? null,
      deletedAt: json['deleted_at'] ?? null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'guardian_id': guardianId,
      'renewal_type': renewalType,
      'renewal_date': renewalDate,
      'expiry_date': expiryDate,
      'status': status,
      'documents': documents,
      'fees': fees,
      'approved_by': approvedBy,
      'notes': notes,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'deleted_at': deletedAt,
    };
  }
}
