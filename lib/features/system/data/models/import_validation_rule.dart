class ImportValidationRule {
  final int id;
  final String importType;
  final String columnName;
  final String ruleType;
  final String? parameters;
  final String? errorMessage;
  final bool isActive;
  final int priority;
  final String? condition;
  final String? metadata;
  final int? userId;
  final bool isSystem;
  final String? createdAt;
  final String? updatedAt;

  ImportValidationRule({
    required this.id,
    required this.importType,
    required this.columnName,
    required this.ruleType,
    this.parameters,
    this.errorMessage,
    required this.isActive,
    required this.priority,
    this.condition,
    this.metadata,
    this.userId,
    required this.isSystem,
    this.createdAt,
    this.updatedAt,
  });

  factory ImportValidationRule.fromJson(Map<String, dynamic> json) {
    return ImportValidationRule(
      id: json['id'] != null
          ? (json['id'] is int
                ? json['id']
                : int.tryParse(json['id'].toString()) ?? 0)
          : 0,
      importType: json['import_type'] ?? '',
      columnName: json['column_name'] ?? '',
      ruleType: json['rule_type'] ?? '',
      parameters: json['parameters'] ?? null,
      errorMessage: json['error_message'] ?? null,
      isActive:
          json['is_active'] == 1 ||
          json['is_active'] == true ||
          json['is_active'] == '1',
      priority: json['priority'] != null
          ? (json['priority'] is int
                ? json['priority']
                : int.tryParse(json['priority'].toString()) ?? 0)
          : 0,
      condition: json['condition'] ?? null,
      metadata: json['metadata'] ?? null,
      userId: json['user_id'] != null
          ? (json['user_id'] is int
                ? json['user_id']
                : int.tryParse(json['user_id'].toString()) ?? null)
          : null,
      isSystem:
          json['is_system'] == 1 ||
          json['is_system'] == true ||
          json['is_system'] == '1',
      createdAt: json['created_at'] ?? null,
      updatedAt: json['updated_at'] ?? null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'import_type': importType,
      'column_name': columnName,
      'rule_type': ruleType,
      'parameters': parameters,
      'error_message': errorMessage,
      'is_active': isActive,
      'priority': priority,
      'condition': condition,
      'metadata': metadata,
      'user_id': userId,
      'is_system': isSystem,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }
}
