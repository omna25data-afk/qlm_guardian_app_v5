import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';
import '../../../../core/theme/app_colors.dart';

part 'admin_guardian_model.g.dart';

@JsonSerializable()
class AdminGuardianModel {
  final int id;
  final String name;
  @JsonKey(name: 'serial_number')
  final String serialNumber;
  final String? phone;
  @JsonKey(name: 'photo_url')
  final String? photoUrl;

  // Statuses
  @JsonKey(name: 'employment_status')
  final String? employmentStatus;
  @JsonKey(name: 'employment_status_color')
  final String? employmentStatusColor;

  @JsonKey(name: 'license_status')
  final String? licenseStatus;
  @JsonKey(name: 'license_color')
  final String? licenseColor;

  @JsonKey(name: 'card_status')
  final String? cardStatus;
  @JsonKey(name: 'card_color')
  final String? cardColor;

  // Personal Info
  @JsonKey(name: 'first_name')
  final String? firstName;
  @JsonKey(name: 'father_name')
  final String? fatherName;
  @JsonKey(name: 'grandfather_name')
  final String? grandfatherName;
  @JsonKey(name: 'family_name')
  final String? familyName;
  @JsonKey(name: 'great_grandfather_name')
  final String? greatGrandfatherName;

  @JsonKey(name: 'birth_date')
  final String? birthDate;
  @JsonKey(name: 'birth_place')
  final String? birthPlace;
  @JsonKey(name: 'home_phone')
  final String? homePhone;

  // Identity
  @JsonKey(name: 'proof_type')
  final String? proofType;
  @JsonKey(name: 'proof_number')
  final String? proofNumber;
  @JsonKey(name: 'issuing_authority')
  final String? issuingAuthority;
  @JsonKey(name: 'issue_date')
  final String? issueDate;
  @JsonKey(name: 'expiry_date')
  final String? expiryDate;

  // Professional
  final String? qualification;
  final String? job;
  final String? workplace;
  @JsonKey(name: 'experience_notes')
  final String? experienceNotes;

  // License & Ministerial
  @JsonKey(name: 'ministerial_decision_number')
  final String? ministerialDecisionNumber;
  @JsonKey(name: 'ministerial_decision_date')
  final String? ministerialDecisionDate;

  @JsonKey(name: 'license_number')
  final String? licenseNumber;
  @JsonKey(name: 'license_issue_date')
  final String? licenseIssueDate;
  @JsonKey(name: 'license_expiry_date')
  final String? licenseExpiryDate;

  // Profession Card
  @JsonKey(name: 'profession_card_number')
  final String? professionCardNumber;
  @JsonKey(name: 'profession_card_issue_date')
  final String? professionCardIssueDate;
  @JsonKey(name: 'profession_card_expiry_date')
  final String? professionCardExpiryDate;

  // Location
  @JsonKey(name: 'main_district_id')
  final int? mainDistrictId;
  @JsonKey(name: 'main_district_name')
  final String? mainDistrictName;

  // Extra
  @JsonKey(name: 'stop_date')
  final String? stopDate;
  @JsonKey(name: 'stop_reason')
  final String? stopReason;
  final String? notes;

  @JsonKey(name: 'license_renewals')
  final List<Map<String, dynamic>>? licenseRenewals;
  @JsonKey(name: 'card_renewals')
  final List<Map<String, dynamic>>? cardRenewals;

  AdminGuardianModel({
    required this.id,
    required this.name,
    required this.serialNumber,
    this.phone,
    this.photoUrl,
    this.employmentStatus,
    this.employmentStatusColor,
    this.licenseStatus,
    this.licenseColor,
    this.cardStatus,
    this.cardColor,
    this.firstName,
    this.fatherName,
    this.grandfatherName,
    this.familyName,
    this.greatGrandfatherName,
    this.birthDate,
    this.birthPlace,
    this.homePhone,
    this.proofType,
    this.proofNumber,
    this.issuingAuthority,
    this.issueDate,
    this.expiryDate,
    this.qualification,
    this.job,
    this.workplace,
    this.experienceNotes,
    this.ministerialDecisionNumber,
    this.ministerialDecisionDate,
    this.licenseNumber,
    this.licenseIssueDate,
    this.licenseExpiryDate,
    this.professionCardNumber,
    this.professionCardIssueDate,
    this.professionCardExpiryDate,
    this.mainDistrictId,
    this.mainDistrictName,
    this.stopDate,
    this.stopReason,
    this.notes,
    this.licenseRenewals,
    this.cardRenewals,
  });

  factory AdminGuardianModel.fromJson(Map<String, dynamic> json) =>
      _$AdminGuardianModelFromJson(json);
  Map<String, dynamic> toJson() => _$AdminGuardianModelToJson(this);

  // --- Helpers ---

  String get shortName {
    if (firstName != null && fatherName != null && familyName != null) {
      return "$firstName $fatherName $familyName";
    }
    return name;
  }

  Color get identityStatusColor => _getStatusColorFromDate(expiryDate);

  Color get licenseStatusColor {
    if (licenseColor != null) return _parseColor(licenseColor!);
    return _getStatusColorFromDate(licenseExpiryDate);
  }

  Color get cardStatusColor {
    if (cardColor != null) return _parseColor(cardColor!);
    return _getStatusColorFromDate(professionCardExpiryDate);
  }

  Color _getStatusColorFromDate(String? dateStr) {
    if (dateStr == null) return Colors.grey;
    try {
      final dt = DateTime.parse(dateStr);
      final now = DateTime.now();
      final difference = dt.difference(now).inDays;

      if (difference < 0) return AppColors.error;
      if (difference <= 30) return AppColors.warning;
      return AppColors.success;
    } catch (e) {
      return Colors.grey;
    }
  }

  Color _parseColor(String colorName) {
    switch (colorName.toLowerCase()) {
      case 'danger':
      case 'red':
        return AppColors.error;
      case 'warning':
      case 'orange':
        return AppColors.warning;
      case 'success':
      case 'green':
        return AppColors.success;
      case 'primary':
      case 'blue':
        return AppColors.info;
      case 'gray':
        return Colors.grey;
      default:
        return Colors.grey;
    }
  }
}
