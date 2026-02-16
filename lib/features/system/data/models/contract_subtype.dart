class ContractSubtype {
  final int id;
  final String name;
  final String code;
  final int? contractTypeId;
  final int? parentId;
  final int level;
  final int sortOrder;
  final bool isActive;
  final String? createdAt;
  final String? updatedAt;
  final String? deletedAt;

  ContractSubtype({
    required this.id,
    required this.name,
    required this.code,
    this.contractTypeId,
    this.parentId,
    required this.level,
    required this.sortOrder,
    required this.isActive,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
  });

  factory ContractSubtype.fromJson(Map<String, dynamic> json) {
    return ContractSubtype(
      id: json['id'] != null ? (json['id'] is int ? json['id'] : int.tryParse(json['id'].toString()) ?? 0) : 0,
      name: json['name'] ?? '',
      code: json['code'] ?? '',
      contractTypeId: json['contract_type_id'] != null ? (json['contract_type_id'] is int ? json['contract_type_id'] : int.tryParse(json['contract_type_id'].toString()) ?? null) : null,
      parentId: json['parent_id'] != null ? (json['parent_id'] is int ? json['parent_id'] : int.tryParse(json['parent_id'].toString()) ?? null) : null,
      level: json['level'] != null ? (json['level'] is int ? json['level'] : int.tryParse(json['level'].toString()) ?? 0) : 0,
      sortOrder: json['sort_order'] != null ? (json['sort_order'] is int ? json['sort_order'] : int.tryParse(json['sort_order'].toString()) ?? 0) : 0,
      isActive: json['is_active'] == 1 || json['is_active'] == true || json['is_active'] == '1',
      createdAt: json['created_at'] ?? null,
      updatedAt: json['updated_at'] ?? null,
      deletedAt: json['deleted_at'] ?? null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'code': code,
      'contract_type_id': contractTypeId,
      'parent_id': parentId,
      'level': level,
      'sort_order': sortOrder,
      'is_active': isActive,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'deleted_at': deletedAt,
    };
  }
}
