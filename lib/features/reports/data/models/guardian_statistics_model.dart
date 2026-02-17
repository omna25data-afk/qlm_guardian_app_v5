class GuardianStatisticsModel {
  final int id;
  final String name;
  final String serialNumber;
  final int totalEntries;
  final double totalFees;
  final double totalPenalties;
  final double totalSupport;
  final double totalSustainability;
  final double totalAmount;
  final Map<String, int> byType;

  GuardianStatisticsModel({
    required this.id,
    required this.name,
    required this.serialNumber,
    required this.totalEntries,
    required this.totalFees,
    required this.totalPenalties,
    required this.totalSupport,
    required this.totalSustainability,
    required this.totalAmount,
    required this.byType,
  });

  factory GuardianStatisticsModel.fromJson(Map<String, dynamic> json) {
    return GuardianStatisticsModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      serialNumber: json['serial_number'] ?? '',
      totalEntries: json['total_entries'] ?? 0,
      totalFees: (json['total_fees'] ?? 0).toDouble(),
      totalPenalties: (json['total_penalties'] ?? 0).toDouble(),
      totalSupport: (json['total_support'] ?? 0).toDouble(),
      totalSustainability: (json['total_sustainability'] ?? 0).toDouble(),
      totalAmount: (json['total_amount'] ?? 0).toDouble(),
      byType: Map<String, int>.from(json['by_type'] ?? {}),
    );
  }
}
