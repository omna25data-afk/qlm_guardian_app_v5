import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart' as intl;
import '../../data/models/registry_entry_model.dart';
import '../../data/models/contract_type_model.dart';
import '../../../../core/theme/app_colors.dart';
import '../providers/entries_provider.dart';

class RegistryEntryCard extends ConsumerWidget {
  final RegistryEntryModel entry;
  final VoidCallback? onTap;

  const RegistryEntryCard({super.key, required this.entry, this.onTap});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final statusColor = _getStatusColor(entry.status ?? 'draft');
    final statusLabel = _getStatusLabel(entry.status ?? 'draft');
    final contractTypesMap = ref.watch(contractTypeMapProvider);
    final contractType = contractTypesMap[entry.contractTypeId];

    return Card(
      elevation: 3,
      shadowColor: Colors.black12,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      margin: const EdgeInsets.only(bottom: 16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Column(
          children: [
            // --- TOP HEADER: Contract Info & Status ---
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.05),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
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
                      border: Border.all(
                        color: AppColors.primary.withValues(alpha: 0.2),
                      ),
                    ),
                    child: Icon(
                      _getTypeIcon(contractType),
                      color: AppColors.primary,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    contractType?.name ?? 'محرر غير محدد',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      fontFamily: 'Tajawal',
                      color: AppColors.primary,
                    ),
                  ),
                  const Spacer(),
                  // Status Badge
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: statusColor.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: statusColor.withValues(alpha: 0.3),
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 6,
                          height: 6,
                          decoration: BoxDecoration(
                            color: statusColor,
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          statusLabel,
                          style: TextStyle(
                            fontSize: 12,
                            color: statusColor,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Tajawal',
                          ),
                        ),
                      ],
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
                            const SizedBox(height: 8),
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
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            'تاريخ المحرر',
                            style: TextStyle(
                              fontSize: 10,
                              color: Colors.grey[600],
                              fontFamily: 'Tajawal',
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            entry.date != null
                                ? intl.DateFormat(
                                    'yyyy/MM/dd',
                                    'ar',
                                  ).format(entry.date!)
                                : '-',
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Tajawal',
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),

                  const Divider(height: 24),

                  // --- DOCUMENTATION DATA (Green Area) ---
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF0FDF4), // Green-50
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: const Color(0xFFBBF7D0),
                      ), // Green-200
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            _buildDocInfoItem(
                              label: 'رقم القيد',
                              value: entry.docEntryNumber?.toString() ?? '-',
                              isHighlighted: true,
                            ),
                            const SizedBox(width: 12),
                            Container(
                              width: 1,
                              height: 24,
                              color: Colors.green.withValues(alpha: 0.3),
                            ),
                            const SizedBox(width: 12),
                            _buildDocInfoItem(
                              label: 'رقم الصفحة',
                              value: entry.docPageNumber?.toString() ?? '-',
                            ),
                            const SizedBox(width: 12),
                            Container(
                              width: 1,
                              height: 24,
                              color: Colors.green.withValues(alpha: 0.3),
                            ),
                            const SizedBox(width: 12),
                            _buildDocInfoItem(
                              label: 'رقم السجل',
                              value:
                                  entry.docRecordBookNumber?.toString() ?? '-',
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.event_available,
                              size: 14,
                              color: Colors.green,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              'تاريخ التوثيق: ',
                              style: TextStyle(
                                fontSize: 11,
                                color: Colors.green[800],
                                fontFamily: 'Tajawal',
                              ),
                            ),
                            Text(
                              '${entry.docHijriDate ?? '-'} هـ  |  ${entry.documentGregorianDate != null ? intl.DateFormat('yyyy/MM/dd').format(entry.documentGregorianDate!) : '-'} م',
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                color: Colors.green[900],
                                fontFamily: 'Tajawal',
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
          ],
        ),
      ),
    );
  }

  Widget _buildPartyRow(String label, String name, IconData icon) {
    return Row(
      children: [
        Icon(icon, size: 16, color: Colors.grey[600]),
        const SizedBox(width: 6),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
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
  }) {
    return Column(
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 10,
            color: Colors.green[700],
            fontFamily: 'Tajawal',
          ),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: isHighlighted
                ? const Color(0xFF15803D)
                : Colors.green[900], // Green-700 or 900
            fontFamily: 'Tajawal',
          ),
        ),
      ],
    );
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
