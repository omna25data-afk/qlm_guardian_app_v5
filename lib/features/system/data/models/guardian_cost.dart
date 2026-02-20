class GuardianCost {
  final int id;
  final int guardianId;
  final String costType;
  final double amount;
  final String date;
  final String? description;
  final int? approvedBy;
  final String paymentStatus;
  final String? paymentDate;
  final String? createdAt;
  final String? updatedAt;
  final String? deletedAt;

  GuardianCost({
    required this.id,
    required this.guardianId,
    required this.costType,
    required this.amount,
    required this.date,
    this.description,
    this.approvedBy,
    required this.paymentStatus,
    this.paymentDate,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
  });

  factory GuardianCost.fromJson(Map<String, dynamic> json) {
    return GuardianCost(
      id: json['id'] != null
          ? (json['id'] is int
                ? json['id']
                : int.tryParse(json['id'].toString()) ?? 0)
          : 0,
      guardianId: json['guardian_id'] != null
          ? (json['guardian_id'] is int
                ? json['guardian_id']
                : int.tryParse(json['guardian_id'].toString()) ?? 0)
          : 0,
      costType: json['cost_type'] ?? '',
      amount: json['amount'] != null
          ? (json['amount'] is num
                ? json['amount'].toDouble()
                : double.tryParse(json['amount'].toString()) ?? 0.0)
          : 0.0,
      date: json['date'] ?? '',
      description: json['description'] ?? null,
      approvedBy: json['approved_by'] != null
          ? (json['approved_by'] is int
                ? json['approved_by']
                : int.tryParse(json['approved_by'].toString()) ?? null)
          : null,
      paymentStatus: json['payment_status'] ?? '',
      paymentDate: json['payment_date'] ?? null,
      createdAt: json['created_at'] ?? null,
      updatedAt: json['updated_at'] ?? null,
      deletedAt: json['deleted_at'] ?? null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'guardian_id': guardianId,
      'cost_type': costType,
      'amount': amount,
      'date': date,
      'description': description,
      'approved_by': approvedBy,
      'payment_status': paymentStatus,
      'payment_date': paymentDate,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'deleted_at': deletedAt,
    };
  }
}
