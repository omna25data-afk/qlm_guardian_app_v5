import 'package:json_annotation/json_annotation.dart';

part 'app_notification_model.g.dart';

@JsonSerializable()
class AppNotificationModel {
  final String id;
  final String type;
  @JsonKey(name: 'notifiable_type')
  final String notifiableType;
  @JsonKey(name: 'notifiable_id')
  final int notifiableId;
  final Map<String, dynamic> data;
  @JsonKey(name: 'read_at')
  final DateTime? readAt;
  @JsonKey(name: 'created_at')
  final DateTime createdAt;
  @JsonKey(name: 'updated_at')
  final DateTime updatedAt;

  const AppNotificationModel({
    required this.id,
    required this.type,
    required this.notifiableType,
    required this.notifiableId,
    required this.data,
    this.readAt,
    required this.createdAt,
    required this.updatedAt,
  });

  factory AppNotificationModel.fromJson(Map<String, dynamic> json) =>
      _$AppNotificationModelFromJson(json);

  Map<String, dynamic> toJson() => _$AppNotificationModelToJson(this);

  AppNotificationModel copyWith({
    String? id,
    String? type,
    String? notifiableType,
    int? notifiableId,
    Map<String, dynamic>? data,
    DateTime? readAt,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return AppNotificationModel(
      id: id ?? this.id,
      type: type ?? this.type,
      notifiableType: notifiableType ?? this.notifiableType,
      notifiableId: notifiableId ?? this.notifiableId,
      data: data ?? this.data,
      readAt: readAt ?? this.readAt,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
