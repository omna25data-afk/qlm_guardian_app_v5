import 'package:json_annotation/json_annotation.dart';

part 'admin_renewal_model.g.dart';

@JsonSerializable()
class AdminRenewalModel {
  final int id;
  @JsonKey(name: 'legitimate_guardian_id')
  final int? legitimateGuardianId;
  @JsonKey(name: 'guardian_name', defaultValue: 'غير معروف')
  final String guardianName;
  @JsonKey(name: 'renewal_number')
  final int? renewalNumber;
  @JsonKey(name: 'renewal_date', defaultValue: '')
  final String renewalDate;
  @JsonKey(name: 'expiry_date')
  final String? expiryDate;
  @JsonKey(defaultValue: '')
  final String status;
  @JsonKey(name: 'status_color', defaultValue: 'grey')
  final String statusColor;
  @JsonKey(defaultValue: '')
  final String type;

  @JsonKey(name: 'receipt_number')
  final String? receiptNumber;
  @JsonKey(name: 'receipt_amount')
  final dynamic receiptAmount;
  @JsonKey(name: 'receipt_date')
  final String? receiptDate;
  final String? notes;

  @JsonKey(name: 'days_until_expiry')
  final int? daysUntilExpiry;
  @JsonKey(name: 'guardian_license_number')
  final String? guardianLicenseNumber;
  @JsonKey(name: 'guardian_card_number')
  final String? guardianCardNumber;

  AdminRenewalModel({
    required this.id,
    this.legitimateGuardianId,
    required this.guardianName,
    this.renewalNumber,
    required this.renewalDate,
    this.expiryDate,
    required this.status,
    required this.statusColor,
    required this.type,
    this.receiptNumber,
    this.receiptAmount,
    this.receiptDate,
    this.notes,
    this.daysUntilExpiry,
    this.guardianLicenseNumber,
    this.guardianCardNumber,
  });

  factory AdminRenewalModel.fromJson(Map<String, dynamic> json) =>
      _$AdminRenewalModelFromJson(json);
  Map<String, dynamic> toJson() => _$AdminRenewalModelToJson(this);
}
