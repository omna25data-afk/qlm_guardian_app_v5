class FormFieldConfigModel {
  final int id;
  final int tableSchemaId;
  final String? tableSchemaName;
  final int? contractTypeId;
  final String contractTypeName;
  final String columnName;
  final String fieldLabel;
  final String fieldType;
  final bool isRequired;
  final bool isVisible;
  final bool isDisabled;
  final String? sectionName;
  final int sectionOrder;
  final int sortOrder;

  FormFieldConfigModel({
    required this.id,
    required this.tableSchemaId,
    this.tableSchemaName,
    this.contractTypeId,
    required this.contractTypeName,
    required this.columnName,
    required this.fieldLabel,
    required this.fieldType,
    required this.isRequired,
    required this.isVisible,
    required this.isDisabled,
    this.sectionName,
    required this.sectionOrder,
    required this.sortOrder,
  });

  factory FormFieldConfigModel.fromJson(Map<String, dynamic> json) {
    return FormFieldConfigModel(
      id: json['id'],
      tableSchemaId: json['table_schema_id'],
      tableSchemaName: json['table_schema_name'],
      contractTypeId: json['contract_type_id'],
      contractTypeName: json['contract_type_name'],
      columnName: json['column_name'],
      fieldLabel: json['field_label'],
      fieldType: json['field_type'],
      isRequired: json['is_required'] == 1 || json['is_required'] == true,
      isVisible: json['is_visible'] == 1 || json['is_visible'] == true,
      isDisabled: json['is_disabled'] == 1 || json['is_disabled'] == true,
      sectionName: json['section_name'],
      sectionOrder: json['section_order'] ?? 0,
      sortOrder: json['sort_order'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'table_schema_id': tableSchemaId,
      'table_schema_name': tableSchemaName,
      'contract_type_id': contractTypeId,
      'contract_type_name': contractTypeName,
      'column_name': columnName,
      'field_label': fieldLabel,
      'field_type': fieldType,
      'is_required': isRequired,
      'is_visible': isVisible,
      'is_disabled': isDisabled,
      'section_name': sectionName,
      'section_order': sectionOrder,
      'sort_order': sortOrder,
    };
  }
}
