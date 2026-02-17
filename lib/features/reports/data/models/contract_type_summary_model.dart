class ContractTypeSummaryItem {
  final int count;
  final double fees;
  final double penalties;

  ContractTypeSummaryItem({
    required this.count,
    required this.fees,
    required this.penalties,
  });

  factory ContractTypeSummaryItem.fromJson(Map<String, dynamic> json) {
    return ContractTypeSummaryItem(
      count: json['count'] ?? 0,
      fees: (json['fees'] ?? 0).toDouble(),
      penalties: (json['penalties'] ?? 0).toDouble(),
    );
  }
}

class ContractTypeInfo {
  final int id;
  final String name;
  final String code;

  ContractTypeInfo({required this.id, required this.name, required this.code});

  factory ContractTypeInfo.fromJson(Map<String, dynamic> json) {
    return ContractTypeInfo(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      code: json['code'] ?? '',
    );
  }
}

class ContractTypeSummaryModel {
  final int year;
  final List<ContractTypeInfo> contractTypes;
  // Map<PeriodName, Map<ContractTypeId, Stats>>
  final Map<String, Map<String, ContractTypeSummaryItem>> periods;

  ContractTypeSummaryModel({
    required this.year,
    required this.contractTypes,
    required this.periods,
  });

  factory ContractTypeSummaryModel.fromJson(Map<String, dynamic> json) {
    var periodsJson = json['periods'] as Map<String, dynamic>? ?? {};
    Map<String, Map<String, ContractTypeSummaryItem>> parsedPeriods = {};

    periodsJson.forEach((key, value) {
      if (value is Map) {
        Map<String, ContractTypeSummaryItem> innerMap = {};
        value.forEach((k, v) {
          innerMap[k.toString()] = ContractTypeSummaryItem.fromJson(v);
        });
        parsedPeriods[key] = innerMap;
      }
    });

    return ContractTypeSummaryModel(
      year: json['year'] ?? 0,
      contractTypes:
          (json['contract_types'] as List?)
              ?.map((e) => ContractTypeInfo.fromJson(e))
              .toList() ??
          [],
      periods: parsedPeriods,
    );
  }
}
