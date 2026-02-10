// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'registry_entry_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RegistryEntryModel _$RegistryEntryModelFromJson(Map<String, dynamic> json) =>
    RegistryEntryModel(
      id: (json['id'] as num?)?.toInt(),
      uuid: json['uuid'] as String,
      remoteId: (json['remote_id'] as num?)?.toInt(),
      guardianId: (json['guardian_id'] as num?)?.toInt(),
      recordBookId: (json['record_book_id'] as num?)?.toInt(),
      contractTypeId: (json['contract_type_id'] as num?)?.toInt(),
      status: json['status'] as String? ?? 'draft',
      serialNumber: (json['serial_number'] as num?)?.toInt(),
      registerNumber: json['register_number'] as String?,
      date: json['date'] == null
          ? null
          : DateTime.parse(json['date'] as String),
      hijriYear: (json['hijri_year'] as num?)?.toInt(),
      hijriDate: json['hijri_date'] as String?,
      subject: json['subject'] as String?,
      content: json['content'] as String?,
      totalAmount: (json['total_amount'] as num?)?.toDouble() ?? 0.0,
      paidAmount: (json['paid_amount'] as num?)?.toDouble() ?? 0.0,
      createdAt: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
      extraAttributes: json['extra_attributes'] as Map<String, dynamic>?,
    );

Map<String, dynamic> _$RegistryEntryModelToJson(RegistryEntryModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'uuid': instance.uuid,
      'remote_id': instance.remoteId,
      'guardian_id': instance.guardianId,
      'record_book_id': instance.recordBookId,
      'contract_type_id': instance.contractTypeId,
      'status': instance.status,
      'serial_number': instance.serialNumber,
      'register_number': instance.registerNumber,
      'date': instance.date?.toIso8601String(),
      'hijri_year': instance.hijriYear,
      'hijri_date': instance.hijriDate,
      'subject': instance.subject,
      'content': instance.content,
      'total_amount': instance.totalAmount,
      'paid_amount': instance.paidAmount,
      'created_at': instance.createdAt?.toIso8601String(),
      'extra_attributes': instance.extraAttributes,
    };
