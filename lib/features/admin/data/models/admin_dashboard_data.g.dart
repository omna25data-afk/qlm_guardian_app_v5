// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_dashboard_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AdminDashboardData _$AdminDashboardDataFromJson(Map<String, dynamic> json) =>
    AdminDashboardData(
      stats: AdminStats.fromJson(json['stats'] as Map<String, dynamic>),
      urgentActions: (json['urgent_actions'] as List<dynamic>)
          .map((e) => UrgentAction.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$AdminDashboardDataToJson(AdminDashboardData instance) =>
    <String, dynamic>{
      'stats': instance.stats,
      'urgent_actions': instance.urgentActions,
    };

AdminStats _$AdminStatsFromJson(Map<String, dynamic> json) => AdminStats(
  guardians: StatCategory.fromJson(json['guardians'] as Map<String, dynamic>),
  licenses: StatCategory.fromJson(json['licenses'] as Map<String, dynamic>),
  cards: StatCategory.fromJson(json['cards'] as Map<String, dynamic>),
);

Map<String, dynamic> _$AdminStatsToJson(AdminStats instance) =>
    <String, dynamic>{
      'guardians': instance.guardians,
      'licenses': instance.licenses,
      'cards': instance.cards,
    };

StatCategory _$StatCategoryFromJson(Map<String, dynamic> json) => StatCategory(
  total: (json['total'] as num).toInt(),
  active: (json['active'] as num).toInt(),
  inactive: (json['inactive'] as num).toInt(),
  warning: (json['warning'] as num).toInt(),
);

Map<String, dynamic> _$StatCategoryToJson(StatCategory instance) =>
    <String, dynamic>{
      'total': instance.total,
      'active': instance.active,
      'inactive': instance.inactive,
      'warning': instance.warning,
    };

UrgentAction _$UrgentActionFromJson(Map<String, dynamic> json) => UrgentAction(
  type: json['type'] as String,
  title: json['title'] as String,
  subtitle: json['subtitle'] as String,
  actionLabel: json['action_label'] as String,
  bgColorString: json['bg_color'] as String,
);

Map<String, dynamic> _$UrgentActionToJson(UrgentAction instance) =>
    <String, dynamic>{
      'type': instance.type,
      'title': instance.title,
      'subtitle': instance.subtitle,
      'action_label': instance.actionLabel,
      'bg_color': instance.bgColorString,
    };
