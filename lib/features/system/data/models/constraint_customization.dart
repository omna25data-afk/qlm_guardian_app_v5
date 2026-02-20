class ConstraintCustomization {
  final int id;
  final int? constraintTypeId;
  final String constraintType;
  final String fieldName;
  final String fieldLabel;
  final String fieldType;
  final String? fieldOptions;
  final bool isRequired;
  final bool isVisible;
  final int displayOrder;
  final String? validationRules;
  final String? defaultValue;
  final String fieldGroup;
  final String appliesTo;
  final int createdBy;
  final bool isActive;
  final String? createdAt;
  final String? updatedAt;
  final String? deletedAt;

  ConstraintCustomization({
    required this.id,
    this.constraintTypeId,
    required this.constraintType,
    required this.fieldName,
    required this.fieldLabel,
    required this.fieldType,
    this.fieldOptions,
    required this.isRequired,
    required this.isVisible,
    required this.displayOrder,
    this.validationRules,
    this.defaultValue,
    required this.fieldGroup,
    required this.appliesTo,
    required this.createdBy,
    required this.isActive,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
  });

  factory ConstraintCustomization.fromJson(Map<String, dynamic> json) {
    return ConstraintCustomization(
      id: json['id'] != null
          ? (json['id'] is int
                ? json['id']
                : int.tryParse(json['id'].toString()) ?? 0)
          : 0,
      constraintTypeId: json['constraint_type_id'] != null
          ? (json['constraint_type_id'] is int
                ? json['constraint_type_id']
                : int.tryParse(json['constraint_type_id'].toString()) ?? null)
          : null,
      constraintType: json['constraint_type'] ?? '',
      fieldName: json['field_name'] ?? '',
      fieldLabel: json['field_label'] ?? '',
      fieldType: json['field_type'] ?? '',
      fieldOptions: json['field_options'] ?? null,
      isRequired:
          json['is_required'] == 1 ||
          json['is_required'] == true ||
          json['is_required'] == '1',
      isVisible:
          json['is_visible'] == 1 ||
          json['is_visible'] == true ||
          json['is_visible'] == '1',
      displayOrder: json['display_order'] != null
          ? (json['display_order'] is int
                ? json['display_order']
                : int.tryParse(json['display_order'].toString()) ?? 0)
          : 0,
      validationRules: json['validation_rules'] ?? null,
      defaultValue: json['default_value'] ?? null,
      fieldGroup: json['field_group'] ?? '',
      appliesTo: json['applies_to'] ?? '',
      createdBy: json['created_by'] != null
          ? (json['created_by'] is int
                ? json['created_by']
                : int.tryParse(json['created_by'].toString()) ?? 0)
          : 0,
      isActive:
          json['is_active'] == 1 ||
          json['is_active'] == true ||
          json['is_active'] == '1',
      createdAt: json['created_at'] ?? null,
      updatedAt: json['updated_at'] ?? null,
      deletedAt: json['deleted_at'] ?? null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'constraint_type_id': constraintTypeId,
      'constraint_type': constraintType,
      'field_name': fieldName,
      'field_label': fieldLabel,
      'field_type': fieldType,
      'field_options': fieldOptions,
      'is_required': isRequired,
      'is_visible': isVisible,
      'display_order': displayOrder,
      'validation_rules': validationRules,
      'default_value': defaultValue,
      'field_group': fieldGroup,
      'applies_to': appliesTo,
      'created_by': createdBy,
      'is_active': isActive,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'deleted_at': deletedAt,
    };
  }
}
