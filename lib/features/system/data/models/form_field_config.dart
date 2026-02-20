class FormFieldConfig {
  final int id;
  final int tableSchemaId;
  final int? contractTypeId;
  final String? subtype1;
  final String? subtype2;
  final String columnName;
  final String fieldLabel;
  final String fieldType;
  final String? placeholder;
  final String? helperText;
  final bool isRequired;
  final bool isVisible;
  final bool isDisabled;
  final String columnSpan;
  final String? sectionName;
  final int sectionOrder;
  final String? sectionIcon;
  final String? wizardStep;
  final int stepOrder;
  final String? badgeColor;
  final String? customConfig;
  final int sortOrder;
  final String? options;
  final String? validationRules;
  final String? conditionalLogic;
  final String? createdAt;
  final String? updatedAt;

  FormFieldConfig({
    required this.id,
    required this.tableSchemaId,
    this.contractTypeId,
    this.subtype1,
    this.subtype2,
    required this.columnName,
    required this.fieldLabel,
    required this.fieldType,
    this.placeholder,
    this.helperText,
    required this.isRequired,
    required this.isVisible,
    required this.isDisabled,
    required this.columnSpan,
    this.sectionName,
    required this.sectionOrder,
    this.sectionIcon,
    this.wizardStep,
    required this.stepOrder,
    this.badgeColor,
    this.customConfig,
    required this.sortOrder,
    this.options,
    this.validationRules,
    this.conditionalLogic,
    this.createdAt,
    this.updatedAt,
  });

  factory FormFieldConfig.fromJson(Map<String, dynamic> json) {
    return FormFieldConfig(
      id: json['id'] != null
          ? (json['id'] is int
                ? json['id']
                : int.tryParse(json['id'].toString()) ?? 0)
          : 0,
      tableSchemaId: json['table_schema_id'] != null
          ? (json['table_schema_id'] is int
                ? json['table_schema_id']
                : int.tryParse(json['table_schema_id'].toString()) ?? 0)
          : 0,
      contractTypeId: json['contract_type_id'] != null
          ? (json['contract_type_id'] is int
                ? json['contract_type_id']
                : int.tryParse(json['contract_type_id'].toString()) ?? null)
          : null,
      subtype1: json['subtype_1'] ?? null,
      subtype2: json['subtype_2'] ?? null,
      columnName: json['column_name'] ?? '',
      fieldLabel: json['field_label'] ?? '',
      fieldType: json['field_type'] ?? '',
      placeholder: json['placeholder'] ?? null,
      helperText: json['helper_text'] ?? null,
      isRequired:
          json['is_required'] == 1 ||
          json['is_required'] == true ||
          json['is_required'] == '1',
      isVisible:
          json['is_visible'] == 1 ||
          json['is_visible'] == true ||
          json['is_visible'] == '1',
      isDisabled:
          json['is_disabled'] == 1 ||
          json['is_disabled'] == true ||
          json['is_disabled'] == '1',
      columnSpan: json['column_span'] ?? '',
      sectionName: json['section_name'] ?? null,
      sectionOrder: json['section_order'] != null
          ? (json['section_order'] is int
                ? json['section_order']
                : int.tryParse(json['section_order'].toString()) ?? 0)
          : 0,
      sectionIcon: json['section_icon'] ?? null,
      wizardStep: json['wizard_step'] ?? null,
      stepOrder: json['step_order'] != null
          ? (json['step_order'] is int
                ? json['step_order']
                : int.tryParse(json['step_order'].toString()) ?? 0)
          : 0,
      badgeColor: json['badge_color'] ?? null,
      customConfig: json['custom_config'] ?? null,
      sortOrder: json['sort_order'] != null
          ? (json['sort_order'] is int
                ? json['sort_order']
                : int.tryParse(json['sort_order'].toString()) ?? 0)
          : 0,
      options: json['options'] ?? null,
      validationRules: json['validation_rules'] ?? null,
      conditionalLogic: json['conditional_logic'] ?? null,
      createdAt: json['created_at'] ?? null,
      updatedAt: json['updated_at'] ?? null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'table_schema_id': tableSchemaId,
      'contract_type_id': contractTypeId,
      'subtype_1': subtype1,
      'subtype_2': subtype2,
      'column_name': columnName,
      'field_label': fieldLabel,
      'field_type': fieldType,
      'placeholder': placeholder,
      'helper_text': helperText,
      'is_required': isRequired,
      'is_visible': isVisible,
      'is_disabled': isDisabled,
      'column_span': columnSpan,
      'section_name': sectionName,
      'section_order': sectionOrder,
      'section_icon': sectionIcon,
      'wizard_step': wizardStep,
      'step_order': stepOrder,
      'badge_color': badgeColor,
      'custom_config': customConfig,
      'sort_order': sortOrder,
      'options': options,
      'validation_rules': validationRules,
      'conditional_logic': conditionalLogic,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }
}
