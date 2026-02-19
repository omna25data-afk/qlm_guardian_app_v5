import 'package:flutter/material.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../system/data/models/registry_entry_sections.dart';

class PremiumEntryCard extends StatelessWidget {
  final RegistryEntrySections entry;
  final VoidCallback onTap;

  const PremiumEntryCard({super.key, required this.entry, required this.onTap});

  @override
  Widget build(BuildContext context) {
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
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                // Icon / Type
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Center(
                    child: Icon(
                      _getContractIcon(entry.basicInfo.contractTypeId),
                      color: AppColors.primary,
                      size: 26,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                // Content
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
                      const SizedBox(height: 6),
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
                          Icon(Icons.tag, size: 14, color: Colors.grey[500]),
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
        ),
      ),
    );
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
      case 'موثق':
        return AppColors.success;
      case 'pending':
      case 'قيد الانتظار':
        return AppColors.warning;
      case 'rejected':
      case 'مرفوض':
        return AppColors.error;
      case 'draft':
      case 'مسودة':
      default:
        return Colors.grey;
    }
  }

  String _getStatusText(String status) {
    switch (status.toLowerCase()) {
      case 'documented':
        return 'موثق';
      case 'pending':
        return 'قيد التدقيق';
      case 'rejected':
        return 'مرفوض';
      case 'draft':
        return 'مسودة';
      default:
        return status;
    }
  }

  IconData _getContractIcon(int? typeId) {
    // Basic mapping based on generic contract types
    switch (typeId) {
      case 1:
        return Icons.handshake_outlined; // Marriage/Divorce
      case 2:
        return Icons.real_estate_agent_outlined; // Real Estate
      case 3:
        return Icons.business_center_outlined; // Corporate
      default:
        return Icons.description_outlined;
    }
  }
}
