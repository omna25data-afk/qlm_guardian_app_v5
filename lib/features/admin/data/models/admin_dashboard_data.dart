import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';
import '../../../../core/theme/app_colors.dart';

part 'admin_dashboard_data.g.dart';

@JsonSerializable()
class AdminDashboardData {
  final AdminStats stats;
  @JsonKey(name: 'urgent_actions')
  final List<UrgentAction> urgentActions;

  AdminDashboardData({required this.stats, required this.urgentActions});

  factory AdminDashboardData.fromJson(Map<String, dynamic> json) =>
      _$AdminDashboardDataFromJson(json);
  Map<String, dynamic> toJson() => _$AdminDashboardDataToJson(this);
}

@JsonSerializable()
class AdminStats {
  final StatCategory guardians;
  final StatCategory licenses;
  final StatCategory cards;

  AdminStats({
    required this.guardians,
    required this.licenses,
    required this.cards,
  });

  factory AdminStats.fromJson(Map<String, dynamic> json) =>
      _$AdminStatsFromJson(json);
  Map<String, dynamic> toJson() => _$AdminStatsToJson(this);
}

@JsonSerializable()
class StatCategory {
  final int total;
  final int active;
  final int inactive;
  final int warning;

  StatCategory({
    required this.total,
    required this.active,
    required this.inactive,
    required this.warning,
  });

  factory StatCategory.fromJson(Map<String, dynamic> json) =>
      _$StatCategoryFromJson(json);
  Map<String, dynamic> toJson() => _$StatCategoryToJson(this);
}

@JsonSerializable()
class UrgentAction {
  final String type;
  final String title;
  final String subtitle;
  @JsonKey(name: 'action_label')
  final String actionLabel;
  @JsonKey(name: 'bg_color')
  final String bgColorString;

  UrgentAction({
    required this.type,
    required this.title,
    required this.subtitle,
    required this.actionLabel,
    required this.bgColorString,
  });

  factory UrgentAction.fromJson(Map<String, dynamic> json) =>
      _$UrgentActionFromJson(json);
  Map<String, dynamic> toJson() => _$UrgentActionToJson(this);

  Color get color {
    switch (bgColorString.toLowerCase()) {
      case 'red':
        return AppColors.error;
      case 'orange':
        return AppColors.warning; // or AppColors.statOrange
      case 'blue':
        return AppColors.info;
      default:
        return Colors.grey;
    }
  }
}
