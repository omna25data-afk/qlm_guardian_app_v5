import 'package:flutter/material.dart';
import 'package:hijri/hijri_calendar.dart';
import 'package:hijri_picker/hijri_picker.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/searchable_dropdown.dart';
import '../../../records/data/models/record_book.dart';

class DocumentationSection extends StatelessWidget {
  final int? selectedContractTypeId;
  final int? selectedDocRecordBookId;
  final List<RecordBook> filteredRecordBooks;
  final TextEditingController docHijriDateCtrl;
  final TextEditingController docGregorianDateCtrl;
  final TextEditingController docRecordBookNumberCtrl;
  final TextEditingController docPageNumberCtrl;
  final TextEditingController docEntryNumberCtrl;
  final TextEditingController feeAmountCtrl;
  final TextEditingController penaltyAmountCtrl;
  final TextEditingController supportAmountCtrl;
  final TextEditingController sustainabilityAmountCtrl;
  final TextEditingController totalAmountCtrl;
  final TextEditingController receiptNumberCtrl;
  final TextEditingController taxAmountCtrl;
  final TextEditingController taxReceiptNumberCtrl;
  final TextEditingController zakatAmountCtrl;
  final TextEditingController zakatReceiptNumberCtrl;
  final TextEditingController exemptionReasonCtrl;
  final bool isExempted;
  final bool hasAuthenticationFee;
  final bool hasTransferFee;
  final bool hasOtherFee;
  final ValueChanged<int?> onDocRecordBookChanged;
  final ValueChanged<bool> onExemptedChanged;
  final ValueChanged<bool> onAuthFeeChanged;
  final ValueChanged<bool> onTransferFeeChanged;
  final ValueChanged<bool> onOtherFeeChanged;
  final VoidCallback onFeesRecalculate;

