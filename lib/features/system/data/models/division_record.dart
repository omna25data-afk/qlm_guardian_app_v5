class DivisionRecord {
  final int id;
  final int? registryEntryId;
  final int? constraintId;
  final String? deceasedName;
  final String inheritorName;
  final String? estateDescription;
  final String heirsNames;
  final String? createdAt;
  final String? updatedAt;
  final String? deletedAt;
  final String? subtype1;
  final String? subtype2;

  DivisionRecord({
    required this.id,
    this.registryEntryId,
    this.constraintId,
    this.deceasedName,
    required this.inheritorName,
    this.estateDescription,
    required this.heirsNames,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
    this.subtype1,
    this.subtype2,
  });

  factory DivisionRecord.fromJson(Map<String, dynamic> json) {
    return DivisionRecord(
      id: json['id'] != null ? (json['id'] is int ? json['id'] : int.tryParse(json['id'].toString()) ?? 0) : 0,
      registryEntryId: json['registry_entry_id'] != null ? (json['registry_entry_id'] is int ? json['registry_entry_id'] : int.tryParse(json['registry_entry_id'].toString()) ?? null) : null,
      constraintId: json['constraint_id'] != null ? (json['constraint_id'] is int ? json['constraint_id'] : int.tryParse(json['constraint_id'].toString()) ?? null) : null,
      deceasedName: json['deceased_name'] ?? null,
      inheritorName: json['inheritor_name'] ?? '',
      estateDescription: json['estate_description'] ?? null,
      heirsNames: json['heirs_names'] ?? '',
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
      'deceased_name': deceasedName,
      'inheritor_name': inheritorName,
      'estate_description': estateDescription,
      'heirs_names': heirsNames,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'deleted_at': deletedAt,
      'subtype_1': subtype1,
      'subtype_2': subtype2,
    };
  }
}
