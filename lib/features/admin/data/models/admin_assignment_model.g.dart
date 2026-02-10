// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_assignment_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AdminAssignmentModel _$AdminAssignmentModelFromJson(
  Map<String, dynamic> json,
) => AdminAssignmentModel(
  id: (json['id'] as num).toInt(),
  guardianName: json['guardian_name'] as String? ?? 'غيـر محدد',
  areaName: json['area_name'] as String? ?? 'غيـر محدد',
  type: json['type'] as String,
  typeText: json['type_text'] as String,
  startDate: json['start_date'] as String?,
  endDate: json['end_date'] as String?,
  status: json['status'] as String,
  statusColor: json['status_color'] as String,
  notes: json['notes'] as String?,
);

Map<String, dynamic> _$AdminAssignmentModelToJson(
  AdminAssignmentModel instance,
) => <String, dynamic>{
  'id': instance.id,
  'guardian_name': instance.guardianName,
  'area_name': instance.areaName,
  'type': instance.type,
  'type_text': instance.typeText,
  'start_date': instance.startDate,
  'end_date': instance.endDate,
  'status': instance.status,
  'status_color': instance.statusColor,
  'notes': instance.notes,
};
