import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../providers/reports_provider.dart';

class GuardianStatisticsScreen extends ConsumerWidget {
  const GuardianStatisticsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final statsAsync = ref.watch(guardianStatisticsProvider);

    return statsAsync.when(
      data: (guardians) {
        if (guardians.isEmpty) {
          return const Center(child: Text('لا توجد بيانات'));
        }
        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: guardians.length,
          itemBuilder: (context, index) {
            final guardian = guardians[index];
            return Card(
              margin: const EdgeInsets.only(bottom: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: BorderSide(
                  color: AppColors.primary.withValues(alpha: 0.1),
                ),
              ),
              child: ExpansionTile(
                leading: CircleAvatar(
                  backgroundColor: AppColors.primary.withValues(alpha: 0.1),
                  child: Text(
                    '${index + 1}',
                    style: TextStyle(
                      color: AppColors.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                title: Text(
                  guardian.name,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Text('رقم السجل: ${guardian.serialNumber}'),
                trailing: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      '${guardian.totalAmount.toStringAsFixed(2)} ر.س',
                      style: TextStyle(
                        color: AppColors.accent,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                    Text(
                      '${guardian.totalEntries} قيد',
                      style: const TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                  ],
                ),
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        _buildRow('الرسوم:', guardian.totalFees),
                        _buildRow('الغرامات:', guardian.totalPenalties),
                        _buildRow('دعم:', guardian.totalSupport),
                        _buildRow('استدامة:', guardian.totalSustainability),
                        const Divider(),
                        const Text(
                          'توزيع العقود',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 8),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: guardian.byType.entries.map((e) {
                            if (e.value == 0) return const SizedBox.shrink();
                            return Chip(
                              label: Text(
                                '${_mapTypeToLabel(e.key)}: ${e.value}',
                              ),
                              backgroundColor: Colors.grey.shade100,
                              padding: EdgeInsets.zero,
                              labelStyle: const TextStyle(fontSize: 12),
                            );
                          }).toList(),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (err, stack) => Center(child: Text('خطأ: $err')),
    );
  }

  Widget _buildRow(String label, double value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label),
          Text(
            value.toStringAsFixed(2),
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  String _mapTypeToLabel(String key) {
    switch (key) {
      case 'marriage':
        return 'زواج';
      case 'divorce':
        return 'طلاق';
      case 'return':
        return 'رجعة';
      case 'sale_immovable':
        return 'بيع عقار';
      case 'sale_movable':
        return 'بيع منقول';
      case 'division':
        return 'قسمة';
      case 'agency':
        return 'وكالة';
      case 'dispositions':
        return 'تصرفات';
      default:
        return key;
    }
  }
}
