// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_renewal_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AdminRenewalModel _$AdminRenewalModelFromJson(Map<String, dynamic> json) =>
    AdminRenewalModel(
      id: (json['id'] as num).toInt(),
      legitimateGuardianId: (json['legitimate_guardian_id'] as num?)?.toInt(),
      guardianName: json['guardian_name'] as String? ?? 'غير معروف',
      renewalNumber: (json['renewal_number'] as num?)?.toInt(),
      renewalDate: json['renewal_date'] as String? ?? '',
      expiryDate: json['expiry_date'] as String?,
      status: json['status'] as String? ?? '',
      statusColor: json['status_color'] as String? ?? 'grey',
      type: json['type'] as String? ?? '',
      receiptNumber: json['receipt_number'] as String?,
      receiptAmount: json['receipt_amount'],
      receiptDate: json['receipt_date'] as String?,
      notes: json['notes'] as String?,
      daysUntilExpiry: (json['days_until_expiry'] as num?)?.toInt(),
      guardianLicenseNumber: json['guardian_license_number'] as String?,
      guardianCardNumber: json['guardian_card_number'] as String?,
    );

Map<String, dynamic> _$AdminRenewalModelToJson(AdminRenewalModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'legitimate_guardian_id': instance.legitimateGuardianId,
      'guardian_name': instance.guardianName,
      'renewal_number': instance.renewalNumber,
      'renewal_date': instance.renewalDate,
      'expiry_date': instance.expiryDate,
      'status': instance.status,
      'status_color': instance.statusColor,
      'type': instance.type,
      'receipt_number': instance.receiptNumber,
      'receipt_amount': instance.receiptAmount,
      'receipt_date': instance.receiptDate,
      'notes': instance.notes,
      'days_until_expiry': instance.daysUntilExpiry,
      'guardian_license_number': instance.guardianLicenseNumber,
      'guardian_card_number': instance.guardianCardNumber,
    };
