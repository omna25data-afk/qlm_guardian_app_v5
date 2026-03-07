import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart' as intl;
import 'package:qlm_guardian_app_v5/core/theme/app_colors.dart';
import 'package:qlm_guardian_app_v5/features/system/data/models/registry_entry_sections.dart';
import 'package:qlm_guardian_app_v5/features/system/data/models/contract_type.dart';
import 'package:qlm_guardian_app_v5/app/guardian/features/my_records/tabs/entries/screens/guardian_entry_details_screen.dart';

class GuardianEntryCard extends ConsumerWidget {
  final RegistryEntrySections entry;
  final VoidCallback? onTap;
  final VoidCallback? onEdit;
  final VoidCallback? onRequestDocumentation;

  const GuardianEntryCard({
    super.key,
    required this.entry,
    this.onTap,
    this.onEdit,
    this.onRequestDocumentation,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Colors specific to Guardian Theme
    const Color guardianPrimary = Color(0xFF006400);

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
    final headerColor = _getContractColor(entry.basicInfo.contractTypeId);

    final canRequestDocumentation =
        entry.statusInfo.status == 'draft' ||
        entry.statusInfo.status == 'registered_guardian';

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: guardianPrimary.withValues(alpha: 0.1)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: InkWell(
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
        borderRadius: BorderRadius.circular(16),
        child: Column(
          children: [
            // --- TOP HEADER: Contract Info & Status ---
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: headerColor,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
                ),
                border: Border(
                  bottom: BorderSide(color: headerColor.withValues(alpha: 0.3)),
                ),
              ),
              child: Row(
                children: [
                  // Contract Type Icon & Name
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.2),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      _getContractIcon(entry.basicInfo.contractTypeId),
                      color: Colors.white,
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
                            color: Colors.white,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        if (entry.guardianInfo.guardianEntryNumber != null)
                          Text(
                            'رقم القيد: ${entry.guardianInfo.guardianEntryNumber}',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.white.withValues(alpha: 0.8),
                              fontFamily: 'Tajawal',
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  // Status Badge
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.1),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Text(
                      statusLabel,
                      style: TextStyle(
                        fontSize: 12,
                        color: statusColor,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Tajawal',
                      ),
                    ),
                  ),
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // --- Parties ---
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: _buildPartyRow(
                          'الطرف الأول:',
                          entry.basicInfo.firstPartyName,
                          Icons.person,
                          guardianPrimary,
                        ),
                      ),
                      if (entry.basicInfo.secondPartyName.isNotEmpty) ...[
                        const SizedBox(width: 8),
                        Expanded(
                          child: _buildPartyRow(
                            'الطرف الثاني:',
                            entry.basicInfo.secondPartyName,
                            Icons.person_outline,
                            guardianPrimary,
                          ),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 16),

                  // --- Dates ---
                  Row(
                    children: [
                      Expanded(
                        child: _buildInfoBox(
                          'تاريخ التحرير (هجري)',
                          entry.documentInfo.documentHijriDate ?? '-',
                          Icons.calendar_today,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: _buildInfoBox(
                          'تاريخ التحرير (ميلادي)',
                          entry.documentInfo.documentGregorianDate != null
                              ? intl.DateFormat('yyyy/MM/dd', 'ar').format(
                                  DateTime.tryParse(
                                        entry
                                            .documentInfo
                                            .documentGregorianDate!,
                                      ) ??
                                      DateTime.now(),
                                )
                              : '-',
                          Icons.event,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // --- Guardian Info ---
                  Row(
                    children: [
                      Expanded(
                        child: _buildInfoBox(
                          'م القيد في السجل',
                          entry.guardianInfo.guardianEntryNumber?.toString() ??
                              '-',
                          Icons.numbers,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: _buildInfoBox(
                          'م الصفحة',
                          entry.guardianInfo.guardianPageNumber?.toString() ??
                              '-',
                          Icons.find_in_page,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: _buildInfoBox(
                          'م السجل',
                          entry.guardianInfo.guardianRecordBookNumber
                                  ?.toString() ??
                              '-',
                          Icons.menu_book,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // --- ACTION BUTTONS BAR ---
            if (onTap != null ||
                onEdit != null ||
                onRequestDocumentation != null)
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
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
                    if (onEdit != null)
                      _buildActionButton(
                        icon: Icons.edit_outlined,
                        label: 'تعديل',
                        color: Colors.blue,
                        onTap: onEdit,
                      ),
                    if (canRequestDocumentation &&
                        onRequestDocumentation != null) ...[
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
      ),
    );
  }

  Widget _buildPartyRow(
    String label,
    String name,
    IconData icon,
    Color primaryColor,
  ) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: primaryColor.withValues(alpha: 0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, size: 14, color: primaryColor),
        ),
        const SizedBox(width: 8),
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
                  fontWeight: FontWeight.bold,
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

  Widget _buildInfoBox(String label, String value, IconData icon) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.grey[50], // Very light background
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 12, color: Colors.grey[600]),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  label,
                  style: TextStyle(
                    fontSize: 10,
                    color: Colors.grey[600],
                    fontFamily: 'Tajawal',
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
              fontFamily: 'Tajawal',
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  // Parse color string from backend (e.g. 'success', 'danger', 'primary', or hex)
  Color _parseColor(String colorName) {
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
        return AppColors.primary;
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

  Color _getContractColor(int? typeId) {
    switch (typeId) {
      case 1:
        return const Color(0xFFE91E63); // وردي للزواج
      case 4:
        return const Color(0xFF795548); // بني للوكالات
      case 5:
        return const Color(0xFF009688); // أخضر مزرق للتصرفيات
      case 6:
        return const Color(0xFF673AB7); // بنفسجي للقسمة
      case 7:
        return const Color(0xFFF44336); // أحمر للطلاق
      case 8:
        return const Color(0xFFFF5722); // برتقالي للرجعة
      case 10:
        return const Color(0xFF4CAF50); // أخضر للمبيعات
      default:
        return const Color(0xFF006400); // Guardian primary
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
        return Icons.shopping_cart_outlined; // مبيع
      default:
        return Icons.description_outlined;
    }
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
                color: onTap != null ? color : Colors.grey,
                fontWeight: isPrimary ? FontWeight.bold : FontWeight.w500,
                fontFamily: 'Tajawal',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
