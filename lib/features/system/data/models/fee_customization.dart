class FeeCustomization {
  final int id;
  final int? contractTypeId;
  final String? writerType;
  final int? constraintTypeId;
  final String constraintType;
  final String feeType;
  final String feeName;
  final double? baseAmount;
  final double? percentageRate;
  final double? maxAmount;
  final String calculationBasis;
  final String? distributionRules;
  final String? taxRules;
  final String? penaltyRules;
  final String? supportRules;
  final double? sustainabilityFee;
  final String? conditions;
  final bool isActive;
  final String effectiveDate;
  final String? expiryDate;
  final int createdBy;
  final String? createdAt;
  final String? updatedAt;
  final String? deletedAt;

  FeeCustomization({
    required this.id,
    this.contractTypeId,
    this.writerType,
    this.constraintTypeId,
    required this.constraintType,
    required this.feeType,
    required this.feeName,
    this.baseAmount,
    this.percentageRate,
    this.maxAmount,
    required this.calculationBasis,
    this.distributionRules,
    this.taxRules,
    this.penaltyRules,
    this.supportRules,
    this.sustainabilityFee,
    this.conditions,
    required this.isActive,
    required this.effectiveDate,
    this.expiryDate,
    required this.createdBy,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
  });

  factory FeeCustomization.fromJson(Map<String, dynamic> json) {
    return FeeCustomization(
      id: json['id'] != null ? (json['id'] is int ? json['id'] : int.tryParse(json['id'].toString()) ?? 0) : 0,
      contractTypeId: json['contract_type_id'] != null ? (json['contract_type_id'] is int ? json['contract_type_id'] : int.tryParse(json['contract_type_id'].toString()) ?? null) : null,
      writerType: json['writer_type'] ?? null,
      constraintTypeId: json['constraint_type_id'] != null ? (json['constraint_type_id'] is int ? json['constraint_type_id'] : int.tryParse(json['constraint_type_id'].toString()) ?? null) : null,
      constraintType: json['constraint_type'] ?? '',
      feeType: json['fee_type'] ?? '',
      feeName: json['fee_name'] ?? '',
      baseAmount: json['base_amount'] != null ? (json['base_amount'] is num ? json['base_amount'].toDouble() : double.tryParse(json['base_amount'].toString()) ?? null) : null,
      percentageRate: json['percentage_rate'] != null ? (json['percentage_rate'] is num ? json['percentage_rate'].toDouble() : double.tryParse(json['percentage_rate'].toString()) ?? null) : null,
      maxAmount: json['max_amount'] != null ? (json['max_amount'] is num ? json['max_amount'].toDouble() : double.tryParse(json['max_amount'].toString()) ?? null) : null,
      calculationBasis: json['calculation_basis'] ?? '',
      distributionRules: json['distribution_rules'] ?? null,
      taxRules: json['tax_rules'] ?? null,
      penaltyRules: json['penalty_rules'] ?? null,
      supportRules: json['support_rules'] ?? null,
      sustainabilityFee: json['sustainability_fee'] != null ? (json['sustainability_fee'] is num ? json['sustainability_fee'].toDouble() : double.tryParse(json['sustainability_fee'].toString()) ?? null) : null,
      conditions: json['conditions'] ?? null,
      isActive: json['is_active'] == 1 || json['is_active'] == true || json['is_active'] == '1',
      effectiveDate: json['effective_date'] ?? '',
      expiryDate: json['expiry_date'] ?? null,
      createdBy: json['created_by'] != null ? (json['created_by'] is int ? json['created_by'] : int.tryParse(json['created_by'].toString()) ?? 0) : 0,
      createdAt: json['created_at'] ?? null,
      updatedAt: json['updated_at'] ?? null,
      deletedAt: json['deleted_at'] ?? null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'contract_type_id': contractTypeId,
      'writer_type': writerType,
      'constraint_type_id': constraintTypeId,
      'constraint_type': constraintType,
      'fee_type': feeType,
      'fee_name': feeName,
      'base_amount': baseAmount,
      'percentage_rate': percentageRate,
      'max_amount': maxAmount,
      'calculation_basis': calculationBasis,
      'distribution_rules': distributionRules,
      'tax_rules': taxRules,
      'penalty_rules': penaltyRules,
      'support_rules': supportRules,
      'sustainability_fee': sustainabilityFee,
      'conditions': conditions,
      'is_active': isActive,
      'effective_date': effectiveDate,
      'expiry_date': expiryDate,
      'created_by': createdBy,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'deleted_at': deletedAt,
    };
  }
}
