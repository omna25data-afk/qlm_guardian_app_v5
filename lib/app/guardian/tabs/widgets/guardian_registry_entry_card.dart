import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart' as intl;
import '../../../../core/theme/app_colors.dart';
import 'package:qlm_guardian_app_v5/features/system/data/models/registry_entry_sections.dart';
import 'package:qlm_guardian_app_v5/features/system/data/models/contract_type.dart';

import '../screens/guardian_entry_details_screen.dart';

class GuardianRegistryEntryCard extends ConsumerWidget {
  final RegistryEntrySections entry;
  final VoidCallback? onTap;
  final VoidCallback? onEdit;
  final VoidCallback? onRequestDocumentation;

  // Guardian Specific Green Theme
  static const Color guardianPrimary = Color(0xFF006400);

  const GuardianRegistryEntryCard({
    super.key,
    required this.entry,
    this.onTap,
    this.onEdit,
    this.onRequestDocumentation,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Use backend-provided status colors and labels if available
    final statusColor = entry.statusInfo.statusColor != null
        ? _parseColor(entry.statusInfo.statusColor!)
        : _getStatusColor(entry.statusInfo.status);
    final statusLabel =
        entry.statusInfo.statusLabel ??
        _getStatusLabel(entry.statusInfo.status);

    // Use contract type from basicInfo if available
    final contractTypeName =
        entry.basicInfo.contractType?.name ?? 'محرر غير محدد';
    final contractTypeColor = _parseColor(entry.basicInfo.contractType?.color);

    final canRequestDocumentation =
        entry.statusInfo.status == 'draft' ||
        entry.statusInfo.status == 'registered_guardian';

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          // --- TOP HEADER: Contract Info & Status ---
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: contractTypeColor.withValues(alpha: 0.05),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
              border: Border(
                bottom: BorderSide(
                  color: contractTypeColor.withValues(alpha: 0.1),
                ),
              ),
            ),
            child: Row(
              children: [
                // Contract Type Icon
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.05),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Icon(
                    _getTypeIcon(entry.basicInfo.contractType),
                    color: contractTypeColor,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        contractTypeName,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                          fontFamily: 'Tajawal',
                          color: AppColors.textPrimary,
                        ),
                      ),
                      if (entry.basicInfo.serialNumber > 0)
                        Text(
                          'رقم القيد: ${entry.basicInfo.serialNumber}',
                          style: TextStyle(
                            fontSize: 11,
                            color: Colors.grey[600],
                            fontFamily: 'Tajawal',
                          ),
                        ),
                    ],
                  ),
                ),
                // Status Badge
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: statusColor,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: statusColor.withValues(alpha: 0.3),
                        blurRadius: 6,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Text(
                    statusLabel,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Tajawal',
                    ),
                  ),
                ),
              ],
            ),
          ),

          // --- BODY: Parties & Date ---
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildPartyRow(
                            'الطرف الأول:',
                            entry.basicInfo.firstPartyName,
                            Icons.person,
                          ),
                          const SizedBox(height: 12),
                          if (entry.basicInfo.secondPartyName.isNotEmpty)
                            _buildPartyRow(
                              'الطرف الثاني:',
                              entry.basicInfo.secondPartyName,
                              Icons.person_outline,
                            ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 16),
                    Container(width: 1, height: 60, color: Colors.grey[200]),
                    const SizedBox(width: 16),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          'تاريخ المحرر',
                          style: TextStyle(
                            fontSize: 11,
                            color: Colors.grey[600],
                            fontFamily: 'Tajawal',
                          ),
                        ),
                        const SizedBox(height: 4),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.grey[50],
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.grey[200]!),
                          ),
                          child: Column(
                            children: [
                              Text(
                                entry.documentInfo.documentGregorianDate != null
                                    ? intl.DateFormat('yyyy/MM/dd').format(
                                        DateTime.tryParse(
                                              entry
                                                  .documentInfo
                                                  .documentGregorianDate!,
                                            ) ??
                                            DateTime.now(),
                                      )
                                    : '-',
                                style: const TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'Tajawal',
                                  color: AppColors.textPrimary,
                                ),
                              ),
                              if (entry.documentInfo.documentHijriDate != null)
                                Text(
                                  entry.documentInfo.documentHijriDate!,
                                  style: TextStyle(
                                    fontSize: 11,
                                    color: Colors.grey[500],
                                    fontFamily: 'Tajawal',
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                // --- Subject ---
                if (entry.basicInfo.subject != null &&
                    entry.basicInfo.subject!.isNotEmpty)
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.grey[50],
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey[200]!),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.subject, size: 16, color: Colors.grey),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            entry.basicInfo.subject!,
                            style: const TextStyle(
                              fontSize: 13,
                              color: AppColors.textPrimary,
                              fontFamily: 'Tajawal',
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),

                // --- Guardian Record Book Info ---
                if (entry.guardianInfo.guardianEntryNumber != null ||
                    entry.guardianInfo.guardianRecordBookNumber != null) ...[
                  const SizedBox(height: 12),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: guardianPrimary.withValues(alpha: 0.03),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: guardianPrimary.withValues(alpha: 0.15),
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.menu_book_outlined,
                          size: 16,
                          color: guardianPrimary,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'سجل الأمين',
                          style: TextStyle(
                            fontSize: 11,
                            color: Colors.grey[600],
                            fontFamily: 'Tajawal',
                          ),
                        ),
                        const Spacer(),
                        if (entry.guardianInfo.guardianEntryNumber != null)
                          _buildCompactInfo(
                            'قيد',
                            entry.guardianInfo.guardianEntryNumber.toString(),
                          ),
                        if (entry.guardianInfo.guardianRecordBookNumber !=
                            null) ...[
                          const SizedBox(width: 12),
                          _buildCompactInfo(
                            'سجل',
                            entry.guardianInfo.guardianRecordBookNumber
                                .toString(),
                          ),
                        ],
                        if (entry.guardianInfo.guardianPageNumber != null) ...[
                          const SizedBox(width: 12),
                          _buildCompactInfo(
                            'صفحة',
                            entry.guardianInfo.guardianPageNumber.toString(),
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),

          // --- ACTION BUTTONS BAR ---
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.grey[50],
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(16),
                bottomRight: Radius.circular(16),
              ),
              border: Border(top: BorderSide(color: Colors.grey[200]!)),
            ),
            child: Row(
              children: [
                // View Button
                _buildActionButton(
                  icon: Icons.visibility_outlined,
                  label: 'عرض',
                  color: guardianPrimary,
                  onTap:
                      onTap ??
                      () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                GuardianEntryDetailsScreen(entry: entry),
                          ),
                        );
                      },
                ),
                const SizedBox(width: 8),
                // Edit Button
                _buildActionButton(
                  icon: Icons.edit_outlined,
                  label: 'تعديل',
                  color: Colors.blue,
                  onTap: onEdit,
                ),
                if (canRequestDocumentation) ...[
                  const SizedBox(width: 8),
                  // Request Documentation Button
                  Expanded(
                    child: _buildActionButton(
                      icon: Icons.send_outlined,
                      label: 'طلب توثيق',
                      color: Colors.orange,
                      onTap: onRequestDocumentation,
                      isPrimary: true,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCompactInfo(String label, String value) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          '$label: ',
          style: TextStyle(
            fontSize: 11,
            color: Colors.grey[600],
            fontFamily: 'Tajawal',
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            fontFamily: 'Tajawal',
            color: AppColors.textPrimary,
          ),
        ),
      ],
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required Color color,
    VoidCallback? onTap,
    bool isPrimary = false,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: isPrimary ? color.withValues(alpha: 0.1) : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: onTap != null
                ? color.withValues(alpha: 0.3)
                : Colors.grey.withValues(alpha: 0.2),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 16, color: onTap != null ? color : Colors.grey),
            const SizedBox(width: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                fontFamily: 'Tajawal',
                color: onTap != null ? color : Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPartyRow(String label, String name, IconData icon) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: guardianPrimary.withValues(alpha: 0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, size: 14, color: guardianPrimary),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 10,
                  color: Colors.grey[600],
                  fontFamily: 'Tajawal',
                ),
              ),
              Text(
                name,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'Tajawal',
                  color: AppColors.textPrimary,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Color _parseColor(String? colorName) {
    if (colorName == null || colorName.isEmpty) return guardianPrimary;
    switch (colorName.toLowerCase()) {
      case 'success':
      case 'green':
        return AppColors.success;
      case 'danger':
      case 'error':
      case 'red':
        return AppColors.error;
      case 'warning':
      case 'orange':
        return Colors.orange;
      case 'info':
      case 'blue':
        return Colors.blue;
      case 'primary':
        return guardianPrimary;
      case 'gray':
      case 'grey':
        return Colors.grey;
      default:
        // Try parsing hex
        if (colorName.startsWith('#')) {
          try {
            return Color(
              int.parse(colorName.substring(1), radix: 16) + 0xFF000000,
            );
          } catch (_) {}
        }
        return Colors.grey;
    }
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'documented':
      case 'approved':
      case 'completed':
        return AppColors.success;
      case 'rejected':
        return AppColors.error;
      case 'pending_documentation':
      case 'pending':
        return Colors.orange;
      case 'registered_guardian':
        return Colors.blue;
      case 'draft':
      default:
        return Colors.grey;
    }
  }

  String _getStatusLabel(String status) {
    switch (status.toLowerCase()) {
      case 'documented':
        return 'موثق';
      case 'approved':
      case 'completed':
        return 'مكتمل';
      case 'rejected':
        return 'مرفوض';
      case 'pending_documentation':
      case 'pending':
        return 'بانتظار التوثيق';
      case 'registered_guardian':
        return 'مقيد لدى الأمين';
      case 'draft':
        return 'مسودة';
      default:
        return status;
    }
  }

  IconData _getTypeIcon(ContractType? type) {
    if (type == null) return Icons.description_outlined;
    switch (type.id) {
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
        return Icons.shopping_cart_outlined; // مبيع
      default:
        return Icons.description_outlined;
    }
  }
}
