import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../data/models/registry_entry_model.dart';

class EntryDetailsScreen extends ConsumerWidget {
  final RegistryEntryModel entry;

  const EntryDetailsScreen({super.key, required this.entry});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: Text(entry.subject ?? 'تفاصيل القيد')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            const SizedBox(height: 24),
            _buildSection(
              title: 'البيانات الأساسية',
              children: [
                _buildInfoRow(
                  'الرقم التسلسلي',
                  entry.serialNumber?.toString() ?? '-',
                ),
                _buildInfoRow('رقم القيد', entry.registerNumber ?? '-'),
                _buildInfoRow('الحالة', entry.status),
                _buildInfoRow('التاريخ الهجري', entry.hijriDate ?? '-'),
              ],
            ),
            const SizedBox(height: 24),
            _buildSection(
              title: 'المحتوى',
              children: [
                Text(
                  entry.content ?? 'لا يوجد محتوى',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
            const SizedBox(height: 24),
            _buildSection(
              title: 'البيانات المالية',
              children: [
                _buildInfoRow('المبلغ الإجمالي', '${entry.totalAmount} ر.ي'),
                _buildInfoRow('المبلغ المدفوع', '${entry.paidAmount} ر.ي'),
                _buildInfoRow(
                  'المتبقي',
                  '${entry.totalAmount - entry.paidAmount} ر.ي',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            entry.subject ?? 'بدون عنوان',
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              const Icon(
                Icons.calendar_today,
                size: 16,
                color: AppColors.textSecondary,
              ),
              const SizedBox(width: 8),
              Text(
                entry.createdAt?.toString().split(' ')[0] ?? '-',
                style: const TextStyle(color: AppColors.textSecondary),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSection({
    required String title,
    required List<Widget> children,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 12),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: children,
          ),
        ),
      ],
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: AppColors.textSecondary)),
          Text(value, style: const TextStyle(fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }
}
