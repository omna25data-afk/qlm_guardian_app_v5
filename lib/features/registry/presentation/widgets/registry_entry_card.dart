import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart' as intl;
import '../../data/models/registry_entry_model.dart';
import '../../data/models/contract_type_model.dart';
import '../../../../core/theme/app_colors.dart';

import '../screens/entry_details_screen.dart';

class RegistryEntryCard extends ConsumerWidget {
  final RegistryEntryModel entry;
  final VoidCallback? onTap;

  const RegistryEntryCard({super.key, required this.entry, this.onTap});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Use backend-provided status colors and labels if available
    final statusColor = entry.statusColor != null
        ? _parseColor(entry.statusColor!)
        : _getStatusColor(entry.status ?? 'draft');
    final statusLabel =
        entry.statusLabel ?? _getStatusLabel(entry.status ?? 'draft');

    final contractTypeName = entry.contractType?.name ?? 'محرر غير محدد';

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
      child: InkWell(
        onTap:
            onTap ??
            () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => EntryDetailsScreen(entry: entry),
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
                color: statusColor.withValues(alpha: 0.05),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
                ),
                border: Border(
                  bottom: BorderSide(color: statusColor.withValues(alpha: 0.1)),
                ),
              ),
              child: Row(
                children: [
                  // Contract Type Icon & Name
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
                      _getTypeIcon(entry.contractType),
                      color: AppColors.primary,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Column(
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
                      if (entry.serialNumber != null)
                        Text(
                          'رقم القيد: ${entry.serialNumber}',
                          style: TextStyle(
                            fontSize: 11,
                            color: Colors.grey[600],
                            fontFamily: 'Tajawal',
                          ),
                        ),
                    ],
                  ),
                  const Spacer(),
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

            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // --- Parties & Date ---
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildPartyRow(
                              'الطرف الأول:',
                              entry.firstPartyName ?? '-',
                              Icons.person,
                            ),
                            const SizedBox(height: 12),
                            if (entry.secondPartyName != null &&
                                entry.secondPartyName!.isNotEmpty)
                              _buildPartyRow(
                                'الطرف الثاني:',
                                entry.secondPartyName!,
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
                                  entry.date != null
                                      ? intl.DateFormat(
                                          'yyyy/MM/dd',
                                          'ar',
                                        ).format(entry.date!)
                                      : '-',
                                  style: const TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'Tajawal',
                                    color: AppColors.textPrimary,
                                  ),
                                ),
                                if (entry.hijriDate != null)
                                  Text(
                                    entry.hijriDate!,
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

                  const SizedBox(height: 20),

                  // --- Subject & Stats ---
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.grey[50],
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey[200]!),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(
                              Icons.subject,
                              size: 16,
                              color: Colors.grey,
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                entry.subject ?? 'لا يوجد موضوع',
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
                        if (entry.totalAmount > 0) ...[
                          const Padding(
                            padding: EdgeInsets.symmetric(vertical: 8),
                            child: Divider(height: 1),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'إجمالي المبلغ',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey[600],
                                  fontFamily: 'Tajawal',
                                ),
                              ),
                              Text(
                                '${intl.NumberFormat('#,##0.00', 'ar').format(entry.totalAmount)} ر.ي',
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.primary,
                                  fontFamily: 'Tajawal',
                                ),
                              ),
                            ],
                          ),
                        ],
                      ],
                    ),
                  ),

                  // --- Footer Actions ---
                  // Can add actions here if needed (Edit, Delete, etc.)
                ],
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
            color: AppColors.primary.withValues(alpha: 0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, size: 14, color: AppColors.primary),
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

  Widget _buildDocInfoItem({
    required String label,
    required String value,
    bool isHighlighted = false,
    MaterialColor? color,
  }) {
    final themeColor = color ?? Colors.green;
    return Column(
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 10,
            color: themeColor[700],
            fontFamily: 'Tajawal',
          ),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: isHighlighted ? themeColor[800] : themeColor[900],
            fontFamily: 'Tajawal',
          ),
        ),
      ],
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

  IconData _getTypeIcon(ContractTypeModel? type) {
    // If we had icon mapping logic or icon data from backend for ContractType
    // For now return generic or map based on name if possible
    if (type == null) return Icons.description_outlined;
    return Icons
        .description; // Placeholder, ideally mapped from type.icon string
  }
}
