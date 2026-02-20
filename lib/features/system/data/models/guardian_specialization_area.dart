class GuardianSpecializationArea {
  final int id;
  final int legitimateGuardianId;
  final int geographicAreaId;
  final bool isMain;
  final bool isDirect;
  final bool isAdditional;
  final String? assignmentType;
  final int? assignedBy;
  final String? startDate;
  final String? endDate;
  final String? notes;
  final String? createdAt;
  final String? updatedAt;

  GuardianSpecializationArea({
    required this.id,
    required this.legitimateGuardianId,
    required this.geographicAreaId,
    required this.isMain,
    required this.isDirect,
    required this.isAdditional,
    this.assignmentType,
    this.assignedBy,
    this.startDate,
    this.endDate,
    this.notes,
    this.createdAt,
    this.updatedAt,
  });

  factory GuardianSpecializationArea.fromJson(Map<String, dynamic> json) {
    return GuardianSpecializationArea(
      id: json['id'] != null
          ? (json['id'] is int
                ? json['id']
                : int.tryParse(json['id'].toString()) ?? 0)
          : 0,
      legitimateGuardianId: json['legitimate_guardian_id'] != null
          ? (json['legitimate_guardian_id'] is int
                ? json['legitimate_guardian_id']
                : int.tryParse(json['legitimate_guardian_id'].toString()) ?? 0)
          : 0,
      geographicAreaId: json['geographic_area_id'] != null
          ? (json['geographic_area_id'] is int
                ? json['geographic_area_id']
                : int.tryParse(json['geographic_area_id'].toString()) ?? 0)
          : 0,
      isMain:
          json['is_main'] == 1 ||
          json['is_main'] == true ||
          json['is_main'] == '1',
      isDirect:
          json['is_direct'] == 1 ||
          json['is_direct'] == true ||
          json['is_direct'] == '1',
      isAdditional:
          json['is_additional'] == 1 ||
          json['is_additional'] == true ||
          json['is_additional'] == '1',
      assignmentType: json['assignment_type'] ?? null,
      assignedBy: json['assigned_by'] != null
          ? (json['assigned_by'] is int
                ? json['assigned_by']
                : int.tryParse(json['assigned_by'].toString()) ?? null)
          : null,
      startDate: json['start_date'] ?? null,
      endDate: json['end_date'] ?? null,
      notes: json['notes'] ?? null,
      createdAt: json['created_at'] ?? null,
      updatedAt: json['updated_at'] ?? null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'legitimate_guardian_id': legitimateGuardianId,
      'geographic_area_id': geographicAreaId,
      'is_main': isMain,
      'is_direct': isDirect,
      'is_additional': isAdditional,
      'assignment_type': assignmentType,
      'assigned_by': assignedBy,
      'start_date': startDate,
      'end_date': endDate,
      'notes': notes,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }
}
