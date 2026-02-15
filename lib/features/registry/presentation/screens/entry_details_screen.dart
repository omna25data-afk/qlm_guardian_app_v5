import 'package:flutter/material.dart';
import 'package:intl/intl.dart' as intl;
import '../../data/models/registry_entry_model.dart';
import '../../data/models/contract_type_model.dart';
import '../../../../core/theme/app_colors.dart';

class EntryDetailsScreen extends StatelessWidget {
  final RegistryEntryModel entry;

  const EntryDetailsScreen({super.key, required this.entry});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('تفاصيل القيد'), centerTitle: true),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- Header Section ---
            _buildHeaderSection(),
            const SizedBox(height: 24),

            // --- Documentation Info (Court) ---
            _buildSectionTitle('بيانات التوثيق (قلم المحكمة)'),
            _buildInfoCard([
              _buildInfoRow(
                'رقم القيد',
                entry.docEntryNumber?.toString() ?? '-',
              ),
              _buildInfoRow(
                'رقم السجل',
                entry.docRecordBookNumber?.toString() ?? '-',
              ),
              _buildInfoRow(
                'رقم الصفحة',
                entry.docPageNumber?.toString() ?? '-',
              ),
              _buildInfoRow(
                'رقم الصندوق',
                entry.docBoxNumber?.toString() ?? '-',
              ),
              _buildInfoRow(
                'رقم الوثيقة',
                entry.docDocumentNumber?.toString() ?? '-',
              ),
              _buildInfoRow(
                'تاريخ التوثيق (هـ)',
                entry.docHijriDate?.split('T').first ?? '-',
              ),
              _buildInfoRow(
                'تاريخ التوثيق (م)',
                entry.docGregorianDate != null
                    ? intl.DateFormat(
                        'yyyy/MM/dd',
                      ).format(entry.docGregorianDate!)
                    : '-',
              ),
            ]),
            const SizedBox(height: 24),

            // --- Guardian Info (Personal) ---
            _buildSectionTitle('بيانات قيد الأمين'),
            _buildInfoCard([
              _buildInfoRow(
                'رقم القيد لدى الأمين',
                entry.guardianEntryNumber?.toString() ?? '-',
              ),
              _buildInfoRow(
                'رقم السجل',
                entry.guardianRecordBookNumber?.toString() ?? '-',
              ),
              _buildInfoRow(
                'رقم الصفحة',
                entry.guardianPageNumber?.toString() ?? '-',
              ),
              _buildInfoRow(
                'تاريخ القيد (هـ)',
                entry.guardianHijriDate?.split('T').first ?? '-',
              ),
            ]),
            const SizedBox(height: 24),

            // --- Parties ---
            _buildSectionTitle('الأطراف'),
            _buildInfoCard([
              _buildInfoRow('الطرف الأول', entry.firstPartyName ?? '-'),
              _buildInfoRow('الطرف الثاني', entry.secondPartyName ?? '-'),
            ]),
            const SizedBox(height: 24),

            // --- Content ---
            _buildSectionTitle('موضوع المحرر'),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'الموضوع:',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                      fontFamily: 'Tajawal',
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    entry.subject ?? '-',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Tajawal',
                    ),
                  ),
                  const Divider(height: 24),
                  Text(
                    'البنود/المحتوى:',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                      fontFamily: 'Tajawal',
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    entry.content ?? '-',
                    style: const TextStyle(
                      fontSize: 14,
                      fontFamily: 'Tajawal',
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // --- Financials ---
            _buildSectionTitle('الرسوم والمالية'),
            _buildInfoCard([
              _buildInfoRow(
                'مبلغ الرسوم',
                '${entry.feeAmount?.toStringAsFixed(2) ?? "0.00"} ر.ي',
              ),
              _buildInfoRow(
                'مبلغ الغرامة',
                '${entry.penaltyAmount?.toStringAsFixed(2) ?? "0.00"} ر.ي',
              ),
              _buildInfoRow(
                'رسوم المصادقة',
                '${entry.authenticationFeeAmount?.toStringAsFixed(2) ?? "0.00"} ر.ي',
              ),
              _buildInfoRow(
                'رسوم الانتقال',
                '${entry.transferFeeAmount?.toStringAsFixed(2) ?? "0.00"} ر.ي',
              ),
              _buildInfoRow(
                'مبلغ الدعم',
                '${entry.supportAmount?.toStringAsFixed(2) ?? "0.00"} ر.ي',
              ),
              _buildInfoRow(
                'الاستدامة',
                '${entry.sustainabilityAmount?.toStringAsFixed(2) ?? "0.00"} ر.ي',
              ),
              const Divider(),
              _buildInfoRow(
                'الإجمالي',
                '${entry.totalAmount.toStringAsFixed(2)} ر.ي',
                isBold: true,
                valueColor: AppColors.primary,
              ),
              _buildInfoRow('رقم السند', entry.receiptNumber ?? '-'),
              if (entry.exemptionType != null)
                _buildInfoRow('نوع الإعفاء', entry.exemptionType!),
            ]),
            const SizedBox(height: 24),

            // --- System Info ---
            _buildSectionTitle('معلومات النظام'),
            _buildInfoCard([
              _buildInfoRow('الحالة', _getStatusLabel(entry.status ?? 'draft')),
              _buildInfoRow(
                'تاريخ الإنشاء',
                entry.createdAt != null
                    ? intl.DateFormat(
                        'yyyy/MM/dd HH:mm',
                      ).format(entry.createdAt!)
                    : '-',
              ),
              _buildInfoRow('نوع الكاتب', entry.writerType ?? '-'),
              _buildInfoRow('اسم الكاتب', entry.writerName ?? '-'),
            ]),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderSection() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.3),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(_getTypeIcon(entry.contractType), color: Colors.white, size: 48),
          const SizedBox(height: 12),
          Text(
            entry.contractType?.name ?? 'محرر غير محدد',
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              fontFamily: 'Tajawal',
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              'الرقم المتسلسل: ${entry.serialNumber ?? "-"}',
              style: const TextStyle(
                fontSize: 14,
                color: Colors.white,
                fontFamily: 'Tajawal',
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12, right: 4),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: AppColors.primary,
          fontFamily: 'Tajawal',
        ),
      ),
    );
  }

  Widget _buildInfoCard(List<Widget> children) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2)),
        ],
      ),
      child: Column(children: children),
    );
  }

  Widget _buildInfoRow(
    String label,
    String value, {
    bool isBold = false,
    Color? valueColor,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 13,
              color: Colors.grey[600],
              fontFamily: 'Tajawal',
            ),
          ),
          Expanded(
            child: Text(
              value,
              textAlign: TextAlign.left,
              style: TextStyle(
                fontSize: 14,
                fontWeight: isBold ? FontWeight.bold : FontWeight.w500,
                color: valueColor ?? AppColors.textPrimary,
                fontFamily: 'Tajawal',
              ),
            ),
          ),
        ],
      ),
    );
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
    if (type == null) return Icons.description_outlined;
    return Icons.description;
  }
}