  const DocumentationSection({
    super.key,
    required this.selectedContractTypeId,
    required this.selectedDocRecordBookId,
    required this.filteredRecordBooks,
    required this.docHijriDateCtrl,
    required this.docGregorianDateCtrl,
    required this.docRecordBookNumberCtrl,
    required this.docPageNumberCtrl,
    required this.docEntryNumberCtrl,
    required this.feeAmountCtrl,
    required this.penaltyAmountCtrl,
    required this.supportAmountCtrl,
    required this.sustainabilityAmountCtrl,
    required this.totalAmountCtrl,
    required this.receiptNumberCtrl,
    required this.taxAmountCtrl,
    required this.taxReceiptNumberCtrl,
    required this.zakatAmountCtrl,
    required this.zakatReceiptNumberCtrl,
    required this.exemptionReasonCtrl,
    required this.isExempted,
    required this.hasAuthenticationFee,
    required this.hasTransferFee,
    required this.hasOtherFee,
    required this.onDocRecordBookChanged,
    required this.onExemptedChanged,
    required this.onAuthFeeChanged,
    required this.onTransferFeeChanged,
    required this.onOtherFeeChanged,
    required this.onFeesRecalculate,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Doc Record Book Selector
        if (filteredRecordBooks.isNotEmpty) ...[
          SearchableDropdown<RecordBook>(
            items: filteredRecordBooks,
            label: 'سجل التوثيق النهائي',
            value: selectedDocRecordBookId != null
                ? filteredRecordBooks.firstWhere(
                    (b) => b.id == selectedDocRecordBookId,
                    orElse: () => filteredRecordBooks.first,
                  )
                : null,
            itemLabelBuilder: (b) =>
                '${b.categoryLabel ?? b.category} - ${b.name} - رقم ${b.bookNumber} لسنة ${b.hijriYear}هـ',
            onChanged: (v) => onDocRecordBookChanged(v?.id),
          ),
          const SizedBox(height: 16),
        ],

        // Doc Date
        Row(
          children: [
            Expanded(
              child: TextFormField(
                controller: docHijriDateCtrl,
                readOnly: true,
                decoration: const InputDecoration(
                  labelText: 'تاريخ التوثيق (هـ)',
                  prefixIcon: Icon(Icons.calendar_month, size: 20),
                ),
                onTap: () => _selectHijriDate(context),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: TextFormField(
                controller: docGregorianDateCtrl,
                readOnly: true,
                decoration: const InputDecoration(
                  labelText: 'تاريخ التوثيق (م)',
                  prefixIcon: Icon(Icons.date_range, size: 20),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),

        // Record book details
        Row(
          children: [
            Expanded(
              child: TextFormField(
                controller: docRecordBookNumberCtrl,
                decoration: const InputDecoration(
                  labelText: 'رقم السجل',
                  prefixIcon: Icon(Icons.book, size: 20),
                ),
                keyboardType: TextInputType.number,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: TextFormField(
                controller: docPageNumberCtrl,
                decoration: const InputDecoration(
                  labelText: 'رقم الصفحة',
                  prefixIcon: Icon(Icons.description, size: 20),
                ),
                keyboardType: TextInputType.number,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: TextFormField(
                controller: docEntryNumberCtrl,
                decoration: const InputDecoration(
                  labelText: 'رقم القيد',
                  prefixIcon: Icon(Icons.tag, size: 20),
                ),
                keyboardType: TextInputType.number,
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),

        // Tax and Zakat Section
        const Text(
          'البيانات المالية (الضريبة والزكاة)',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: TextFormField(
                controller: taxAmountCtrl,
                decoration: const InputDecoration(
                  labelText: 'مبلغ الضريبة',
                  prefixIcon: Icon(Icons.attach_money, size: 20),
                ),
                keyboardType: TextInputType.number,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: TextFormField(
                controller: taxReceiptNumberCtrl,
                decoration: const InputDecoration(
                  labelText: 'رقم السند (الضريبة)',
                  prefixIcon: Icon(Icons.receipt_long, size: 20),
                ),
                keyboardType: TextInputType.number,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: TextFormField(
                controller: zakatAmountCtrl,
                decoration: const InputDecoration(
                  labelText: 'مبلغ الزكاة',
                  prefixIcon: Icon(Icons.attach_money, size: 20),
                ),
                keyboardType: TextInputType.number,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: TextFormField(
                controller: zakatReceiptNumberCtrl,
                decoration: const InputDecoration(
                  labelText: 'رقم السند (الزكاة)',
                  prefixIcon: Icon(Icons.receipt_long, size: 20),
                ),
                keyboardType: TextInputType.number,
              ),
            ),
          ],
        ),
        const SizedBox(height: 32),
        const Divider(),
        const SizedBox(height: 16),

        const Text(
          'الرسوم وتوزيعاتها',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        const SizedBox(height: 12),

        // Fee Options
        _buildFeeOptions(),
        const SizedBox(height: 12),

        // Exemption switch
        Container(
          decoration: BoxDecoration(
            color: isExempted
                ? AppColors.successLight
                : AppColors.surfaceVariant,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: isExempted ? AppColors.success : AppColors.border,
            ),
          ),
          child: SwitchListTile(
            title: Text(
              'معفي من الرسوم',
              style: TextStyle(
                fontFamily: 'Tajawal',
                fontWeight: FontWeight.w600,
                fontSize: 14,
                color: isExempted ? AppColors.success : AppColors.textPrimary,
              ),
            ),
            secondary: Icon(
              Icons.money_off,
              color: isExempted ? AppColors.success : AppColors.textSecondary,
            ),
            value: isExempted,
            onChanged: (v) {
              onExemptedChanged(v);
              onFeesRecalculate();
            },
            activeTrackColor: AppColors.success.withValues(alpha: 0.5),
            dense: true,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
        const SizedBox(height: 16),

        if (isExempted) ...[
          const SizedBox(height: 12),
          TextFormField(
            controller: exemptionReasonCtrl,
            decoration: const InputDecoration(
              labelText: 'سبب الإعفاء',
              prefixIcon: Icon(Icons.edit_note, size: 20),
            ),
            maxLines: 2,
          ),
        ] else ...[
          // Fee Fields
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: feeAmountCtrl,
                  decoration: const InputDecoration(
                    labelText: 'رسوم التوثيق',
                    prefixIcon: Icon(Icons.attach_money, size: 20),
                  ),
                  keyboardType: TextInputType.number,
                  onChanged: (_) => onFeesRecalculate(),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: TextFormField(
                  controller: penaltyAmountCtrl,
                  decoration: const InputDecoration(
                    labelText: 'الغرامة (مع التأخير)',
                    prefixIcon: Icon(Icons.warning_amber, size: 20),
                  ),
                  keyboardType: TextInputType.number,
                  onChanged: (_) => onFeesRecalculate(),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: supportAmountCtrl,
                  decoration: const InputDecoration(
                    labelText: 'الدعم',
                    prefixIcon: Icon(Icons.volunteer_activism, size: 20),
                  ),
                  keyboardType: TextInputType.number,
                  onChanged: (_) => onFeesRecalculate(),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: TextFormField(
                  controller: sustainabilityAmountCtrl,
                  decoration: const InputDecoration(
                    labelText: 'الاستدامة',
                    prefixIcon: Icon(Icons.eco, size: 20),
                  ),
                  keyboardType: TextInputType.number,
                  onChanged: (_) => onFeesRecalculate(),
                ),
              ),
            ],
          ),
        ],

        const SizedBox(height: 24),
        // Fee Summary Expansion
        ExpansionTile(
          title: const Text(
            'ملخص إجمالي الرسوم',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: AppColors.primary,
            ),
          ),
          initiallyExpanded: true,
          childrenPadding: const EdgeInsets.all(16),
          backgroundColor: AppColors.primary.withValues(alpha: 0.02),
          collapsedBackgroundColor: AppColors.surfaceVariant,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
            side: BorderSide(color: AppColors.border),
          ),
          collapsedShape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
            side: BorderSide(color: AppColors.border),
          ),
          children: [
            TextFormField(
              controller: totalAmountCtrl,
              readOnly: true,
              decoration: const InputDecoration(
                labelText: 'الإجمالي الكلي للرسوم',
                prefixIcon: Icon(Icons.calculate, size: 20),
              ),
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: AppColors.primary,
              ),
            ),
          ],
        ),

        const SizedBox(height: 16),
        // Fee Distribution (Read Only)
        ExpansionTile(
          title: const Text(
            'تفاصيل توزيع الرسوم',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: AppColors.textSecondary,
            ),
          ),
          initiallyExpanded: false,
          childrenPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 8,
          ),
          backgroundColor: AppColors.surface,
          collapsedBackgroundColor: AppColors.surfaceVariant,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
            side: BorderSide(color: AppColors.border),
          ),
          collapsedShape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
            side: BorderSide(color: AppColors.border),
          ),
          children: [
            _buildDistributionRow('إيراد محلي (80%)', _calculatePercent(0.80)),
            const Divider(height: 16),
            _buildDistributionRow('حافز (5%)', _calculatePercent(0.05)),
            const Divider(height: 16),
            _buildDistributionRow('تجهيز محاكم (15%)', _calculatePercent(0.15)),
            const Divider(height: 16),
            _buildDistributionRow(
              'دعم قضاء (12.5% من الإجمالي الإضافي)',
              _calculateAdditionalPercent(0.125),
            ),
            const Divider(height: 16),
            _buildDistributionRow(
              'حافز تطوير (12.5% من الإجمالي الإضافي)',
              _calculateAdditionalPercent(0.125),
            ),
          ],
        ),
      ],
    );
  }

  String _calculatePercent(double pct) {
    if (isExempted) return '0.00';
    final fee = double.tryParse(feeAmountCtrl.text) ?? 0.0;
    return (fee * pct).toStringAsFixed(2);
  }

  String _calculateAdditionalPercent(double pct) {
    if (isExempted) return '0.00';
    final fee = double.tryParse(feeAmountCtrl.text) ?? 0.0;
    return (fee * pct).toStringAsFixed(2);
  }

  Widget _buildDistributionRow(String label, String amount) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 14,
              color: AppColors.textSecondary,
            ),
          ),
          Text(
            '$amount ر.ي',
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeeOptions() {
    return Row(
      children: [
        _buildFeeChip(
          'توثيق',
          hasAuthenticationFee,
          Icons.verified,
          (v) => onAuthFeeChanged(v),
        ),
        const SizedBox(width: 8),
        _buildFeeChip(
          'نقل ملكية',
          hasTransferFee,
          Icons.swap_horiz,
          (v) => onTransferFeeChanged(v),
        ),
        const SizedBox(width: 8),
        _buildFeeChip(
          'أخرى',
          hasOtherFee,
          Icons.more_horiz,
          (v) => onOtherFeeChanged(v),
        ),
      ],
    );
  }

  Widget _buildFeeChip(
    String label,
    bool isActive,
    IconData icon,
    ValueChanged<bool> onChanged,
  ) {
    return Expanded(
      child: GestureDetector(
        onTap: () {
          onChanged(!isActive);
          onFeesRecalculate();
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 6),
          decoration: BoxDecoration(
            color: isActive
                ? AppColors.accent.withValues(alpha: 0.12)
                : AppColors.surfaceVariant,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: isActive ? AppColors.accent : AppColors.border,
              width: isActive ? 1.5 : 1,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 16,
                color: isActive ? AppColors.accent : AppColors.textSecondary,
              ),
              const SizedBox(width: 4),
              Flexible(
                child: Text(
                  label,
                  style: TextStyle(
                    fontFamily: 'Tajawal',
                    fontSize: 11,
                    fontWeight: isActive ? FontWeight.bold : FontWeight.w500,
                    color: isActive
                        ? AppColors.accent
                        : AppColors.textSecondary,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _selectHijriDate(BuildContext context) async {
    final picked = await showHijriDatePicker(
      context: context,
      initialDate: HijriCalendar.now(),
      firstDate: HijriCalendar()
        ..hYear = 1440
        ..hMonth = 1
        ..hDay = 1,
      lastDate: HijriCalendar()
        ..hYear = 1460
        ..hMonth = 12
        ..hDay = 29,
    );
    if (picked != null) {
      docHijriDateCtrl.text = picked.toString();
      final greg = picked.hijriToGregorian(
        picked.hYear,
        picked.hMonth,
        picked.hDay,
      );
      docGregorianDateCtrl.text =
          '${greg.year}-${greg.month.toString().padLeft(2, '0')}-${greg.day.toString().padLeft(2, '0')}';
      onFeesRecalculate();
    }
  }
}
