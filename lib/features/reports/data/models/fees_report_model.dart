class FeesReportItem {
  final int contractTypeId;
  final String contractTypeName;
  final String contractTypeCode;
  final int count;
  final double fees;
  final double penalties;
  final double support;
  final double sustainability;
  final double total;

  FeesReportItem({
    required this.contractTypeId,
    required this.contractTypeName,
    required this.contractTypeCode,
    required this.count,
    required this.fees,
    required this.penalties,
    required this.support,
    required this.sustainability,
    required this.total,
  });

  factory FeesReportItem.fromJson(Map<String, dynamic> json) {
    return FeesReportItem(
      contractTypeId: int.tryParse(json['id']?.toString() ?? '0') ?? 0,
      contractTypeName: json['name']?.toString() ?? '',
      contractTypeCode: json['code']?.toString() ?? '',
      count: int.tryParse(json['count']?.toString() ?? '0') ?? 0,
      fees: double.tryParse(json['fees']?.toString() ?? '0') ?? 0.0,
      penalties: double.tryParse(json['penalties']?.toString() ?? '0') ?? 0.0,
      support: double.tryParse(json['support']?.toString() ?? '0') ?? 0.0,
      sustainability:
          double.tryParse(json['sustainability']?.toString() ?? '0') ?? 0.0,
      total: double.tryParse(json['total']?.toString() ?? '0') ?? 0.0,
    );
  }
}

class FeesReportSummary {
  final int count;
  final double fees;
  final double penalties;
  final double support;
  final double sustainability;
  final double total;

  FeesReportSummary({
    required this.count,
    required this.fees,
    required this.penalties,
    required this.support,
    required this.sustainability,
    required this.total,
  });

  factory FeesReportSummary.fromJson(Map<String, dynamic> json) {
    return FeesReportSummary(
      count: int.tryParse(json['count']?.toString() ?? '0') ?? 0,
      fees: double.tryParse(json['fees']?.toString() ?? '0') ?? 0.0,
      penalties: double.tryParse(json['penalties']?.toString() ?? '0') ?? 0.0,
      support: double.tryParse(json['support']?.toString() ?? '0') ?? 0.0,
      sustainability:
          double.tryParse(json['sustainability']?.toString() ?? '0') ?? 0.0,
      total: double.tryParse(json['total']?.toString() ?? '0') ?? 0.0,
    );
  }
}

class FeesReportModel {
  final int year;
  final String periodType;
  final String? periodValue;
  final List<FeesReportItem> items;
  final FeesReportSummary totals;

  FeesReportModel({
    required this.year,
    required this.periodType,
    this.periodValue,
    required this.items,
    required this.totals,
  });

  factory FeesReportModel.fromJson(Map<String, dynamic> json) {
    var data = json['data'] ?? json; // Handle wrapped or unwrapped response
    return FeesReportModel(
      year: int.tryParse(data['year'].toString()) ?? 0,
      periodType: data['period_type'] ?? 'annual',
      periodValue: data['period_value'],
      items:
          (data['by_contract_type'] as List?)
              ?.map((e) => FeesReportItem.fromJson(e))
              .toList() ??
          [],
      totals: FeesReportSummary.fromJson(data['totals'] ?? {}),
    );
  }
}
