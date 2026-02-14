import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/currency_utils.dart';
import '../../../../core/utils/date_utils.dart';
import '../../data/models/registry_entry_model.dart';

/// Card widget for displaying a registry entry in a list
class EntryCard extends StatelessWidget {
  final RegistryEntryModel entry;
  final VoidCallback? onTap;

  const EntryCard({super.key, required this.entry, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header: Subject + Status
              Row(
                children: [
                  Expanded(
                    child: Text(
                      entry.subject ?? 'بدون عنوان',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  _buildStatusChip(entry.status ?? 'draft'),
                ],
              ),
              const SizedBox(height: 8),

              // Serial & Register numbers
              Row(
                children: [
                  if (entry.serialNumber != null) ...[
                    const Icon(
                      Icons.tag,
                      size: 14,
                      color: AppColors.textSecondary,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '${entry.serialNumber}',
                      style: const TextStyle(
                        fontSize: 13,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(width: 16),
                  ],
                  if (entry.registerNumber != null) ...[
                    const Icon(
                      Icons.book_outlined,
                      size: 14,
                      color: AppColors.textSecondary,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      entry.registerNumber!,
                      style: const TextStyle(
                        fontSize: 13,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ],
              ),
              const SizedBox(height: 8),

              // Footer: Date + Amount
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const Icon(
                        Icons.calendar_today,
                        size: 14,
                        color: AppColors.textSecondary,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        AppDateUtils.formatHijri(
                          entry.hijriDate,
                          entry.hijriYear,
                        ),
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                  Text(
                    CurrencyUtils.formatYER(entry.totalAmount),
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppColors.primary,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatusChip(String status) {
    final config = _statusConfig(status);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: config.color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        config.label,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: config.color,
        ),
      ),
    );
  }

  ({Color color, String label}) _statusConfig(String status) {
    switch (status) {
      case 'draft':
        return (color: Colors.grey, label: 'مسودة');
      case 'registered_guardian':
        return (color: Colors.blue, label: 'مسجل');
      case 'pending_documentation':
        return (color: Colors.orange, label: 'قيد التوثيق');
      case 'documented':
        return (color: Colors.green, label: 'موثق');
      case 'rejected':
        return (color: Colors.red, label: 'مرفوض');
      default:
        return (color: Colors.grey, label: status);
    }
  }
}
