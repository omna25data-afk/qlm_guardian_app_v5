// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_area_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AdminAreaModel _$AdminAreaModelFromJson(Map<String, dynamic> json) =>
    AdminAreaModel(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String,
      type: json['type'] as String,
      parentName: json['parent_name'] as String?,
      childrenCount: (json['children_count'] as num?)?.toInt() ?? 0,
      guardiansCount: (json['guardians_count'] as num?)?.toInt() ?? 0,
      color: json['color'] as String? ?? '#808080',
      icon: json['icon'] as String? ?? '',
      isActive: json['is_active'] as bool? ?? false,
    );

Map<String, dynamic> _$AdminAreaModelToJson(AdminAreaModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'type': instance.type,
      'parent_name': instance.parentName,
      'children_count': instance.childrenCount,
      'guardians_count': instance.guardiansCount,
      'color': instance.color,
      'icon': instance.icon,
      'is_active': instance.isActive,
    };
