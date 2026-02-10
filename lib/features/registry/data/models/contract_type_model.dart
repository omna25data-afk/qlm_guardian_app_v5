import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'contract_type_model.g.dart';

@JsonSerializable()
class ContractTypeModel extends Equatable {
  final int id;
  final String name;
  final String? icon;
  final String? description;
  @JsonKey(name: 'is_active')
  final bool isActive;

  const ContractTypeModel({
    required this.id,
    required this.name,
    this.icon,
    this.description,
    this.isActive = true,
  });

  factory ContractTypeModel.fromJson(Map<String, dynamic> json) =>
      _$ContractTypeModelFromJson(json);

  Map<String, dynamic> toJson() => _$ContractTypeModelToJson(this);

  @override
  List<Object?> get props => [id, name, icon, description, isActive];
}
