class GuardianAssignment {
  final int id;
  final int assignedGuardianId;
  final int originalGuardianId;
  final int geographicAreaId;
  final int? assignedBy;
  final String assignmentType;
  final String startDate;
  final String? endDate;
  final String? reason;
  final bool isActive;
  final String? notes;
  final String? createdAt;
  final String? updatedAt;

  GuardianAssignment({
    required this.id,
    required this.assignedGuardianId,
    required this.originalGuardianId,
    required this.geographicAreaId,
    this.assignedBy,
    required this.assignmentType,
    required this.startDate,
    this.endDate,
    this.reason,
    required this.isActive,
    this.notes,
    this.createdAt,
    this.updatedAt,
  });

  factory GuardianAssignment.fromJson(Map<String, dynamic> json) {
    return GuardianAssignment(
      id: json['id'] != null ? (json['id'] is int ? json['id'] : int.tryParse(json['id'].toString()) ?? 0) : 0,
      assignedGuardianId: json['assigned_guardian_id'] != null ? (json['assigned_guardian_id'] is int ? json['assigned_guardian_id'] : int.tryParse(json['assigned_guardian_id'].toString()) ?? 0) : 0,
      originalGuardianId: json['original_guardian_id'] != null ? (json['original_guardian_id'] is int ? json['original_guardian_id'] : int.tryParse(json['original_guardian_id'].toString()) ?? 0) : 0,
      geographicAreaId: json['geographic_area_id'] != null ? (json['geographic_area_id'] is int ? json['geographic_area_id'] : int.tryParse(json['geographic_area_id'].toString()) ?? 0) : 0,
      assignedBy: json['assigned_by'] != null ? (json['assigned_by'] is int ? json['assigned_by'] : int.tryParse(json['assigned_by'].toString()) ?? null) : null,
      assignmentType: json['assignment_type'] ?? '',
      startDate: json['start_date'] ?? '',
      endDate: json['end_date'] ?? null,
      reason: json['reason'] ?? null,
      isActive: json['is_active'] == 1 || json['is_active'] == true || json['is_active'] == '1',
      notes: json['notes'] ?? null,
      createdAt: json['created_at'] ?? null,
      updatedAt: json['updated_at'] ?? null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'assigned_guardian_id': assignedGuardianId,
      'original_guardian_id': originalGuardianId,
      'geographic_area_id': geographicAreaId,
      'assigned_by': assignedBy,
      'assignment_type': assignmentType,
      'start_date': startDate,
      'end_date': endDate,
      'reason': reason,
      'is_active': isActive,
      'notes': notes,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }
}
