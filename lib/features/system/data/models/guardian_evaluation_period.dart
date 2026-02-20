class GuardianEvaluationPeriod {
  final int id;
  final int? guardianId;
  final String periodType;
  final String hijriYear;
  final String? periodLabel;
  final String? startDate;
  final String? endDate;
  final String? startDateHijri;
  final String? endDateHijri;
  final String status;
  final int? createdBy;
  final String? notes;
  final String? createdAt;
  final String? updatedAt;

  GuardianEvaluationPeriod({
    required this.id,
    this.guardianId,
    required this.periodType,
    required this.hijriYear,
    this.periodLabel,
    this.startDate,
    this.endDate,
    this.startDateHijri,
    this.endDateHijri,
    required this.status,
    this.createdBy,
    this.notes,
    this.createdAt,
    this.updatedAt,
  });

  factory GuardianEvaluationPeriod.fromJson(Map<String, dynamic> json) {
    return GuardianEvaluationPeriod(
      id: json['id'] != null
          ? (json['id'] is int
                ? json['id']
                : int.tryParse(json['id'].toString()) ?? 0)
          : 0,
      guardianId: json['guardian_id'] != null
          ? (json['guardian_id'] is int
                ? json['guardian_id']
                : int.tryParse(json['guardian_id'].toString()) ?? null)
          : null,
      periodType: json['period_type'] ?? '',
      hijriYear: json['hijri_year'] ?? '',
      periodLabel: json['period_label'] ?? null,
      startDate: json['start_date'] ?? null,
      endDate: json['end_date'] ?? null,
      startDateHijri: json['start_date_hijri'] ?? null,
      endDateHijri: json['end_date_hijri'] ?? null,
      status: json['status'] ?? '',
      createdBy: json['created_by'] != null
          ? (json['created_by'] is int
                ? json['created_by']
                : int.tryParse(json['created_by'].toString()) ?? null)
          : null,
      notes: json['notes'] ?? null,
      createdAt: json['created_at'] ?? null,
      updatedAt: json['updated_at'] ?? null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'guardian_id': guardianId,
      'period_type': periodType,
      'hijri_year': hijriYear,
      'period_label': periodLabel,
      'start_date': startDate,
      'end_date': endDate,
      'start_date_hijri': startDateHijri,
      'end_date_hijri': endDateHijri,
      'status': status,
      'created_by': createdBy,
      'notes': notes,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }
}
