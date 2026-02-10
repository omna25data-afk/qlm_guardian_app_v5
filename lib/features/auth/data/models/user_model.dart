import 'package:json_annotation/json_annotation.dart';
import 'package:equatable/equatable.dart';

part 'user_model.g.dart';

/// User model - matches Laravel auth controller response
@JsonSerializable()
class UserModel extends Equatable {
  final int id;
  final String name;
  @JsonKey(name: 'phone_number')
  final String? phoneNumber;
  final String? email;
  @JsonKey(name: 'avatar_url')
  final String? avatarUrl;
  final String? token;

  // Guardian-specific
  @JsonKey(name: 'is_guardian')
  final bool isGuardian;
  @JsonKey(name: 'legitimate_guardian_id')
  final int? legitimateGuardianId;
  @JsonKey(name: 'role_names')
  final List<String>? roleNames;

  @JsonKey(name: 'guardian')
  final GuardianInfo? guardian;

  const UserModel({
    required this.id,
    required this.name,
    this.phoneNumber,
    this.email,
    this.avatarUrl,
    this.token,
    this.isGuardian = false,
    this.legitimateGuardianId,
    this.roleNames,
    this.guardian,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);
  Map<String, dynamic> toJson() => _$UserModelToJson(this);

  /// Check if user has admin role
  bool get isAdmin =>
      roleNames?.any(
        (r) =>
            r == 'super_admin' ||
            r == 'admin' ||
            r == 'director' ||
            r == 'guardian_manager' ||
            r == 'documentation_head' ||
            r == 'assistant_director',
      ) ??
      false;

  /// Check if user has guardian role
  bool get hasGuardianAccess =>
      isGuardian ||
      legitimateGuardianId != null ||
      roleNames?.contains('guardian') == true;

  @override
  List<Object?> get props => [
    id,
    name,
    phoneNumber,
    email,
    token,
    isGuardian,
    guardian,
  ];
}

@JsonSerializable()
class GuardianInfo extends Equatable {
  final int id;
  @JsonKey(name: 'full_name')
  final String fullName;
  @JsonKey(name: 'register_number')
  final String? registerNumber;
  @JsonKey(name: 'avatar_url')
  final String? avatarUrl;
  @JsonKey(name: 'phone_number')
  final String? phoneNumber;
  @JsonKey(name: 'specialization_area')
  final String? specializationArea;
  @JsonKey(name: 'license_status')
  final String? licenseStatus;
  @JsonKey(name: 'card_status')
  final String? cardStatus;

  const GuardianInfo({
    required this.id,
    required this.fullName,
    this.registerNumber,
    this.avatarUrl,
    this.phoneNumber,
    this.specializationArea,
    this.licenseStatus,
    this.cardStatus,
  });

  factory GuardianInfo.fromJson(Map<String, dynamic> json) =>
      _$GuardianInfoFromJson(json);
  Map<String, dynamic> toJson() => _$GuardianInfoToJson(this);

  @override
  List<Object?> get props => [id, fullName, registerNumber];
}
