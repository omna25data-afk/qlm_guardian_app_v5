import 'package:flutter/material.dart';
import 'package:qlm_guardian_app_v5/features/admin/data/models/admin_renewal_model.dart';
import 'package:qlm_guardian_app_v5/core/theme/app_colors.dart';

/// A distinctive card for displaying renewal information (License or Card).
/// Completely different design from GuardianListCard.
class RenewalCard extends StatelessWidget {
  final AdminRenewalModel renewal;
  final VoidCallback? onHistory;
  final VoidCallback? onRenew;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  const RenewalCard({
    super.key,
    required this.renewal,
    this.onHistory,
    this.onRenew,
    this.onEdit,
    this.onDelete,
  });

  Color _statusColor() {
    switch (renewal.statusColor.toLowerCase()) {
      case 'success':
      case 'green':
        return const Color(0xFF22C55E);
      case 'warning':
      case 'orange':
        return const Color(0xFFF59E0B);
      case 'danger':
      case 'red':
      case 'error':
        return const Color(0xFFEF4444);
      default:
        return AppColors.textHint;
    }
  }

  IconData _statusIcon() {
    switch (renewal.statusColor.toLowerCase()) {
      case 'success':
      case 'green':
        return Icons.check_circle_rounded;
      case 'warning':
      case 'orange':
        return Icons.warning_amber_rounded;
      case 'danger':
      case 'red':
      case 'error':
        return Icons.cancel_rounded;
      default:
        return Icons.help_outline_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    final color = _statusColor();
    final icon = _statusIcon();

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withValues(alpha: 0.3), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.08),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          // ─── Status Strip ───────────────────────────
          Container(
            height: 6,
            decoration: BoxDecoration(
              color: color,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ─── Header Row ─────────────────────────
                Row(
                  children: [
                    // Status Icon
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: color.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(icon, color: color, size: 22),
                    ),
                    const SizedBox(width: 12),
                    // Guardian Name & Renewal Number
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            renewal.guardianName,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                              fontFamily: 'Tajawal',
                              color: AppColors.textPrimary,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 2),
                          Text(
                            renewal.type,
                            style: TextStyle(
                              fontSize: 12,
                              fontFamily: 'Tajawal',
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Renewal Number Badge
                    if (renewal.renewalNumber != null)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: AppColors.primary.withValues(alpha: 0.3),
                          ),
                        ),
                        child: Text(
                          '#${renewal.renewalNumber}',
                          style: const TextStyle(
                            color: AppColors.primary,
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                            fontFamily: 'Tajawal',
                          ),
                        ),
                      ),
                  ],
                ),

                const SizedBox(height: 14),

