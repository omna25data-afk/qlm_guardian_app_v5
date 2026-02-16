class GuardianDisciplinarySummary {
  final int id;
  final int guardianId;
  final int evaluationPeriodId;
  final int violationsCount;
  final int complaintsCount;
  final int warningsCount;
  final int noticesCount;
  final int finesCount;
  final int finalJudgmentsAgainstCount;
  final int temporarySuspensionsCount;
  final int otherSanctionsCount;
  final int forgeryCasesCount;
  final int disciplinaryCouncilReferralsCount;
  final int prosecutionReferralsCount;
  final int otherCount;
  final int totalActions;
  final String? createdAt;
  final String? updatedAt;

  GuardianDisciplinarySummary({
    required this.id,
    required this.guardianId,
    required this.evaluationPeriodId,
    required this.violationsCount,
    required this.complaintsCount,
    required this.warningsCount,
    required this.noticesCount,
    required this.finesCount,
    required this.finalJudgmentsAgainstCount,
    required this.temporarySuspensionsCount,
    required this.otherSanctionsCount,
    required this.forgeryCasesCount,
    required this.disciplinaryCouncilReferralsCount,
    required this.prosecutionReferralsCount,
    required this.otherCount,
    required this.totalActions,
    this.createdAt,
    this.updatedAt,
  });

  factory GuardianDisciplinarySummary.fromJson(Map<String, dynamic> json) {
    return GuardianDisciplinarySummary(
      id: json['id'] != null ? (json['id'] is int ? json['id'] : int.tryParse(json['id'].toString()) ?? 0) : 0,
      guardianId: json['guardian_id'] != null ? (json['guardian_id'] is int ? json['guardian_id'] : int.tryParse(json['guardian_id'].toString()) ?? 0) : 0,
      evaluationPeriodId: json['evaluation_period_id'] != null ? (json['evaluation_period_id'] is int ? json['evaluation_period_id'] : int.tryParse(json['evaluation_period_id'].toString()) ?? 0) : 0,
      violationsCount: json['violations_count'] != null ? (json['violations_count'] is int ? json['violations_count'] : int.tryParse(json['violations_count'].toString()) ?? 0) : 0,
      complaintsCount: json['complaints_count'] != null ? (json['complaints_count'] is int ? json['complaints_count'] : int.tryParse(json['complaints_count'].toString()) ?? 0) : 0,
      warningsCount: json['warnings_count'] != null ? (json['warnings_count'] is int ? json['warnings_count'] : int.tryParse(json['warnings_count'].toString()) ?? 0) : 0,
      noticesCount: json['notices_count'] != null ? (json['notices_count'] is int ? json['notices_count'] : int.tryParse(json['notices_count'].toString()) ?? 0) : 0,
      finesCount: json['fines_count'] != null ? (json['fines_count'] is int ? json['fines_count'] : int.tryParse(json['fines_count'].toString()) ?? 0) : 0,
      finalJudgmentsAgainstCount: json['final_judgments_against_count'] != null ? (json['final_judgments_against_count'] is int ? json['final_judgments_against_count'] : int.tryParse(json['final_judgments_against_count'].toString()) ?? 0) : 0,
      temporarySuspensionsCount: json['temporary_suspensions_count'] != null ? (json['temporary_suspensions_count'] is int ? json['temporary_suspensions_count'] : int.tryParse(json['temporary_suspensions_count'].toString()) ?? 0) : 0,
      otherSanctionsCount: json['other_sanctions_count'] != null ? (json['other_sanctions_count'] is int ? json['other_sanctions_count'] : int.tryParse(json['other_sanctions_count'].toString()) ?? 0) : 0,
      forgeryCasesCount: json['forgery_cases_count'] != null ? (json['forgery_cases_count'] is int ? json['forgery_cases_count'] : int.tryParse(json['forgery_cases_count'].toString()) ?? 0) : 0,
      disciplinaryCouncilReferralsCount: json['disciplinary_council_referrals_count'] != null ? (json['disciplinary_council_referrals_count'] is int ? json['disciplinary_council_referrals_count'] : int.tryParse(json['disciplinary_council_referrals_count'].toString()) ?? 0) : 0,
      prosecutionReferralsCount: json['prosecution_referrals_count'] != null ? (json['prosecution_referrals_count'] is int ? json['prosecution_referrals_count'] : int.tryParse(json['prosecution_referrals_count'].toString()) ?? 0) : 0,
      otherCount: json['other_count'] != null ? (json['other_count'] is int ? json['other_count'] : int.tryParse(json['other_count'].toString()) ?? 0) : 0,
      totalActions: json['total_actions'] != null ? (json['total_actions'] is int ? json['total_actions'] : int.tryParse(json['total_actions'].toString()) ?? 0) : 0,
      createdAt: json['created_at'] ?? null,
      updatedAt: json['updated_at'] ?? null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'guardian_id': guardianId,
      'evaluation_period_id': evaluationPeriodId,
      'violations_count': violationsCount,
      'complaints_count': complaintsCount,
      'warnings_count': warningsCount,
      'notices_count': noticesCount,
      'fines_count': finesCount,
      'final_judgments_against_count': finalJudgmentsAgainstCount,
      'temporary_suspensions_count': temporarySuspensionsCount,
      'other_sanctions_count': otherSanctionsCount,
      'forgery_cases_count': forgeryCasesCount,
      'disciplinary_council_referrals_count': disciplinaryCouncilReferralsCount,
      'prosecution_referrals_count': prosecutionReferralsCount,
      'other_count': otherCount,
      'total_actions': totalActions,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }
}
