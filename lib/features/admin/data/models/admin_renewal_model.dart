import 'package:json_annotation/json_annotation.dart';

part 'admin_renewal_model.g.dart';

@JsonSerializable()
class AdminRenewalModel {
  final int id;
  @JsonKey(name: 'guardian_name', defaultValue: 'غير معروف')
  final String guardianName;
  @JsonKey(name: 'renewal_date', defaultValue: '')
  final String renewalDate;
  @JsonKey(defaultValue: '')
  final String status;
  @JsonKey(name: 'status_color', defaultValue: 'grey')
  final String statusColor;
  @JsonKey(defaultValue: '')
  final String type;

  AdminRenewalModel({
    required this.id,
    required this.guardianName,
    required this.renewalDate,
    required this.status,
    required this.statusColor,
    required this.type,
  });

  factory AdminRenewalModel.fromJson(Map<String, dynamic> json) =>
      _$AdminRenewalModelFromJson(json);
  Map<String, dynamic> toJson() => _$AdminRenewalModelToJson(this);
}
