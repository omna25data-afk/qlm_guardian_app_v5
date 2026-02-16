class AgencyContract {
  final int id;
  final int? registryEntryId;
  final int? constraintId;
  final String principalName;
  final String? principalNationalId;
  final String agentName;
  final String? agentNationalId;
  final String? agencyType;
  final String? agencyPurpose;
  final String? agencyPowers;
  final String? agencyDuration;
  final String? createdAt;
  final String? updatedAt;
  final String? deletedAt;
  final String? subtype1;
  final String? subtype2;

  AgencyContract({
    required this.id,
    this.registryEntryId,
    this.constraintId,
    required this.principalName,
    this.principalNationalId,
    required this.agentName,
    this.agentNationalId,
    this.agencyType,
    this.agencyPurpose,
    this.agencyPowers,
    this.agencyDuration,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
    this.subtype1,
    this.subtype2,
  });

  factory AgencyContract.fromJson(Map<String, dynamic> json) {
    return AgencyContract(
      id: json['id'] != null ? (json['id'] is int ? json['id'] : int.tryParse(json['id'].toString()) ?? 0) : 0,
      registryEntryId: json['registry_entry_id'] != null ? (json['registry_entry_id'] is int ? json['registry_entry_id'] : int.tryParse(json['registry_entry_id'].toString()) ?? null) : null,
      constraintId: json['constraint_id'] != null ? (json['constraint_id'] is int ? json['constraint_id'] : int.tryParse(json['constraint_id'].toString()) ?? null) : null,
      principalName: json['principal_name'] ?? '',
      principalNationalId: json['principal_national_id'] ?? null,
      agentName: json['agent_name'] ?? '',
      agentNationalId: json['agent_national_id'] ?? null,
      agencyType: json['agency_type'] ?? null,
      agencyPurpose: json['agency_purpose'] ?? null,
      agencyPowers: json['agency_powers'] ?? null,
      agencyDuration: json['agency_duration'] ?? null,
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
      'principal_name': principalName,
      'principal_national_id': principalNationalId,
      'agent_name': agentName,
      'agent_national_id': agentNationalId,
      'agency_type': agencyType,
      'agency_purpose': agencyPurpose,
      'agency_powers': agencyPowers,
      'agency_duration': agencyDuration,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'deleted_at': deletedAt,
      'subtype_1': subtype1,
      'subtype_2': subtype2,
    };
  }
}
