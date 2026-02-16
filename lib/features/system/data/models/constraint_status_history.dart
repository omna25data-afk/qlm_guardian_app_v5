class ConstraintStatusHistory {
  final int id;
  final int constraintId;
  final String? fromStatus;
  final String toStatus;
  final int changedBy;
  final String? changeReason;
  final String? createdAt;
  final String? updatedAt;

  ConstraintStatusHistory({
    required this.id,
    required this.constraintId,
    this.fromStatus,
    required this.toStatus,
    required this.changedBy,
    this.changeReason,
    this.createdAt,
    this.updatedAt,
  });

  factory ConstraintStatusHistory.fromJson(Map<String, dynamic> json) {
    return ConstraintStatusHistory(
      id: json['id'] != null ? (json['id'] is int ? json['id'] : int.tryParse(json['id'].toString()) ?? 0) : 0,
      constraintId: json['constraint_id'] != null ? (json['constraint_id'] is int ? json['constraint_id'] : int.tryParse(json['constraint_id'].toString()) ?? 0) : 0,
      fromStatus: json['from_status'] ?? null,
      toStatus: json['to_status'] ?? '',
      changedBy: json['changed_by'] != null ? (json['changed_by'] is int ? json['changed_by'] : int.tryParse(json['changed_by'].toString()) ?? 0) : 0,
      changeReason: json['change_reason'] ?? null,
      createdAt: json['created_at'] ?? null,
      updatedAt: json['updated_at'] ?? null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'constraint_id': constraintId,
      'from_status': fromStatus,
      'to_status': toStatus,
      'changed_by': changedBy,
      'change_reason': changeReason,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }
}
