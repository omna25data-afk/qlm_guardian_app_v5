class ContractType {
  final int id;
  final String name;
  final String? nameEn;
  final String? description;
  final String code;
  final String? settings;
  final bool isActive;
  final int sortOrder;
  final String? category;
  final double? defaultFee;
  final String? requiredDocuments;
  final String? validationRules;
  final String? formSchema;
  final String? createdAt;
  final String? updatedAt;
  final String? deletedAt;
  final int? constraintTypeId;

  ContractType({
    required this.id,
    required this.name,
    this.nameEn,
    this.description,
    required this.code,
    this.settings,
    required this.isActive,
    required this.sortOrder,
    this.category,
    this.defaultFee,
    this.requiredDocuments,
    this.validationRules,
    this.formSchema,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
    this.constraintTypeId,
  });

  factory ContractType.fromJson(Map<String, dynamic> json) {
    return ContractType(
      id: json['id'] != null
          ? (json['id'] is int
                ? json['id']
                : int.tryParse(json['id'].toString()) ?? 0)
          : 0,
      name: json['name'] ?? '',
      nameEn: json['name_en'] ?? null,
      description: json['description'] ?? null,
      code: json['code'] ?? '',
      settings: json['settings'] ?? null,
      isActive:
          json['is_active'] == 1 ||
          json['is_active'] == true ||
          json['is_active'] == '1',
      sortOrder: json['sort_order'] != null
          ? (json['sort_order'] is int
                ? json['sort_order']
                : int.tryParse(json['sort_order'].toString()) ?? 0)
          : 0,
      category: json['category'] ?? null,
      defaultFee: json['default_fee'] != null
          ? (json['default_fee'] is num
                ? json['default_fee'].toDouble()
                : double.tryParse(json['default_fee'].toString()) ?? null)
          : null,
      requiredDocuments: json['required_documents'] ?? null,
      validationRules: json['validation_rules'] ?? null,
      formSchema: json['form_schema'] ?? null,
      createdAt: json['created_at'] ?? null,
      updatedAt: json['updated_at'] ?? null,
      deletedAt: json['deleted_at'] ?? null,
      constraintTypeId: json['constraint_type_id'] != null
          ? (json['constraint_type_id'] is int
                ? json['constraint_type_id']
                : int.tryParse(json['constraint_type_id'].toString()) ?? null)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'name_en': nameEn,
      'description': description,
      'code': code,
      'settings': settings,
      'is_active': isActive,
      'sort_order': sortOrder,
      'category': category,
      'default_fee': defaultFee,
      'required_documents': requiredDocuments,
      'validation_rules': validationRules,
      'form_schema': formSchema,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'deleted_at': deletedAt,
      'constraint_type_id': constraintTypeId,
    };
  }
}
