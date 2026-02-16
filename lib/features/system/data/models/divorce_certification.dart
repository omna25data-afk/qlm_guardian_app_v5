class DivorceCertification {
  final int id;
  final int? registryEntryId;
  final int? constraintId;
  final String divorcerName;
  final String divorcedName;
  final String? marriageContractNumber;
  final String? divorceType;
  final String? divorceCount;
  final String? createdAt;
  final String? updatedAt;
  final String? deletedAt;
  final String? subtype1;
  final String? subtype2;

  DivorceCertification({
    required this.id,
    this.registryEntryId,
    this.constraintId,
    required this.divorcerName,
    required this.divorcedName,
    this.marriageContractNumber,
    this.divorceType,
    this.divorceCount,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
    this.subtype1,
    this.subtype2,
  });

  factory DivorceCertification.fromJson(Map<String, dynamic> json) {
    return DivorceCertification(
      id: json['id'] != null ? (json['id'] is int ? json['id'] : int.tryParse(json['id'].toString()) ?? 0) : 0,
      registryEntryId: json['registry_entry_id'] != null ? (json['registry_entry_id'] is int ? json['registry_entry_id'] : int.tryParse(json['registry_entry_id'].toString()) ?? null) : null,
      constraintId: json['constraint_id'] != null ? (json['constraint_id'] is int ? json['constraint_id'] : int.tryParse(json['constraint_id'].toString()) ?? null) : null,
      divorcerName: json['divorcer_name'] ?? '',
      divorcedName: json['divorced_name'] ?? '',
      marriageContractNumber: json['marriage_contract_number'] ?? null,
      divorceType: json['divorce_type'] ?? null,
      divorceCount: json['divorce_count'] ?? null,
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
      'divorcer_name': divorcerName,
      'divorced_name': divorcedName,
      'marriage_contract_number': marriageContractNumber,
      'divorce_type': divorceType,
      'divorce_count': divorceCount,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'deleted_at': deletedAt,
      'subtype_1': subtype1,
      'subtype_2': subtype2,
    };
  }
}
