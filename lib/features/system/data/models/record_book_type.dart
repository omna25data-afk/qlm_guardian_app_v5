class RecordBookType {
  final int id;
  final int? contractTypeId;
  final String name;
  final String code;
  final String category;
  final String? descriptionAr;
  final String? descriptionEn;
  final String? icon;
  final String? color;
  final bool isDefault;
  final int sortOrder;
  final String? description;
  final bool isActive;
  final String? createdAt;
  final String? updatedAt;
  final String? deletedAt;
  final int? constraintTypeId;

  RecordBookType({
    required this.id,
    this.contractTypeId,
    required this.name,
    required this.code,
    required this.category,
    this.descriptionAr,
    this.descriptionEn,
    this.icon,
    this.color,
    required this.isDefault,
    required this.sortOrder,
    this.description,
    required this.isActive,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
    this.constraintTypeId,
  });

  factory RecordBookType.fromJson(Map<String, dynamic> json) {
    return RecordBookType(
      id: json['id'] != null
          ? (json['id'] is int
                ? json['id']
                : int.tryParse(json['id'].toString()) ?? 0)
          : 0,
      contractTypeId: json['contract_type_id'] != null
          ? (json['contract_type_id'] is int
                ? json['contract_type_id']
                : int.tryParse(json['contract_type_id'].toString()) ?? null)
          : null,
      name: json['name'] ?? '',
      code: json['code'] ?? '',
      category: json['category'] ?? '',
      descriptionAr: json['description_ar'] ?? null,
      descriptionEn: json['description_en'] ?? null,
      icon: json['icon'] ?? null,
      color: json['color'] ?? null,
      isDefault:
          json['is_default'] == 1 ||
          json['is_default'] == true ||
          json['is_default'] == '1',
      sortOrder: json['sort_order'] != null
          ? (json['sort_order'] is int
                ? json['sort_order']
                : int.tryParse(json['sort_order'].toString()) ?? 0)
          : 0,
      description: json['description'] ?? null,
      isActive:
          json['is_active'] == 1 ||
          json['is_active'] == true ||
          json['is_active'] == '1',
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
      'contract_type_id': contractTypeId,
      'name': name,
      'code': code,
      'category': category,
      'description_ar': descriptionAr,
      'description_en': descriptionEn,
      'icon': icon,
      'color': color,
      'is_default': isDefault,
      'sort_order': sortOrder,
      'description': description,
      'is_active': isActive,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'deleted_at': deletedAt,
      'constraint_type_id': constraintTypeId,
    };
  }
}
