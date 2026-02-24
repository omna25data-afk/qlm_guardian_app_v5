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
  originalGuardianId: (json['original_guardian_id'] as num?)?.toInt(),
  assignedGuardianId: (json['assigned_guardian_id'] as num?)?.toInt(),
  assignmentType: json['assignment_type'] as String?,
  type: json['type'] as String,
  typeText: json['type_text'] as String,
  startDate: json['start_date'] as String?,
  endDate: json['end_date'] as String?,
  status: json['status'] as String,
  statusColor: json['status_color'] as String,
  reason: json['reason'] as String?,
  isActive: json['is_active'] as bool?,
  notes: json['notes'] as String?,
);

Map<String, dynamic> _$AdminAssignmentModelToJson(
  AdminAssignmentModel instance,
) => <String, dynamic>{
  'id': instance.id,
  'guardian_name': instance.guardianName,
  'area_name': instance.areaName,
  'original_guardian_id': instance.originalGuardianId,
  'assigned_guardian_id': instance.assignedGuardianId,
  'assignment_type': instance.assignmentType,
  'type': instance.type,
  'type_text': instance.typeText,
  'start_date': instance.startDate,
  'end_date': instance.endDate,
  'status': instance.status,
  'status_color': instance.statusColor,
  'reason': instance.reason,
  'is_active': instance.isActive,
  'notes': instance.notes,
};
