import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hijri/hijri_calendar.dart';
import 'package:hijri_picker/hijri_picker.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/searchable_dropdown.dart';
import '../../../admin/presentation/providers/add_entry_provider.dart';
import '../../../records/data/models/record_book.dart';

class DocumentationSection extends ConsumerWidget {
  final int? selectedContractTypeId;
  final int? selectedDocRecordBookId;
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
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(addEntryProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Doc Record Book Selector
        if (state.documentationRecordBooks.isNotEmpty) ...[
          SearchableDropdown<RecordBook>(
            items: state.documentationRecordBooks,
            label: 'سجل التوثيق',
            value: selectedDocRecordBookId != null
                ? state.documentationRecordBooks.firstWhere(
                    (b) => b.id == selectedDocRecordBookId,
                    orElse: () => state.documentationRecordBooks.first,
                  )
                : null,
            itemLabelBuilder: (b) => 'سجل ${b.bookNumber} - ${b.hijriYear}هـ',
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
        const SizedBox(height: 20),

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

        // Fee Fields
        Row(
          children: [
            Expanded(
              child: TextFormField(
                controller: feeAmountCtrl,
                decoration: const InputDecoration(
                  labelText: 'الرسوم',
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
                  labelText: 'الغرامة',
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
        const SizedBox(height: 12),
        TextFormField(
          controller: totalAmountCtrl,
          readOnly: true,
          decoration: InputDecoration(
            labelText: 'الإجمالي',
            prefixIcon: const Icon(Icons.calculate, size: 20),
            fillColor: AppColors.primary.withValues(alpha: 0.05),
          ),
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
            color: AppColors.primary,
          ),
        ),
      ],
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
