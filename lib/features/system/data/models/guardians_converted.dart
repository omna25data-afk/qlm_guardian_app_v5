class GuardiansConverted {
  final String? firstName;
  final String? fatherName;
  final String? grandfatherName;
  final String? familyName;
  final String? greatGrandfatherName;
  final String? birthDate;
  final String? birthPlace;
  final String? phoneNumber;
  final int? homePhone;
  final String? address;
  final String? proofType;
  final String? proofNumber;
  final String? issuingAuthority;
  final String? issueDate;
  final String? expiryDate;
  final String? qualification;
  final String? job;
  final String? workplace;
  final String? licenseNumber;
  final String? licenseIssueDate;
  final String? licenseExpiryDate;
  final String? professionCardNumber;
  final String? professionCardIssueDate;
  final String? professionCardExpiryDate;
  final String? employmentStatus;
  final String? stopReason;
  final String? stopDate;
  final String? notes;
  final String? specializationAreaName;

  GuardiansConverted({
    this.firstName,
    this.fatherName,
    this.grandfatherName,
    this.familyName,
    this.greatGrandfatherName,
    this.birthDate,
    this.birthPlace,
    this.phoneNumber,
    this.homePhone,
    this.address,
    this.proofType,
    this.proofNumber,
    this.issuingAuthority,
    this.issueDate,
    this.expiryDate,
    this.qualification,
    this.job,
    this.workplace,
    this.licenseNumber,
    this.licenseIssueDate,
    this.licenseExpiryDate,
    this.professionCardNumber,
    this.professionCardIssueDate,
    this.professionCardExpiryDate,
    this.employmentStatus,
    this.stopReason,
    this.stopDate,
    this.notes,
    this.specializationAreaName,
  });

  factory GuardiansConverted.fromJson(Map<String, dynamic> json) {
    return GuardiansConverted(
      firstName: json['first_name'] ?? null,
      fatherName: json['father_name'] ?? null,
      grandfatherName: json['grandfather_name'] ?? null,
      familyName: json['family_name'] ?? null,
      greatGrandfatherName: json['great_grandfather_name'] ?? null,
      birthDate: json['birth_date'] ?? null,
      birthPlace: json['birth_place'] ?? null,
      phoneNumber: json['phone_number'] ?? null,
      homePhone: json['home_phone'] != null ? (json['home_phone'] is int ? json['home_phone'] : int.tryParse(json['home_phone'].toString()) ?? null) : null,
      address: json['address'] ?? null,
      proofType: json['proof_type'] ?? null,
      proofNumber: json['proof_number'] ?? null,
      issuingAuthority: json['issuing_authority'] ?? null,
      issueDate: json['issue_date'] ?? null,
      expiryDate: json['expiry_date'] ?? null,
      qualification: json['qualification'] ?? null,
      job: json['job'] ?? null,
      workplace: json['workplace'] ?? null,
      licenseNumber: json['license_number'] ?? null,
      licenseIssueDate: json['license_issue_date'] ?? null,
      licenseExpiryDate: json['license_expiry_date'] ?? null,
      professionCardNumber: json['profession_card_number'] ?? null,
      professionCardIssueDate: json['profession_card_issue_date'] ?? null,
      professionCardExpiryDate: json['profession_card_expiry_date'] ?? null,
      employmentStatus: json['employment_status'] ?? null,
      stopReason: json['stop_reason'] ?? null,
      stopDate: json['stop_date'] ?? null,
      notes: json['notes'] ?? null,
      specializationAreaName: json['specialization_area_name'] ?? null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'first_name': firstName,
      'father_name': fatherName,
      'grandfather_name': grandfatherName,
      'family_name': familyName,
      'great_grandfather_name': greatGrandfatherName,
      'birth_date': birthDate,
      'birth_place': birthPlace,
      'phone_number': phoneNumber,
      'home_phone': homePhone,
      'address': address,
      'proof_type': proofType,
      'proof_number': proofNumber,
      'issuing_authority': issuingAuthority,
      'issue_date': issueDate,
      'expiry_date': expiryDate,
      'qualification': qualification,
      'job': job,
      'workplace': workplace,
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
      'specialization_area_name': specializationAreaName,
    };
  }
}
