class TableSchema {
  final int id;
  final String name;
  final String label;
  final String? description;
  final String modelClass;
  final bool isCentral;
  final bool isActive;
  final int sortOrder;
  final String? createdAt;
  final String? updatedAt;

  TableSchema({
    required this.id,
    required this.name,
    required this.label,
    this.description,
    required this.modelClass,
    required this.isCentral,
    required this.isActive,
    required this.sortOrder,
    this.createdAt,
    this.updatedAt,
  });

  factory TableSchema.fromJson(Map<String, dynamic> json) {
    return TableSchema(
      id: json['id'] != null ? (json['id'] is int ? json['id'] : int.tryParse(json['id'].toString()) ?? 0) : 0,
      name: json['name'] ?? '',
      label: json['label'] ?? '',
      description: json['description'] ?? null,
      modelClass: json['model_class'] ?? '',
      isCentral: json['is_central'] == 1 || json['is_central'] == true || json['is_central'] == '1',
      isActive: json['is_active'] == 1 || json['is_active'] == true || json['is_active'] == '1',
      sortOrder: json['sort_order'] != null ? (json['sort_order'] is int ? json['sort_order'] : int.tryParse(json['sort_order'].toString()) ?? 0) : 0,
      createdAt: json['created_at'] ?? null,
      updatedAt: json['updated_at'] ?? null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'label': label,
      'description': description,
      'model_class': modelClass,
      'is_central': isCentral,
      'is_active': isActive,
      'sort_order': sortOrder,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }
}
