import 'package:json_annotation/json_annotation.dart';

part 'admin_assignment_model.g.dart';

@JsonSerializable()
class AdminAssignmentModel {
  final int id;
  @JsonKey(name: 'guardian_name', defaultValue: 'غيـر محدد')
  final String guardianName;
  @JsonKey(name: 'area_name', defaultValue: 'غيـر محدد')
  final String areaName;
  final String type;
  @JsonKey(name: 'type_text')
  final String typeText;
  @JsonKey(name: 'start_date')
  final String? startDate;
  @JsonKey(name: 'end_date')
  final String? endDate;
  final String status;
  @JsonKey(name: 'status_color')
  final String statusColor;
  final String? notes;

  AdminAssignmentModel({
    required this.id,
    required this.guardianName,
    required this.areaName,
    required this.type,
    required this.typeText,
    this.startDate,
    this.endDate,
    required this.status,
    required this.statusColor,
    this.notes,
  });

  factory AdminAssignmentModel.fromJson(Map<String, dynamic> json) =>
      _$AdminAssignmentModelFromJson(json);
  Map<String, dynamic> toJson() => _$AdminAssignmentModelToJson(this);
}
