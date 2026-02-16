class Inspection {
  final int id;
  final int guardianId;
  final int? evaluationPeriodId;
  final String? inspectionDate;
  final int? inspectorId;
  final int inspectionType;
  final String result;
  final String? findings;
  final String? recommendations;
  final String? nextInspectionDate;
  final int? createdBy;
  final String? createdAt;
  final String? updatedAt;
  final String? deletedAt;

  Inspection({
    required this.id,
    required this.guardianId,
    this.evaluationPeriodId,
    this.inspectionDate,
    this.inspectorId,
    required this.inspectionType,
    required this.result,
    this.findings,
    this.recommendations,
    this.nextInspectionDate,
    this.createdBy,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
  });

  factory Inspection.fromJson(Map<String, dynamic> json) {
    return Inspection(
      id: json['id'] != null ? (json['id'] is int ? json['id'] : int.tryParse(json['id'].toString()) ?? 0) : 0,
      guardianId: json['guardian_id'] != null ? (json['guardian_id'] is int ? json['guardian_id'] : int.tryParse(json['guardian_id'].toString()) ?? 0) : 0,
      evaluationPeriodId: json['evaluation_period_id'] != null ? (json['evaluation_period_id'] is int ? json['evaluation_period_id'] : int.tryParse(json['evaluation_period_id'].toString()) ?? null) : null,
      inspectionDate: json['inspection_date'] ?? null,
      inspectorId: json['inspector_id'] != null ? (json['inspector_id'] is int ? json['inspector_id'] : int.tryParse(json['inspector_id'].toString()) ?? null) : null,
      inspectionType: json['inspection_type'] != null ? (json['inspection_type'] is int ? json['inspection_type'] : int.tryParse(json['inspection_type'].toString()) ?? 0) : 0,
      result: json['result'] ?? '',
      findings: json['findings'] ?? null,
      recommendations: json['recommendations'] ?? null,
      nextInspectionDate: json['next_inspection_date'] ?? null,
      createdBy: json['created_by'] != null ? (json['created_by'] is int ? json['created_by'] : int.tryParse(json['created_by'].toString()) ?? null) : null,
      createdAt: json['created_at'] ?? null,
      updatedAt: json['updated_at'] ?? null,
      deletedAt: json['deleted_at'] ?? null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'guardian_id': guardianId,
      'evaluation_period_id': evaluationPeriodId,
      'inspection_date': inspectionDate,
      'inspector_id': inspectorId,
      'inspection_type': inspectionType,
      'result': result,
      'findings': findings,
      'recommendations': recommendations,
      'next_inspection_date': nextInspectionDate,
      'created_by': createdBy,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'deleted_at': deletedAt,
    };
  }
}