                // ─── Status Badge ───────────────────────
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 5,
                  ),
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(icon, color: color, size: 14),
                      const SizedBox(width: 6),
                      Text(
                        renewal.status,
                        style: TextStyle(
                          color: color,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Tajawal',
                        ),
                      ),
                      if (renewal.daysUntilExpiry != null) ...[
                        const SizedBox(width: 8),
                        Text(
                          '(${renewal.daysUntilExpiry} يوم)',
                          style: TextStyle(
                            color: color,
                            fontSize: 11,
                            fontFamily: 'Tajawal',
                          ),
                        ),
                      ],
                    ],
                  ),
                ),

                const SizedBox(height: 14),

                // ─── Grid Info ──────────────────────────
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.background,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          _gridItem(
                            Icons.calendar_today_rounded,
                            'تاريخ التجديد',
                            renewal.renewalDate.isNotEmpty
                                ? renewal.renewalDate
                                : '—',
                          ),
                          const SizedBox(width: 12),
                          _gridItem(
                            Icons.event_busy_rounded,
                            'تاريخ الانتهاء',
                            renewal.expiryDate ?? '—',
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          _gridItem(
                            Icons.receipt_long_rounded,
                            'رقم الإيصال',
                            renewal.receiptNumber?.toString() ?? '—',
                          ),
                          const SizedBox(width: 12),
                          _gridItem(
                            Icons.payments_rounded,
                            'المبلغ',
                            renewal.receiptAmount != null
                                ? '${renewal.receiptAmount} ر.ي'
                                : '—',
                          ),
                        ],
                      ),
                      if (renewal.receiptDate != null) ...[
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            _gridItem(
                              Icons.date_range_rounded,
                              'تاريخ الإيصال',
                              renewal.receiptDate!,
                            ),
                            const SizedBox(width: 12),
                            const Expanded(child: SizedBox()),
                          ],
                        ),
                      ],
                    ],
                  ),
                ),

                // ─── Notes ──────────────────────────────
                if (renewal.notes != null && renewal.notes!.isNotEmpty) ...[
                  const SizedBox(height: 10),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: AppColors.info.withValues(alpha: 0.05),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: AppColors.info.withValues(alpha: 0.2),
                      ),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.sticky_note_2_rounded,
                          size: 14,
                          color: AppColors.info,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            renewal.notes!,
                            style: const TextStyle(
                              fontSize: 12,
                              fontFamily: 'Tajawal',
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],

                const SizedBox(height: 14),

                // ─── Action Buttons ─────────────────────
                Row(
                  children: [
                    // History
                    if (onHistory != null)
                      Expanded(
                        child: _actionButton(
                          icon: Icons.history_rounded,
                          label: 'السجل',
                          color: AppColors.info,
                          onTap: onHistory!,
                          outlined: true,
                        ),
                      ),
                    if (onHistory != null && onEdit != null)
                      const SizedBox(width: 8),
                    // Edit
                    if (onEdit != null)
                      _iconActionButton(
                        icon: Icons.edit_rounded,
                        color: AppColors.warning,
                        onTap: onEdit!,
                      ),
                    if (onEdit != null && onDelete != null)
                      const SizedBox(width: 8),
                    // Delete
                    if (onDelete != null)
                      _iconActionButton(
                        icon: Icons.delete_rounded,
                        color: AppColors.error,
                        onTap: onDelete!,
                      ),
                    if (onRenew != null) ...[
                      const SizedBox(width: 8),
                      Expanded(
                        child: _actionButton(
                          icon: Icons.autorenew_rounded,
                          label: 'تجديد',
                          color: AppColors.primary,
                          onTap: onRenew!,
                          outlined: false,
                        ),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _gridItem(IconData icon, String label, String value) {
    return Expanded(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 15, color: AppColors.primary.withValues(alpha: 0.7)),
          const SizedBox(width: 6),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 10,
                    fontFamily: 'Tajawal',
                    color: AppColors.textHint,
                  ),
                ),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'Tajawal',
                    color: AppColors.textPrimary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _actionButton({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
    required bool outlined,
  }) {
    if (outlined) {
      return OutlinedButton.icon(
        onPressed: onTap,
        icon: Icon(icon, size: 16),
        label: Text(
          label,
          style: const TextStyle(fontFamily: 'Tajawal', fontSize: 12),
        ),
        style: OutlinedButton.styleFrom(
          foregroundColor: color,
          side: BorderSide(color: color.withValues(alpha: 0.5)),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          padding: const EdgeInsets.symmetric(vertical: 8),
        ),
      );
    } else {
      return ElevatedButton.icon(
        onPressed: onTap,
        icon: Icon(icon, size: 16, color: Colors.white),
        label: Text(
          label,
          style: const TextStyle(
            fontFamily: 'Tajawal',
            fontSize: 12,
            color: Colors.white,
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          padding: const EdgeInsets.symmetric(vertical: 8),
        ),
      );
    }
  }

  Widget _iconActionButton({
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: color.withValues(alpha: 0.3)),
        ),
        child: Icon(icon, size: 18, color: color),
      ),
    );
  }
}
