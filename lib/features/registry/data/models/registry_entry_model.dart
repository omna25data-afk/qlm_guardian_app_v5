import 'package:json_annotation/json_annotation.dart';
import 'package:equatable/equatable.dart';

part 'registry_entry_model.g.dart';

@JsonSerializable()
class RegistryEntryModel extends Equatable {
  final int? id; // Local ID
  final String uuid;
  @JsonKey(name: 'remote_id')
  final int? remoteId;

  @JsonKey(name: 'guardian_id')
  final int? guardianId;

  // Status
  final String status;
  @JsonKey(name: 'serial_number')
  final int? serialNumber;
  @JsonKey(name: 'register_number')
  final String? registerNumber;

  // Dates
  final DateTime? date;
  @JsonKey(name: 'hijri_year')
  final int? hijriYear;
  @JsonKey(name: 'hijri_date')
  final String? hijriDate;

  // Content
  final String? subject;
  final String? content;

  // Financial
  @JsonKey(name: 'total_amount')
  final double totalAmount;
  @JsonKey(name: 'paid_amount')
  final double paidAmount;

  @JsonKey(name: 'created_at')
  final DateTime? createdAt;

  const RegistryEntryModel({
    this.id,
    required this.uuid,
    this.remoteId,
    this.guardianId,
    this.status = 'draft',
    this.serialNumber,
    this.registerNumber,
    this.date,
    this.hijriYear,
    this.hijriDate,
    this.subject,
    this.content,
    this.totalAmount = 0.0,
    this.paidAmount = 0.0,
    this.createdAt,
  });

  factory RegistryEntryModel.fromJson(Map<String, dynamic> json) =>
      _$RegistryEntryModelFromJson(json);
  Map<String, dynamic> toJson() => _$RegistryEntryModelToJson(this);

  @override
  List<Object?> get props => [uuid, remoteId, status, serialNumber];

  RegistryEntryModel copyWith({
    int? id,
    String? uuid,
    int? remoteId,
    String? status,
    String? subject,
    String? content,
  }) {
    return RegistryEntryModel(
      id: id ?? this.id,
      uuid: uuid ?? this.uuid,
      remoteId: remoteId ?? this.remoteId,
      guardianId: guardianId,
      status: status ?? this.status,
      serialNumber: serialNumber,
      registerNumber: registerNumber,
      date: date,
      hijriYear: hijriYear,
      hijriDate: hijriDate,
      subject: subject ?? this.subject,
      content: content ?? this.content,
      totalAmount: totalAmount,
      paidAmount: paidAmount,
      createdAt: createdAt,
    );
  }
}
