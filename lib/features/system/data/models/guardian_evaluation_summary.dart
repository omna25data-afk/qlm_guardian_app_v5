class GuardianEvaluationSummary {
  final int id;
  final int guardianId;
  final int evaluationPeriodId;
  final double? registersSummaryScore;
  final double? salesRegisterScore;
  final double? licenseRenewalComplianceScore;
  final double? reputationBehaviorScore;
  final double? dutiesComplianceScore;
  final double? totalScore;
  final String? finalRating;
  final String? summaryNotes;
  final int? approvedBy;
  final String? approvedAt;
  final String? createdAt;
  final String? updatedAt;

  GuardianEvaluationSummary({
    required this.id,
    required this.guardianId,
    required this.evaluationPeriodId,
    this.registersSummaryScore,
    this.salesRegisterScore,
    this.licenseRenewalComplianceScore,
    this.reputationBehaviorScore,
    this.dutiesComplianceScore,
    this.totalScore,
    this.finalRating,
    this.summaryNotes,
    this.approvedBy,
    this.approvedAt,
    this.createdAt,
    this.updatedAt,
  });

  factory GuardianEvaluationSummary.fromJson(Map<String, dynamic> json) {
    return GuardianEvaluationSummary(
      id: json['id'] != null ? (json['id'] is int ? json['id'] : int.tryParse(json['id'].toString()) ?? 0) : 0,
      guardianId: json['guardian_id'] != null ? (json['guardian_id'] is int ? json['guardian_id'] : int.tryParse(json['guardian_id'].toString()) ?? 0) : 0,
      evaluationPeriodId: json['evaluation_period_id'] != null ? (json['evaluation_period_id'] is int ? json['evaluation_period_id'] : int.tryParse(json['evaluation_period_id'].toString()) ?? 0) : 0,
      registersSummaryScore: json['registers_summary_score'] != null ? (json['registers_summary_score'] is num ? json['registers_summary_score'].toDouble() : double.tryParse(json['registers_summary_score'].toString()) ?? null) : null,
      salesRegisterScore: json['sales_register_score'] != null ? (json['sales_register_score'] is num ? json['sales_register_score'].toDouble() : double.tryParse(json['sales_register_score'].toString()) ?? null) : null,
      licenseRenewalComplianceScore: json['license_renewal_compliance_score'] != null ? (json['license_renewal_compliance_score'] is num ? json['license_renewal_compliance_score'].toDouble() : double.tryParse(json['license_renewal_compliance_score'].toString()) ?? null) : null,
      reputationBehaviorScore: json['reputation_behavior_score'] != null ? (json['reputation_behavior_score'] is num ? json['reputation_behavior_score'].toDouble() : double.tryParse(json['reputation_behavior_score'].toString()) ?? null) : null,
      dutiesComplianceScore: json['duties_compliance_score'] != null ? (json['duties_compliance_score'] is num ? json['duties_compliance_score'].toDouble() : double.tryParse(json['duties_compliance_score'].toString()) ?? null) : null,
      totalScore: json['total_score'] != null ? (json['total_score'] is num ? json['total_score'].toDouble() : double.tryParse(json['total_score'].toString()) ?? null) : null,
      finalRating: json['final_rating'] ?? null,
      summaryNotes: json['summary_notes'] ?? null,
      approvedBy: json['approved_by'] != null ? (json['approved_by'] is int ? json['approved_by'] : int.tryParse(json['approved_by'].toString()) ?? null) : null,
      approvedAt: json['approved_at'] ?? null,
      createdAt: json['created_at'] ?? null,
      updatedAt: json['updated_at'] ?? null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'guardian_id': guardianId,
      'evaluation_period_id': evaluationPeriodId,
      'registers_summary_score': registersSummaryScore,
      'sales_register_score': salesRegisterScore,
      'license_renewal_compliance_score': licenseRenewalComplianceScore,
      'reputation_behavior_score': reputationBehaviorScore,
      'duties_compliance_score': dutiesComplianceScore,
      'total_score': totalScore,
      'final_rating': finalRating,
      'summary_notes': summaryNotes,
      'approved_by': approvedBy,
      'approved_at': approvedAt,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }
}
