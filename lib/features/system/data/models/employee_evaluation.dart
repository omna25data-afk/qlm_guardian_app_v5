class EmployeeEvaluation {
  final int id;
  final int employeeId;
  final String evaluationDate;
  final int evaluatorId;
  final int performanceRating;
  final int attendanceRating;
  final int qualityRating;
  final int teamworkRating;
  final int? totalScore;
  final String? comments;
  final String? recommendations;
  final String? nextEvaluationDate;
  final String? createdAt;
  final String? updatedAt;
  final String? deletedAt;

  EmployeeEvaluation({
    required this.id,
    required this.employeeId,
    required this.evaluationDate,
    required this.evaluatorId,
    required this.performanceRating,
    required this.attendanceRating,
    required this.qualityRating,
    required this.teamworkRating,
    this.totalScore,
    this.comments,
    this.recommendations,
    this.nextEvaluationDate,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
  });

  factory EmployeeEvaluation.fromJson(Map<String, dynamic> json) {
    return EmployeeEvaluation(
      id: json['id'] != null ? (json['id'] is int ? json['id'] : int.tryParse(json['id'].toString()) ?? 0) : 0,
      employeeId: json['employee_id'] != null ? (json['employee_id'] is int ? json['employee_id'] : int.tryParse(json['employee_id'].toString()) ?? 0) : 0,
      evaluationDate: json['evaluation_date'] ?? '',
      evaluatorId: json['evaluator_id'] != null ? (json['evaluator_id'] is int ? json['evaluator_id'] : int.tryParse(json['evaluator_id'].toString()) ?? 0) : 0,
      performanceRating: json['performance_rating'] != null ? (json['performance_rating'] is int ? json['performance_rating'] : int.tryParse(json['performance_rating'].toString()) ?? 0) : 0,
      attendanceRating: json['attendance_rating'] != null ? (json['attendance_rating'] is int ? json['attendance_rating'] : int.tryParse(json['attendance_rating'].toString()) ?? 0) : 0,
      qualityRating: json['quality_rating'] != null ? (json['quality_rating'] is int ? json['quality_rating'] : int.tryParse(json['quality_rating'].toString()) ?? 0) : 0,
      teamworkRating: json['teamwork_rating'] != null ? (json['teamwork_rating'] is int ? json['teamwork_rating'] : int.tryParse(json['teamwork_rating'].toString()) ?? 0) : 0,
      totalScore: json['total_score'] != null ? (json['total_score'] is int ? json['total_score'] : int.tryParse(json['total_score'].toString()) ?? null) : null,
      comments: json['comments'] ?? null,
      recommendations: json['recommendations'] ?? null,
      nextEvaluationDate: json['next_evaluation_date'] ?? null,
      createdAt: json['created_at'] ?? null,
      updatedAt: json['updated_at'] ?? null,
      deletedAt: json['deleted_at'] ?? null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'employee_id': employeeId,
      'evaluation_date': evaluationDate,
      'evaluator_id': evaluatorId,
      'performance_rating': performanceRating,
      'attendance_rating': attendanceRating,
      'quality_rating': qualityRating,
      'teamwork_rating': teamworkRating,
      'total_score': totalScore,
      'comments': comments,
      'recommendations': recommendations,
      'next_evaluation_date': nextEvaluationDate,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'deleted_at': deletedAt,
    };
  }
}
