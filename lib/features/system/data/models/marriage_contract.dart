class MarriageContract {
  final int id;
  final int? registryEntryId;
  final int? constraintId;
  final String husbandName;
  final String? groomNationalId;
  final String wifeName;
  final String? brideNationalId;
  final String? husbandBirthDate;
  final int? groomAge;
  final String? wifeBirthDate;
  final int? brideAge;
  final int wifeAge;
  final String? guardianName;
  final String? guardianRelation;
  final double? dowryAmount;
  final double? dowryPaid;
  final String? witnesses;
  final String? createdAt;
  final String? updatedAt;
  final String? deletedAt;
  final String? subtype1;
  final String? subtype2;

  MarriageContract({
    required this.id,
    this.registryEntryId,
    this.constraintId,
    required this.husbandName,
    this.groomNationalId,
    required this.wifeName,
    this.brideNationalId,
    this.husbandBirthDate,
    this.groomAge,
    this.wifeBirthDate,
    this.brideAge,
    required this.wifeAge,
    this.guardianName,
    this.guardianRelation,
    this.dowryAmount,
    this.dowryPaid,
    this.witnesses,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
    this.subtype1,
    this.subtype2,
  });

  factory MarriageContract.fromJson(Map<String, dynamic> json) {
    return MarriageContract(
      id: json['id'] != null ? (json['id'] is int ? json['id'] : int.tryParse(json['id'].toString()) ?? 0) : 0,
      registryEntryId: json['registry_entry_id'] != null ? (json['registry_entry_id'] is int ? json['registry_entry_id'] : int.tryParse(json['registry_entry_id'].toString()) ?? null) : null,
      constraintId: json['constraint_id'] != null ? (json['constraint_id'] is int ? json['constraint_id'] : int.tryParse(json['constraint_id'].toString()) ?? null) : null,
      husbandName: json['husband_name'] ?? '',
      groomNationalId: json['groom_national_id'] ?? null,
      wifeName: json['wife_name'] ?? '',
      brideNationalId: json['bride_national_id'] ?? null,
      husbandBirthDate: json['husband_birth_date'] ?? null,
      groomAge: json['groom_age'] != null ? (json['groom_age'] is int ? json['groom_age'] : int.tryParse(json['groom_age'].toString()) ?? null) : null,
      wifeBirthDate: json['wife_birth_date'] ?? null,
      brideAge: json['bride_age'] != null ? (json['bride_age'] is int ? json['bride_age'] : int.tryParse(json['bride_age'].toString()) ?? null) : null,
      wifeAge: json['wife_age'] != null ? (json['wife_age'] is int ? json['wife_age'] : int.tryParse(json['wife_age'].toString()) ?? 0) : 0,
      guardianName: json['guardian_name'] ?? null,
      guardianRelation: json['guardian_relation'] ?? null,
      dowryAmount: json['dowry_amount'] != null ? (json['dowry_amount'] is num ? json['dowry_amount'].toDouble() : double.tryParse(json['dowry_amount'].toString()) ?? null) : null,
      dowryPaid: json['dowry_paid'] != null ? (json['dowry_paid'] is num ? json['dowry_paid'].toDouble() : double.tryParse(json['dowry_paid'].toString()) ?? null) : null,
      witnesses: json['witnesses'] ?? null,
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
      'groom_national_id': groomNationalId,
      'wife_name': wifeName,
      'bride_national_id': brideNationalId,
      'husband_birth_date': husbandBirthDate,
      'groom_age': groomAge,
      'wife_birth_date': wifeBirthDate,
      'bride_age': brideAge,
      'wife_age': wifeAge,
      'guardian_name': guardianName,
      'guardian_relation': guardianRelation,
      'dowry_amount': dowryAmount,
      'dowry_paid': dowryPaid,
      'witnesses': witnesses,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'deleted_at': deletedAt,
      'subtype_1': subtype1,
      'subtype_2': subtype2,
    };
  }
}
