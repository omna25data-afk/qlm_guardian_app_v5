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
      helperText: json['helper_text'] as String?,
      defaultValue: json['default_value'],
      subtype1: json['subtype_1'],
      subtype2: json['subtype_2'],
    );

Map<String, dynamic> _$FormFieldModelToJson(FormFieldModel instance) =>
    <String, dynamic>{
      'name': instance.name,
      'label': instance.label,
      'type': instance.type,
      'required': instance.required,
      'options': instance.options,
      'placeholder': instance.placeholder,
      'helper_text': instance.helperText,
      'default_value': instance.defaultValue,
      'subtype_1': instance.subtype1,
      'subtype_2': instance.subtype2,
    };
