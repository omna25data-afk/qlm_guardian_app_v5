// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_notification_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AppNotificationModel _$AppNotificationModelFromJson(
  Map<String, dynamic> json,
) => AppNotificationModel(
  id: json['id'] as String,
  type: json['type'] as String,
  notifiableType: json['notifiable_type'] as String,
  notifiableId: (json['notifiable_id'] as num).toInt(),
  data: json['data'] as Map<String, dynamic>,
  readAt: json['read_at'] == null
      ? null
      : DateTime.parse(json['read_at'] as String),
  createdAt: DateTime.parse(json['created_at'] as String),
  updatedAt: DateTime.parse(json['updated_at'] as String),
);

Map<String, dynamic> _$AppNotificationModelToJson(
  AppNotificationModel instance,
) => <String, dynamic>{
  'id': instance.id,
  'type': instance.type,
  'notifiable_type': instance.notifiableType,
  'notifiable_id': instance.notifiableId,
  'data': instance.data,
  'read_at': instance.readAt?.toIso8601String(),
  'created_at': instance.createdAt.toIso8601String(),
  'updated_at': instance.updatedAt.toIso8601String(),
};
