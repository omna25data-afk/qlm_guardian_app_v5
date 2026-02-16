class GuardianBehaviourIndicator {
  final int id;
  final int guardianId;
  final int evaluationPeriodId;
  final String indicatorCode;
  final String indicatorName;
  final int occurrencesCount;
  final double? score;
  final String? createdAt;
  final String? updatedAt;

  GuardianBehaviourIndicator({
    required this.id,
    required this.guardianId,
    required this.evaluationPeriodId,
    required this.indicatorCode,
    required this.indicatorName,
    required this.occurrencesCount,
    this.score,
    this.createdAt,
    this.updatedAt,
  });

  factory GuardianBehaviourIndicator.fromJson(Map<String, dynamic> json) {
    return GuardianBehaviourIndicator(
      id: json['id'] != null ? (json['id'] is int ? json['id'] : int.tryParse(json['id'].toString()) ?? 0) : 0,
      guardianId: json['guardian_id'] != null ? (json['guardian_id'] is int ? json['guardian_id'] : int.tryParse(json['guardian_id'].toString()) ?? 0) : 0,
      evaluationPeriodId: json['evaluation_period_id'] != null ? (json['evaluation_period_id'] is int ? json['evaluation_period_id'] : int.tryParse(json['evaluation_period_id'].toString()) ?? 0) : 0,
      indicatorCode: json['indicator_code'] ?? '',
      indicatorName: json['indicator_name'] ?? '',
      occurrencesCount: json['occurrences_count'] != null ? (json['occurrences_count'] is int ? json['occurrences_count'] : int.tryParse(json['occurrences_count'].toString()) ?? 0) : 0,
      score: json['score'] != null ? (json['score'] is num ? json['score'].toDouble() : double.tryParse(json['score'].toString()) ?? null) : null,
      createdAt: json['created_at'] ?? null,
      updatedAt: json['updated_at'] ?? null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'guardian_id': guardianId,
      'evaluation_period_id': evaluationPeriodId,
      'indicator_code': indicatorCode,
      'indicator_name': indicatorName,
      'occurrences_count': occurrencesCount,
      'score': score,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }
}
