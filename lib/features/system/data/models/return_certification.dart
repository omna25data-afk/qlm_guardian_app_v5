class ReturnCertification {
  final int id;
  final int? registryEntryId;
  final int? constraintId;
  final String husbandName;
  final String wifeName;
  final String? divorceCertificateNumber;
  final String returnDate;
  final String? revocationDate;
  final String? createdAt;
  final String? updatedAt;
  final String? deletedAt;
  final String? subtype1;
  final String? subtype2;

  ReturnCertification({
    required this.id,
    this.registryEntryId,
    this.constraintId,
    required this.husbandName,
    required this.wifeName,
    this.divorceCertificateNumber,
    required this.returnDate,
    this.revocationDate,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
    this.subtype1,
    this.subtype2,
  });

  factory ReturnCertification.fromJson(Map<String, dynamic> json) {
    return ReturnCertification(
      id: json['id'] != null
          ? (json['id'] is int
                ? json['id']
                : int.tryParse(json['id'].toString()) ?? 0)
          : 0,
      registryEntryId: json['registry_entry_id'] != null
          ? (json['registry_entry_id'] is int
                ? json['registry_entry_id']
                : int.tryParse(json['registry_entry_id'].toString()) ?? null)
          : null,
      constraintId: json['constraint_id'] != null
          ? (json['constraint_id'] is int
                ? json['constraint_id']
                : int.tryParse(json['constraint_id'].toString()) ?? null)
          : null,
      husbandName: json['husband_name'] ?? '',
      wifeName: json['wife_name'] ?? '',
      divorceCertificateNumber: json['divorce_certificate_number'] ?? null,
      returnDate: json['return_date'] ?? '',
      revocationDate: json['revocation_date'] ?? null,
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
      'husband_name': husbandName,
      'wife_name': wifeName,
      'divorce_certificate_number': divorceCertificateNumber,
      'return_date': returnDate,
      'revocation_date': revocationDate,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'deleted_at': deletedAt,
      'subtype_1': subtype1,
      'subtype_2': subtype2,
    };
  }
}
