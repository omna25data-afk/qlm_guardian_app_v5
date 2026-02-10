// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserModel _$UserModelFromJson(Map<String, dynamic> json) => UserModel(
  id: (json['id'] as num).toInt(),
  name: json['name'] as String,
  phoneNumber: json['phone_number'] as String?,
  email: json['email'] as String?,
  avatarUrl: json['avatar_url'] as String?,
  token: json['token'] as String?,
  isGuardian: json['is_guardian'] as bool? ?? false,
  legitimateGuardianId: (json['legitimate_guardian_id'] as num?)?.toInt(),
  roleNames: (json['role_names'] as List<dynamic>?)
      ?.map((e) => e as String)
      .toList(),
  guardian: json['guardian'] == null
      ? null
      : GuardianInfo.fromJson(json['guardian'] as Map<String, dynamic>),
);

Map<String, dynamic> _$UserModelToJson(UserModel instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'phone_number': instance.phoneNumber,
  'email': instance.email,
  'avatar_url': instance.avatarUrl,
  'token': instance.token,
  'is_guardian': instance.isGuardian,
  'legitimate_guardian_id': instance.legitimateGuardianId,
  'role_names': instance.roleNames,
  'guardian': instance.guardian,
};

GuardianInfo _$GuardianInfoFromJson(Map<String, dynamic> json) => GuardianInfo(
  id: (json['id'] as num).toInt(),
  fullName: json['full_name'] as String,
  registerNumber: json['register_number'] as String?,
  avatarUrl: json['avatar_url'] as String?,
  phoneNumber: json['phone_number'] as String?,
  specializationArea: json['specialization_area'] as String?,
  licenseStatus: json['license_status'] as String?,
  cardStatus: json['card_status'] as String?,
);

Map<String, dynamic> _$GuardianInfoToJson(GuardianInfo instance) =>
    <String, dynamic>{
      'id': instance.id,
      'full_name': instance.fullName,
      'register_number': instance.registerNumber,
      'avatar_url': instance.avatarUrl,
      'phone_number': instance.phoneNumber,
      'specialization_area': instance.specializationArea,
      'license_status': instance.licenseStatus,
      'card_status': instance.cardStatus,
    };
