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
      id: int.tryParse(json['id']?.toString() ?? '0') ?? 0,
      name: json['name']?.toString() ?? '',
      serialNumber: json['serial_number']?.toString() ?? '',
      totalEntries: int.tryParse(json['total_entries']?.toString() ?? '0') ?? 0,
      totalFees: double.tryParse(json['total_fees']?.toString() ?? '0') ?? 0.0,
      totalPenalties:
          double.tryParse(json['total_penalties']?.toString() ?? '0') ?? 0.0,
      totalSupport:
          double.tryParse(json['total_support']?.toString() ?? '0') ?? 0.0,
      totalSustainability:
          double.tryParse(json['total_sustainability']?.toString() ?? '0') ??
          0.0,
      totalAmount:
          double.tryParse(json['total_amount']?.toString() ?? '0') ?? 0.0,
      byType: Map<String, int>.from(json['by_type'] ?? {}),
    );
  }
}
