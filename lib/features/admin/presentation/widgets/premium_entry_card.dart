import 'package:flutter/material.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../system/data/models/registry_entry_sections.dart';

class PremiumEntryCard extends StatelessWidget {
  final RegistryEntrySections entry;
  final VoidCallback onTap;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete; // Added onDelete callback
  final VoidCallback? onDocument; // Added onDocument callback

  const PremiumEntryCard({
    super.key,
    required this.entry,
    required this.onTap,
    this.onEdit,
    this.onDelete,
    this.onDocument,
  });

  @override
  Widget build(BuildContext context) {
    final contractColor = _getContractColor(entry.basicInfo.contractTypeId);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(color: Colors.grey.withValues(alpha: 0.15)),
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Column(
            // Main Column wrapper for Card Content + Action Buttons
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment
                      .start, // Align to top for better layout when content wraps
                  children: [
                    // Icon / Type Container
                    Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        color: contractColor.withValues(alpha: 0.08),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Center(
                        child: Icon(
                          _getContractIcon(entry.basicInfo.contractTypeId),
                          color: contractColor,
                          size: 26,
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    // Main Content Column
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  entry.basicInfo.contractType?.name ??
                                      'نوع غير محدد',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15,
                                    fontFamily: 'Tajawal',
                                    color: AppColors.textPrimary,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              _buildStatusBadge(entry.statusInfo.status),
                            ],
                          ),
                          const SizedBox(height: 6),
                          Text(
                            'أطراف العقد: ${entry.basicInfo.firstPartyName} / ${entry.basicInfo.secondPartyName}',
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 12,
                              fontFamily: 'Tajawal',
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),

                          // Document Info & Writer
                          const SizedBox(height: 6),
                          Row(
                            children: [
                              Icon(
                                Icons.person_pin,
                                size: 14,
                                color: Colors.grey[500],
                              ),
                              const SizedBox(width: 4),
                              Expanded(
                                child: Text(
                                  'الكاتب: ${entry.writerInfo.writerName} (${_getWriterTypeLabel(entry.writerInfo.writerType)})',
                                  style: TextStyle(
                                    color: Colors.grey[600],
                                    fontSize: 11,
                                    fontFamily: 'Tajawal',
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),

                          // Court Document Info
                          if (entry.documentInfo.docRecordBookNumber !=
                              null) ...[
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                Icon(
                                  Icons.account_balance,
                                  size: 14,
                                  color: Colors.grey[500],
                                ),
                                const SizedBox(width: 4),
                                Expanded(
                                  child: Text(
                                    'التوثيق: سجل ${entry.documentInfo.docRecordBookNumber} | صفحة ${entry.documentInfo.docPageNumber ?? "-"} | قيد ${entry.documentInfo.docEntryNumber ?? "-"}',
                                    style: TextStyle(
                                      color: Colors.grey[600],
                                      fontSize: 11,
                                      fontFamily: 'Tajawal',
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],

                          // Guardian Info
                          if (entry.guardianInfo.guardianRecordBookNumber !=
                              null) ...[
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                Icon(
                                  Icons.library_books,
                                  size: 14,
                                  color: Colors.grey[500],
                                ),
                                const SizedBox(width: 4),
                                Expanded(
                                  child: Text(
                                    'قيد الأمين: سجل ${entry.guardianInfo.guardianRecordBookNumber} | صفحة ${entry.guardianInfo.guardianPageNumber ?? "-"} | قيد ${entry.guardianInfo.guardianEntryNumber ?? "-"}',
                                    style: TextStyle(
                                      color: Colors.grey[600],
                                      fontSize: 11,
                                      fontFamily: 'Tajawal',
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],

                          // Financial Info
                          const SizedBox(height: 6),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.grey.withValues(alpha: 0.05),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.payments_outlined,
                                  size: 14,
                                  color: Colors.green[700],
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  'الإجمالي: ${entry.financialInfo.totalAmount} | المدفوع: ${entry.financialInfo.paidAmount}',
                                  style: TextStyle(
                                    color: Colors.green[800],
                                    fontSize: 11,
                                    fontFamily: 'Tajawal',
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(height: 6),
                          // Date and Tag Row
                          Row(
                            children: [
                              Icon(
                                Icons.calendar_today_outlined,
                                size: 14,
                                color: Colors.grey[500],
                              ),
                              const SizedBox(width: 4),
                              Text(
                                entry.documentInfo.documentHijriDate ?? '---',
                                style: TextStyle(
                                  color: Colors.grey[500],
                                  fontSize: 12,
                                  fontFamily: 'Tajawal',
                                ),
                              ),
                              const SizedBox(width: 12),
                              Icon(
                                Icons.tag,
                                size: 14,
                                color: Colors.grey[500],
                              ),
                              const SizedBox(width: 4),
                              Text(
                                '#${entry.basicInfo.serialNumber != 0 ? entry.basicInfo.serialNumber : (entry.basicInfo.registerNumber ?? "---")}',
                                style: TextStyle(
                                  color: Colors.grey[500],
                                  fontSize: 12,
                                  fontFamily: 'Tajawal',
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // Bottom Action Divider
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                child: Divider(
                  height: 1,
                  thickness: 1,
                  color: Color(0xFFF0F0F0),
                ),
              ),

              // action buttons
              IntrinsicHeight(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    // View Button
                    Expanded(
                      child: TextButton.icon(
                        // Since placing inside InkWell, we capture the tap for this specific action to prevent double triggering
                        onPressed: () {
                          // Trigger default tap behavior, or separated logic in future
                          onTap();
                        },
                        icon: const Icon(Icons.visibility_outlined, size: 18),
                        label: const Text(
                          'عرض',
                          style: TextStyle(fontFamily: 'Tajawal', fontSize: 13),
                        ),
                        style: TextButton.styleFrom(
                          foregroundColor: AppColors.primary,
                          padding: const EdgeInsets.symmetric(
                            vertical: 12,
                          ), // added vertical padding to act like a taller touch target
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.zero,
                          ),
                        ),
                      ),
                    ),
                    const VerticalDivider(
                      width: 1,
                      thickness: 1,
                      color: Color(0xFFF0F0F0),
                    ),
                    // Edit Button
                    if (onEdit != null) ...[
                      Expanded(
                        child: TextButton.icon(
                          onPressed: onEdit,
                          icon: const Icon(Icons.edit_note, size: 18),
                          label: const Text(
                            'تعديل',
                            style: TextStyle(
                              fontFamily: 'Tajawal',
                              fontSize: 13,
                            ),
                          ),
                          style: TextButton.styleFrom(
                            foregroundColor: Colors.blue.shade700,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.zero,
                            ),
                          ),
                        ),
                      ),
                      const VerticalDivider(
                        width: 1,
                        thickness: 1,
                        color: Color(0xFFF0F0F0),
                      ),
                    ],
                    // Document Button
                    if (entry.writerInfo.writerType == 'guardian' &&
                        entry.statusInfo.status != 'documented') ...[
                      Expanded(
                        child: TextButton.icon(
                          onPressed: onDocument,
                          icon: const Icon(Icons.verified_outlined, size: 18),
                          label: const Text(
                            'توثيق',
                            style: TextStyle(
                              fontFamily: 'Tajawal',
                              fontSize: 13,
                            ),
                          ),
                          style: TextButton.styleFrom(
                            foregroundColor: AppColors.success,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.zero,
                            ),
                          ),
                        ),
                      ),
                      const VerticalDivider(
                        width: 1,
                        thickness: 1,
                        color: Color(0xFFF0F0F0),
                      ),
                    ],
                    // More/Delete Menu
                    Expanded(
                      child: PopupMenuButton<String>(
                        onSelected: (value) {
                          if (value == 'delete') {
                            if (onDelete != null) onDelete!();
                          }
                        },
                        itemBuilder: (context) => [
                          const PopupMenuItem(
                            value: 'delete',
                            child: Row(
                              children: [
                                Icon(
                                  Icons.delete_outline,
                                  color: Colors.red,
                                  size: 18,
                                ),
                                SizedBox(width: 8),
                                Text(
                                  'حذف',
                                  style: TextStyle(
                                    fontFamily: 'Tajawal',
                                    color: Colors.red,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.more_horiz,
                                size: 18,
                                color: Colors.grey.shade700,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                'المزيد',
                                style: TextStyle(
                                  fontFamily: 'Tajawal',
                                  fontSize: 13,
                                  color: Colors.grey.shade700,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _getWriterTypeLabel(String? type) {
    switch (type) {
      case 'guardian':
        return 'أمين شرعي';
      case 'documentation':
        return 'قلم توثيق';
      case 'external':
        return 'آخر';
      default:
        return type ?? 'غير محدد';
    }
  }

  Widget _buildStatusBadge(String status) {
    Color color = _getStatusColor(status);
    String text = _getStatusText(status);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: color,
          fontSize: 11,
          fontWeight: FontWeight.bold,
          fontFamily: 'Tajawal',
        ),
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'documented':
        return AppColors.success;
      case 'registered_guardian':
        return Colors.blue;
      case 'pending_documentation':
        return AppColors.warning;
      case 'rejected':
        return AppColors.error;
      case 'draft':
      default:
        return Colors.grey;
    }
  }

  String _getStatusText(String status) {
    switch (status.toLowerCase()) {
      case 'documented':
        return 'موثق';
      case 'registered_guardian':
        return 'مقيد لدى الأمين';
      case 'pending_documentation':
        return 'بانتظار التوثيق';
      case 'rejected':
        return 'مرفوض';
      case 'draft':
        return 'مسودة';
      default:
        return status;
    }
  }

  Color _getContractColor(int? typeId) {
    switch (typeId) {
      case 1:
        return const Color(0xFFE91E63); // وردي
      case 4:
        return const Color(0xFF795548); // بني
      case 5:
        return const Color(0xFF009688); // أخضر مزرق
      case 6:
        return const Color(0xFF673AB7); // بنفسجي
      case 10:
        return const Color(0xFFFF9800); // برتقالي
      default:
        return AppColors.primary;
    }
  }

  IconData _getContractIcon(int? typeId) {
    switch (typeId) {
      case 1:
        return Icons.favorite; // زواج
      case 4:
        return Icons.gavel; // وكالة
      case 5:
        return Icons.swap_horiz; // تصرف
      case 6:
        return Icons.account_tree; // قسمة
      case 7:
        return Icons.heart_broken; // طلاق
      case 8:
        return Icons.replay; // رجعة
      case 10:
        return Icons.shopping_cart; // مبيع
      default:
        return Icons.description_outlined;
    }
  }
}
