// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'contract_type_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ContractTypeModel _$ContractTypeModelFromJson(Map<String, dynamic> json) =>
    ContractTypeModel(
      id: ContractTypeModel._parseInt(json['id']),
      name: json['name'] as String,
      icon: json['icon'] as String?,
      description: json['description'] as String?,
      isActive: json['is_active'] as bool? ?? true,
    );

Map<String, dynamic> _$ContractTypeModelToJson(ContractTypeModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'icon': instance.icon,
      'description': instance.description,
      'is_active': instance.isActive,
    };
