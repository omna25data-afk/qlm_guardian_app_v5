import 'package:flutter/material.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../data/models/admin_renewal_model.dart';

class AdminRenewalListCard extends StatelessWidget {
  final AdminRenewalModel renewal;
  final String numberLabel;
  final String? numberValue;
  final VoidCallback onHistoryPressed;
  final VoidCallback onRenewPressed;

  const AdminRenewalListCard({
    super.key,
    required this.renewal,
    required this.numberLabel,
    this.numberValue,
    required this.onHistoryPressed,
    required this.onRenewPressed,
  });

  Color _getStatusColor() {
    switch (renewal.statusColor) {
      case 'success':
        return AppColors.success;
      case 'danger':
        return AppColors.error;
      case 'warning':
        return AppColors.warning;
      default:
        return AppColors.textSecondary;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shadowColor: Colors.black.withValues(alpha: 0.05),
      margin: const EdgeInsets.only(bottom: 16.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: _getStatusColor().withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Row: Guardian Name and Status Badge
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        renewal.guardianName,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      if (renewal.serialNumber != null)
                        Padding(
                          padding: const EdgeInsets.only(top: 4.0),
                          child: Text(
                            'الرقم التسلسلي: ${renewal.serialNumber}',
                            style: const TextStyle(
                              fontSize: 12,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: _getStatusColor().withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: _getStatusColor(), width: 1),
                  ),
                  child: Text(
                    renewal.status,
                    style: TextStyle(
                      color: _getStatusColor(),
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const Divider(height: 24),
            // Details Grid
            Row(
              children: [
                Expanded(
                  child: _buildDetailCol(
                    icon: Icons.numbers,
                    label: numberLabel,
                    value: numberValue ?? 'غير محدد',
                  ),
                ),
                Expanded(
                  child: _buildDetailCol(
                    icon: Icons.tag,
                    label: 'رقم التجديد',
                    value: renewal.renewalNumber?.toString() ?? 'غير متوفر',
                    valueColor: AppColors.primary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildDetailCol(
                    icon: Icons.date_range,
                    label: 'تاريخ التجديد',
                    value: renewal.renewalDate,
                  ),
                ),
                Expanded(
                  child: _buildDetailCol(
                    icon: Icons.event_busy,
                    label: 'تاريخ الانتهاء',
                    value: renewal.expiryDate ?? 'غير متوفر',
                  ),
                ),
              ],
            ),
            if (renewal.daysUntilExpiry != null)
              Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: Row(
                  children: [
                    Icon(Icons.timer, size: 16, color: _getStatusColor()),
                    const SizedBox(width: 8),
                    Text(
                      'المتبقي: ${renewal.daysUntilExpiry} يوم',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: _getStatusColor(),
                      ),
                    ),
                  ],
                ),
              ),
            const SizedBox(height: 16),
            // Actions Row
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: onHistoryPressed,
                    icon: const Icon(Icons.history, size: 18),
                    label: const Text('سجل التجديدات'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.primary,
                      side: const BorderSide(color: AppColors.primary),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: onRenewPressed,
                    icon: const Icon(Icons.autorenew, size: 18),
                    label: const Text('تجديد'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      elevation: 0,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailCol({
    required IconData icon,
    required String label,
    required String value,
    Color? valueColor,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 14, color: AppColors.textSecondary),
            const SizedBox(width: 4),
            Text(
              label,
              style: const TextStyle(
                fontSize: 12,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: valueColor ?? AppColors.textPrimary,
          ),
        ),
      ],
    );
  }
}
