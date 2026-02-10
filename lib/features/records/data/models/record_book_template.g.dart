// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'record_book_template.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RecordBookTemplate _$RecordBookTemplateFromJson(Map<String, dynamic> json) =>
    RecordBookTemplate(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String? ?? '',
      totalPages: (json['total_pages'] as num?)?.toInt() ?? 100,
      constraintsPerPage: (json['constraints_per_page'] as num?)?.toInt() ?? 10,
      description: json['description'] as String?,
    );

Map<String, dynamic> _$RecordBookTemplateToJson(RecordBookTemplate instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'total_pages': instance.totalPages,
      'constraints_per_page': instance.constraintsPerPage,
      'description': instance.description,
    };
