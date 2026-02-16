class Customization {
  final int id;
  final String customizationType;
  final String name;
  final String? description;
  final String? settings;
  final bool isActive;
  final int? createdBy;
  final String appliesTo;
  final String? targetType;
  final int? targetId;
  final int? contractTypeId;
  final int displayOrder;
  final String? createdAt;
  final String? updatedAt;
  final String? deletedAt;

  Customization({
    required this.id,
    required this.customizationType,
    required this.name,
    this.description,
    this.settings,
    required this.isActive,
    this.createdBy,
    required this.appliesTo,
    this.targetType,
    this.targetId,
    this.contractTypeId,
    required this.displayOrder,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
  });

  factory Customization.fromJson(Map<String, dynamic> json) {
    return Customization(
      id: json['id'] != null ? (json['id'] is int ? json['id'] : int.tryParse(json['id'].toString()) ?? 0) : 0,
      customizationType: json['customization_type'] ?? '',
      name: json['name'] ?? '',
      description: json['description'] ?? null,
      settings: json['settings'] ?? null,
      isActive: json['is_active'] == 1 || json['is_active'] == true || json['is_active'] == '1',
      createdBy: json['created_by'] != null ? (json['created_by'] is int ? json['created_by'] : int.tryParse(json['created_by'].toString()) ?? null) : null,
      appliesTo: json['applies_to'] ?? '',
      targetType: json['target_type'] ?? null,
      targetId: json['target_id'] != null ? (json['target_id'] is int ? json['target_id'] : int.tryParse(json['target_id'].toString()) ?? null) : null,
      contractTypeId: json['contract_type_id'] != null ? (json['contract_type_id'] is int ? json['contract_type_id'] : int.tryParse(json['contract_type_id'].toString()) ?? null) : null,
      displayOrder: json['display_order'] != null ? (json['display_order'] is int ? json['display_order'] : int.tryParse(json['display_order'].toString()) ?? 0) : 0,
      createdAt: json['created_at'] ?? null,
      updatedAt: json['updated_at'] ?? null,
      deletedAt: json['deleted_at'] ?? null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'customization_type': customizationType,
      'name': name,
      'description': description,
      'settings': settings,
      'is_active': isActive,
      'created_by': createdBy,
      'applies_to': appliesTo,
      'target_type': targetType,
      'target_id': targetId,
      'contract_type_id': contractTypeId,
      'display_order': displayOrder,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'deleted_at': deletedAt,
    };
  }
}
