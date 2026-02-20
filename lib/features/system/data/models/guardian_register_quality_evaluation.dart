class GuardianRegisterQualityEvaluation {
  final int id;
  final int guardianId;
  final int evaluationPeriodId;
  final String registerType;
  final double organizationScore;
  final double wordingScore;
  final double officialFormsScore;
  final double territorialJurisdictionScore;
  final double dataCompletenessScore;
  final double notaryOfficeAnnotationScore;
  final double recordCleanlinessScore;
  final double documentTextScore;
  final double appearanceScore;
  final double handwritingScore;
  final double totalScore;
  final double maxScore;
  final String? createdAt;
  final String? updatedAt;

  GuardianRegisterQualityEvaluation({
    required this.id,
    required this.guardianId,
    required this.evaluationPeriodId,
    required this.registerType,
    required this.organizationScore,
    required this.wordingScore,
    required this.officialFormsScore,
    required this.territorialJurisdictionScore,
    required this.dataCompletenessScore,
    required this.notaryOfficeAnnotationScore,
    required this.recordCleanlinessScore,
    required this.documentTextScore,
    required this.appearanceScore,
    required this.handwritingScore,
    required this.totalScore,
    required this.maxScore,
    this.createdAt,
    this.updatedAt,
  });

  factory GuardianRegisterQualityEvaluation.fromJson(
    Map<String, dynamic> json,
  ) {
    return GuardianRegisterQualityEvaluation(
      id: json['id'] != null
          ? (json['id'] is int
                ? json['id']
                : int.tryParse(json['id'].toString()) ?? 0)
          : 0,
      guardianId: json['guardian_id'] != null
          ? (json['guardian_id'] is int
                ? json['guardian_id']
                : int.tryParse(json['guardian_id'].toString()) ?? 0)
          : 0,
      evaluationPeriodId: json['evaluation_period_id'] != null
          ? (json['evaluation_period_id'] is int
                ? json['evaluation_period_id']
                : int.tryParse(json['evaluation_period_id'].toString()) ?? 0)
          : 0,
      registerType: json['register_type'] ?? '',
      organizationScore: json['organization_score'] != null
          ? (json['organization_score'] is num
                ? json['organization_score'].toDouble()
                : double.tryParse(json['organization_score'].toString()) ?? 0.0)
          : 0.0,
      wordingScore: json['wording_score'] != null
          ? (json['wording_score'] is num
                ? json['wording_score'].toDouble()
                : double.tryParse(json['wording_score'].toString()) ?? 0.0)
          : 0.0,
      officialFormsScore: json['official_forms_score'] != null
          ? (json['official_forms_score'] is num
                ? json['official_forms_score'].toDouble()
                : double.tryParse(json['official_forms_score'].toString()) ??
                      0.0)
          : 0.0,
      territorialJurisdictionScore:
          json['territorial_jurisdiction_score'] != null
          ? (json['territorial_jurisdiction_score'] is num
                ? json['territorial_jurisdiction_score'].toDouble()
                : double.tryParse(
                        json['territorial_jurisdiction_score'].toString(),
                      ) ??
                      0.0)
          : 0.0,
      dataCompletenessScore: json['data_completeness_score'] != null
          ? (json['data_completeness_score'] is num
                ? json['data_completeness_score'].toDouble()
                : double.tryParse(json['data_completeness_score'].toString()) ??
                      0.0)
          : 0.0,
      notaryOfficeAnnotationScore:
          json['notary_office_annotation_score'] != null
          ? (json['notary_office_annotation_score'] is num
                ? json['notary_office_annotation_score'].toDouble()
                : double.tryParse(
                        json['notary_office_annotation_score'].toString(),
                      ) ??
                      0.0)
          : 0.0,
      recordCleanlinessScore: json['record_cleanliness_score'] != null
          ? (json['record_cleanliness_score'] is num
                ? json['record_cleanliness_score'].toDouble()
                : double.tryParse(
                        json['record_cleanliness_score'].toString(),
                      ) ??
                      0.0)
          : 0.0,
      documentTextScore: json['document_text_score'] != null
          ? (json['document_text_score'] is num
                ? json['document_text_score'].toDouble()
                : double.tryParse(json['document_text_score'].toString()) ??
                      0.0)
          : 0.0,
      appearanceScore: json['appearance_score'] != null
          ? (json['appearance_score'] is num
                ? json['appearance_score'].toDouble()
                : double.tryParse(json['appearance_score'].toString()) ?? 0.0)
          : 0.0,
      handwritingScore: json['handwriting_score'] != null
          ? (json['handwriting_score'] is num
                ? json['handwriting_score'].toDouble()
                : double.tryParse(json['handwriting_score'].toString()) ?? 0.0)
          : 0.0,
      totalScore: json['total_score'] != null
          ? (json['total_score'] is num
                ? json['total_score'].toDouble()
                : double.tryParse(json['total_score'].toString()) ?? 0.0)
          : 0.0,
      maxScore: json['max_score'] != null
          ? (json['max_score'] is num
                ? json['max_score'].toDouble()
                : double.tryParse(json['max_score'].toString()) ?? 0.0)
          : 0.0,
      createdAt: json['created_at'] ?? null,
      updatedAt: json['updated_at'] ?? null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'guardian_id': guardianId,
      'evaluation_period_id': evaluationPeriodId,
      'register_type': registerType,
      'organization_score': organizationScore,
      'wording_score': wordingScore,
      'official_forms_score': officialFormsScore,
      'territorial_jurisdiction_score': territorialJurisdictionScore,
      'data_completeness_score': dataCompletenessScore,
      'notary_office_annotation_score': notaryOfficeAnnotationScore,
      'record_cleanliness_score': recordCleanlinessScore,
      'document_text_score': documentTextScore,
      'appearance_score': appearanceScore,
      'handwriting_score': handwritingScore,
      'total_score': totalScore,
      'max_score': maxScore,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }
}
