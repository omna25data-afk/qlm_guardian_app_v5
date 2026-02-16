class EmployeeCost {
  final int id;
  final int employeeId;
  final String costType;
  final double amount;
  final String date;
  final String? description;
  final int? approvedBy;
  final String? createdAt;
  final String? updatedAt;
  final String? deletedAt;

  EmployeeCost({
    required this.id,
    required this.employeeId,
    required this.costType,
    required this.amount,
    required this.date,
    this.description,
    this.approvedBy,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
  });

  factory EmployeeCost.fromJson(Map<String, dynamic> json) {
    return EmployeeCost(
      id: json['id'] != null ? (json['id'] is int ? json['id'] : int.tryParse(json['id'].toString()) ?? 0) : 0,
      employeeId: json['employee_id'] != null ? (json['employee_id'] is int ? json['employee_id'] : int.tryParse(json['employee_id'].toString()) ?? 0) : 0,
      costType: json['cost_type'] ?? '',
      amount: json['amount'] != null ? (json['amount'] is num ? json['amount'].toDouble() : double.tryParse(json['amount'].toString()) ?? 0.0) : 0.0,
      date: json['date'] ?? '',
      description: json['description'] ?? null,
      approvedBy: json['approved_by'] != null ? (json['approved_by'] is int ? json['approved_by'] : int.tryParse(json['approved_by'].toString()) ?? null) : null,
      createdAt: json['created_at'] ?? null,
      updatedAt: json['updated_at'] ?? null,
      deletedAt: json['deleted_at'] ?? null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'employee_id': employeeId,
      'cost_type': costType,
      'amount': amount,
      'date': date,
      'description': description,
      'approved_by': approvedBy,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'deleted_at': deletedAt,
    };
  }
}
