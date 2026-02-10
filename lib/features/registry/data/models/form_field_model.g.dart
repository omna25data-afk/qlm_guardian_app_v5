// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'form_field_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FormFieldModel _$FormFieldModelFromJson(Map<String, dynamic> json) =>
    FormFieldModel(
      name: json['name'] as String,
      label: json['label'] as String,
      type: json['type'] as String,
      required: json['required'] as bool? ?? false,
      options: (json['options'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      placeholder: json['placeholder'] as String?,
      defaultValue: json['default_value'],
    );

Map<String, dynamic> _$FormFieldModelToJson(FormFieldModel instance) =>
    <String, dynamic>{
      'name': instance.name,
      'label': instance.label,
      'type': instance.type,
      'required': instance.required,
      'options': instance.options,
      'placeholder': instance.placeholder,
      'default_value': instance.defaultValue,
    };
