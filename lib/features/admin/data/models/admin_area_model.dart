import 'package:json_annotation/json_annotation.dart';

part 'admin_area_model.g.dart';

@JsonSerializable()
class AdminAreaModel {
  final int id;
  final String name;
  @JsonKey(defaultValue: 'area')
  final String type;
  @JsonKey(name: 'parent_name')
  final String? parentName;
  @JsonKey(name: 'children_count', defaultValue: 0)
  final int childrenCount;
  @JsonKey(name: 'guardians_count', defaultValue: 0)
  final int guardiansCount;
  @JsonKey(defaultValue: '#808080')
  final String color;
  @JsonKey(defaultValue: '')
  final String icon;
  @JsonKey(name: 'is_active', defaultValue: false)
  final bool isActive;
  @JsonKey(defaultValue: [])
  final List<AdminAreaModel> children;
  @JsonKey(defaultValue: 0)
  final int level;

  AdminAreaModel({
    required this.id,
    required this.name,
    required this.type,
    this.parentName,
    required this.childrenCount,
    required this.guardiansCount,
    required this.color,
    required this.icon,
    required this.isActive,
    this.children = const [],
    this.level = 0,
  });

  factory AdminAreaModel.fromJson(Map<String, dynamic> json) =>
      _$AdminAreaModelFromJson(json);
  Map<String, dynamic> toJson() => _$AdminAreaModelToJson(this);
}
