class RecordBookTemplate {
  final int id;
  final int recordBookTypeId;
  final int? contractTypeId;
  final String name;
  final String code;
  final String usageCategory;
  final int totalPages;
  final int constraintsPerPage;
  final int defaultStartConstraintNumber;
  final int? defaultEndConstraintNumber;
  final String? defaultFormNumber;
  final String? description;
  final bool isActive;
  final int sortOrder;
  final String? createdAt;
  final String? updatedAt;
  final String? deletedAt;

  RecordBookTemplate({
    required this.id,
    required this.recordBookTypeId,
    this.contractTypeId,
    required this.name,
    required this.code,
    required this.usageCategory,
    required this.totalPages,
    required this.constraintsPerPage,
    required this.defaultStartConstraintNumber,
    this.defaultEndConstraintNumber,
    this.defaultFormNumber,
    this.description,
    required this.isActive,
    required this.sortOrder,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
  });

  factory RecordBookTemplate.fromJson(Map<String, dynamic> json) {
    return RecordBookTemplate(
      id: json['id'] != null ? (json['id'] is int ? json['id'] : int.tryParse(json['id'].toString()) ?? 0) : 0,
      recordBookTypeId: json['record_book_type_id'] != null ? (json['record_book_type_id'] is int ? json['record_book_type_id'] : int.tryParse(json['record_book_type_id'].toString()) ?? 0) : 0,
      contractTypeId: json['contract_type_id'] != null ? (json['contract_type_id'] is int ? json['contract_type_id'] : int.tryParse(json['contract_type_id'].toString()) ?? null) : null,
      name: json['name'] ?? '',
      code: json['code'] ?? '',
      usageCategory: json['usage_category'] ?? '',
      totalPages: json['total_pages'] != null ? (json['total_pages'] is int ? json['total_pages'] : int.tryParse(json['total_pages'].toString()) ?? 0) : 0,
      constraintsPerPage: json['constraints_per_page'] != null ? (json['constraints_per_page'] is int ? json['constraints_per_page'] : int.tryParse(json['constraints_per_page'].toString()) ?? 0) : 0,
      defaultStartConstraintNumber: json['default_start_constraint_number'] != null ? (json['default_start_constraint_number'] is int ? json['default_start_constraint_number'] : int.tryParse(json['default_start_constraint_number'].toString()) ?? 0) : 0,
      defaultEndConstraintNumber: json['default_end_constraint_number'] != null ? (json['default_end_constraint_number'] is int ? json['default_end_constraint_number'] : int.tryParse(json['default_end_constraint_number'].toString()) ?? null) : null,
      defaultFormNumber: json['default_form_number'] ?? null,
      description: json['description'] ?? null,
      isActive: json['is_active'] == 1 || json['is_active'] == true || json['is_active'] == '1',
      sortOrder: json['sort_order'] != null ? (json['sort_order'] is int ? json['sort_order'] : int.tryParse(json['sort_order'].toString()) ?? 0) : 0,
      createdAt: json['created_at'] ?? null,
      updatedAt: json['updated_at'] ?? null,
      deletedAt: json['deleted_at'] ?? null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'record_book_type_id': recordBookTypeId,
      'contract_type_id': contractTypeId,
      'name': name,
      'code': code,
      'usage_category': usageCategory,
      'total_pages': totalPages,
      'constraints_per_page': constraintsPerPage,
      'default_start_constraint_number': defaultStartConstraintNumber,
      'default_end_constraint_number': defaultEndConstraintNumber,
      'default_form_number': defaultFormNumber,
      'description': description,
      'is_active': isActive,
      'sort_order': sortOrder,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'deleted_at': deletedAt,
    };
  }
}
