import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'form_field_model.g.dart';

@JsonSerializable()
class FormFieldModel extends Equatable {
  final String name;
  final String label;
  final String type; // text, number, date, select, textarea, checkbox
  final bool required;
  final List<String>? options; // For select type
  final String? placeholder;
  @JsonKey(name: 'helper_text')
  final String? helperText;
  @JsonKey(name: 'default_value')
  final dynamic defaultValue;

  const FormFieldModel({
    required this.name,
    required this.label,
    required this.type,
    this.required = false,
    this.options,
    this.placeholder,
    this.helperText,
    this.defaultValue,
  });

  factory FormFieldModel.fromJson(Map<String, dynamic> json) =>
      _$FormFieldModelFromJson(json);

  Map<String, dynamic> toJson() => _$FormFieldModelToJson(this);

  @override
  List<Object?> get props => [
    name,
    label,
    type,
    required,
    options,
    placeholder,
    helperText,
    defaultValue,
  ];
}
