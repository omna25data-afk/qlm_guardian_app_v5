class ImportColumnConfiguration {
  final int id;
  final String importType;
  final String columnName;
  final String displayName;
  final String? description;
  final bool isVisible;
  final bool isRequired;
  final bool isUnique;
  final int order;
  final String dataType;
  final String? validationRules;
  final String? options;
  final String? defaultValue;
  final String? exampleValue;
  final String? format;
  final String? mappingOptions;
  final bool isSearchable;
  final bool isSortable;
  final bool isFilterable;
  final int? width;
  final String alignment;
  final int? userId;
  final bool isDefault;
  final String? createdAt;
  final String? updatedAt;

  ImportColumnConfiguration({
    required this.id,
    required this.importType,
    required this.columnName,
    required this.displayName,
    this.description,
    required this.isVisible,
    required this.isRequired,
    required this.isUnique,
    required this.order,
    required this.dataType,
    this.validationRules,
    this.options,
    this.defaultValue,
    this.exampleValue,
    this.format,
    this.mappingOptions,
    required this.isSearchable,
    required this.isSortable,
    required this.isFilterable,
    this.width,
    required this.alignment,
    this.userId,
    required this.isDefault,
    this.createdAt,
    this.updatedAt,
  });

  factory ImportColumnConfiguration.fromJson(Map<String, dynamic> json) {
    return ImportColumnConfiguration(
      id: json['id'] != null ? (json['id'] is int ? json['id'] : int.tryParse(json['id'].toString()) ?? 0) : 0,
      importType: json['import_type'] ?? '',
      columnName: json['column_name'] ?? '',
      displayName: json['display_name'] ?? '',
      description: json['description'] ?? null,
      isVisible: json['is_visible'] == 1 || json['is_visible'] == true || json['is_visible'] == '1',
      isRequired: json['is_required'] == 1 || json['is_required'] == true || json['is_required'] == '1',
      isUnique: json['is_unique'] == 1 || json['is_unique'] == true || json['is_unique'] == '1',
      order: json['order'] != null ? (json['order'] is int ? json['order'] : int.tryParse(json['order'].toString()) ?? 0) : 0,
      dataType: json['data_type'] ?? '',
      validationRules: json['validation_rules'] ?? null,
      options: json['options'] ?? null,
      defaultValue: json['default_value'] ?? null,
      exampleValue: json['example_value'] ?? null,
      format: json['format'] ?? null,
      mappingOptions: json['mapping_options'] ?? null,
      isSearchable: json['is_searchable'] == 1 || json['is_searchable'] == true || json['is_searchable'] == '1',
      isSortable: json['is_sortable'] == 1 || json['is_sortable'] == true || json['is_sortable'] == '1',
      isFilterable: json['is_filterable'] == 1 || json['is_filterable'] == true || json['is_filterable'] == '1',
      width: json['width'] != null ? (json['width'] is int ? json['width'] : int.tryParse(json['width'].toString()) ?? null) : null,
      alignment: json['alignment'] ?? '',
      userId: json['user_id'] != null ? (json['user_id'] is int ? json['user_id'] : int.tryParse(json['user_id'].toString()) ?? null) : null,
      isDefault: json['is_default'] == 1 || json['is_default'] == true || json['is_default'] == '1',
      createdAt: json['created_at'] ?? null,
      updatedAt: json['updated_at'] ?? null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'import_type': importType,
      'column_name': columnName,
      'display_name': displayName,
      'description': description,
      'is_visible': isVisible,
      'is_required': isRequired,
      'is_unique': isUnique,
      'order': order,
      'data_type': dataType,
      'validation_rules': validationRules,
      'options': options,
      'default_value': defaultValue,
      'example_value': exampleValue,
      'format': format,
      'mapping_options': mappingOptions,
      'is_searchable': isSearchable,
      'is_sortable': isSortable,
      'is_filterable': isFilterable,
      'width': width,
      'alignment': alignment,
      'user_id': userId,
      'is_default': isDefault,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }
}
