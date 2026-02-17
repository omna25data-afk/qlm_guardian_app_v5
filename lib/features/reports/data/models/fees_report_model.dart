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
      contractTypeId: json['id'] ?? 0,
      contractTypeName: json['name'] ?? '',
      contractTypeCode: json['code'] ?? '',
      count: json['count'] ?? 0,
      fees: (json['fees'] ?? 0).toDouble(),
      penalties: (json['penalties'] ?? 0).toDouble(),
      support: (json['support'] ?? 0).toDouble(),
      sustainability: (json['sustainability'] ?? 0).toDouble(),
      total: (json['total'] ?? 0).toDouble(),
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
      count: json['count'] ?? 0,
      fees: (json['fees'] ?? 0).toDouble(),
      penalties: (json['penalties'] ?? 0).toDouble(),
      support: (json['support'] ?? 0).toDouble(),
      sustainability: (json['sustainability'] ?? 0).toDouble(),
      total: (json['total'] ?? 0).toDouble(),
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
