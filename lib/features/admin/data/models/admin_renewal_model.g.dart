// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_renewal_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AdminRenewalModel _$AdminRenewalModelFromJson(Map<String, dynamic> json) =>
    AdminRenewalModel(
      id: (json['id'] as num).toInt(),
      guardianName: json['guardian_name'] as String? ?? 'غير معروف',
      renewalDate: json['renewal_date'] as String? ?? '',
      status: json['status'] as String? ?? '',
      statusColor: json['status_color'] as String? ?? 'grey',
      type: json['type'] as String? ?? '',
    );

Map<String, dynamic> _$AdminRenewalModelToJson(AdminRenewalModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'guardian_name': instance.guardianName,
      'renewal_date': instance.renewalDate,
      'status': instance.status,
      'status_color': instance.statusColor,
      'type': instance.type,
    };
