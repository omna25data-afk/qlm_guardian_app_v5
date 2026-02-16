class LegitimateGuardian {
  final int id;
  final String serialNumber;
  final String firstName;
  final String fatherName;
  final String grandfatherName;
  final String familyName;
  final String? greatGrandfatherName;
  final String? nickname;
  final int? mainDistrictId;
  final String birthDate;
  final String birthPlace;
  final String phoneNumber;
  final String? homePhone;
  final String? address;
  final String? personalPhoto;
  final String proofType;
  final String proofNumber;
  final String issuingAuthority;
  final String issueDate;
  final String expiryDate;
  final String? qualification;
  final String? job;
  final String? workplace;
  final String? specializationAreas;
  final String? ministerialDecisionNumber;
  final String? ministerialDecisionDate;
  final String? licenseNumber;
  final String? licenseIssueDate;
  final String? licenseExpiryDate;
  final String? professionCardNumber;
  final String? professionCardIssueDate;
  final String? professionCardExpiryDate;
  final String employmentStatus;
  final String? stopReason;
  final String? stopDate;
  final String? notes;
  final int? specializationAreaId;
  final String? createdAt;
  final String? updatedAt;
  final int? userId;
  final String? deletedAt;

  LegitimateGuardian({
    required this.id,
    required this.serialNumber,
    required this.firstName,
    required this.fatherName,
    required this.grandfatherName,
    required this.familyName,
    this.greatGrandfatherName,
    this.nickname,
    this.mainDistrictId,
    required this.birthDate,
    required this.birthPlace,
    required this.phoneNumber,
    this.homePhone,
    this.address,
    this.personalPhoto,
    required this.proofType,
    required this.proofNumber,
    required this.issuingAuthority,
    required this.issueDate,
    required this.expiryDate,
    this.qualification,
    this.job,
    this.workplace,
    this.specializationAreas,
    this.ministerialDecisionNumber,
    this.ministerialDecisionDate,
    this.licenseNumber,
    this.licenseIssueDate,
    this.licenseExpiryDate,
    this.professionCardNumber,
    this.professionCardIssueDate,
    this.professionCardExpiryDate,
    required this.employmentStatus,
    this.stopReason,
    this.stopDate,
    this.notes,
    this.specializationAreaId,
    this.createdAt,
    this.updatedAt,
    this.userId,
    this.deletedAt,
  });

  factory LegitimateGuardian.fromJson(Map<String, dynamic> json) {
    return LegitimateGuardian(
      id: json['id'] != null ? (json['id'] is int ? json['id'] : int.tryParse(json['id'].toString()) ?? 0) : 0,
      serialNumber: json['serial_number'] ?? '',
      firstName: json['first_name'] ?? '',
      fatherName: json['father_name'] ?? '',
      grandfatherName: json['grandfather_name'] ?? '',
      familyName: json['family_name'] ?? '',
      greatGrandfatherName: json['great_grandfather_name'] ?? null,
      nickname: json['nickname'] ?? null,
      mainDistrictId: json['main_district_id'] != null ? (json['main_district_id'] is int ? json['main_district_id'] : int.tryParse(json['main_district_id'].toString()) ?? null) : null,
      birthDate: json['birth_date'] ?? '',
      birthPlace: json['birth_place'] ?? '',
      phoneNumber: json['phone_number'] ?? '',
      homePhone: json['home_phone'] ?? null,
      address: json['address'] ?? null,
      personalPhoto: json['personal_photo'] ?? null,
      proofType: json['proof_type'] ?? '',
      proofNumber: json['proof_number'] ?? '',
      issuingAuthority: json['issuing_authority'] ?? '',
      issueDate: json['issue_date'] ?? '',
      expiryDate: json['expiry_date'] ?? '',
      qualification: json['qualification'] ?? null,
      job: json['job'] ?? null,
      workplace: json['workplace'] ?? null,
      specializationAreas: json['specialization_areas'] ?? null,
      ministerialDecisionNumber: json['ministerial_decision_number'] ?? null,
      ministerialDecisionDate: json['ministerial_decision_date'] ?? null,
      licenseNumber: json['license_number'] ?? null,
      licenseIssueDate: json['license_issue_date'] ?? null,
      licenseExpiryDate: json['license_expiry_date'] ?? null,
      professionCardNumber: json['profession_card_number'] ?? null,
      professionCardIssueDate: json['profession_card_issue_date'] ?? null,
      professionCardExpiryDate: json['profession_card_expiry_date'] ?? null,
      employmentStatus: json['employment_status'] ?? '',
      stopReason: json['stop_reason'] ?? null,
      stopDate: json['stop_date'] ?? null,
      notes: json['notes'] ?? null,
      specializationAreaId: json['specialization_area_id'] != null ? (json['specialization_area_id'] is int ? json['specialization_area_id'] : int.tryParse(json['specialization_area_id'].toString()) ?? null) : null,
      createdAt: json['created_at'] ?? null,
      updatedAt: json['updated_at'] ?? null,
      userId: json['User id'] != null ? (json['User id'] is int ? json['User id'] : int.tryParse(json['User id'].toString()) ?? null) : null,
      deletedAt: json['deleted_at'] ?? null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'serial_number': serialNumber,
      'first_name': firstName,
      'father_name': fatherName,
      'grandfather_name': grandfatherName,
      'family_name': familyName,
      'great_grandfather_name': greatGrandfatherName,
      'nickname': nickname,
      'main_district_id': mainDistrictId,
      'birth_date': birthDate,
      'birth_place': birthPlace,
      'phone_number': phoneNumber,
      'home_phone': homePhone,
      'address': address,
      'personal_photo': personalPhoto,
      'proof_type': proofType,
      'proof_number': proofNumber,
      'issuing_authority': issuingAuthority,
      'issue_date': issueDate,
      'expiry_date': expiryDate,
      'qualification': qualification,
      'job': job,
      'workplace': workplace,
      'specialization_areas': specializationAreas,
      'ministerial_decision_number': ministerialDecisionNumber,
      'ministerial_decision_date': ministerialDecisionDate,
      'license_number': licenseNumber,
      'license_issue_date': licenseIssueDate,
      'license_expiry_date': licenseExpiryDate,
      'profession_card_number': professionCardNumber,
      'profession_card_issue_date': professionCardIssueDate,
      'profession_card_expiry_date': professionCardExpiryDate,
      'employment_status': employmentStatus,
      'stop_reason': stopReason,
      'stop_date': stopDate,
      'notes': notes,
      'specialization_area_id': specializationAreaId,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'User id': userId,
      'deleted_at': deletedAt,
    };
  }
}
