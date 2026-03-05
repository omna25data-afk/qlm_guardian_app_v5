import 'package:flutter/material.dart';
import 'package:hijri/hijri_calendar.dart';
import 'package:hijri_picker/hijri_picker.dart';
import '../../../records/data/models/record_book.dart';
import '../../../../core/widgets/searchable_dropdown.dart';
import '../../../../core/theme/app_colors.dart';

class GuardianSection extends StatefulWidget {
  final int? guardianRecordBookId;
  final List<RecordBook> guardianRecordBooks;
  final TextEditingController recordBookNumberCtrl;
  final TextEditingController pageNumberCtrl;
  final TextEditingController entryNumberCtrl;
  final TextEditingController hijriDateCtrl;
  final TextEditingController gregorianDateCtrl;
  final ValueChanged<int?> onRecordBookIdChanged;

  const GuardianSection({
    super.key,
    required this.guardianRecordBookId,
    required this.guardianRecordBooks,
    required this.recordBookNumberCtrl,
    required this.pageNumberCtrl,
    required this.entryNumberCtrl,
    required this.hijriDateCtrl,
    required this.gregorianDateCtrl,
    required this.onRecordBookIdChanged,
  });

  @override
  State<GuardianSection> createState() => _GuardianSectionState();
}

class _GuardianSectionState extends State<GuardianSection> {
  bool _useDifferentDate = false;

  @override
  void initState() {
    super.initState();
    // الاختيار التلقائي للحاوية المركزية إذا لم يتم اختيار واحدة بعد
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _autoSelectContainer();
    });
  }

  @override
  void didUpdateWidget(covariant GuardianSection oldWidget) {
    super.didUpdateWidget(oldWidget);
    // عند تحديث قائمة السجلات (بعد تحميلها)، اختر الحاوية تلقائياً
    if (oldWidget.guardianRecordBooks != widget.guardianRecordBooks) {
      _autoSelectContainer();
    }
  }

  /// اختيار الحاوية المركزية تلقائياً
  /// الحاوية هي السجل ذو book_number == 0 (أو الأول في القائمة)
  void _autoSelectContainer() {
    if (widget.guardianRecordBookId != null) return;
    if (widget.guardianRecordBooks.isEmpty) return;

    // ابحث عن الحاوية المركزية (book_number == 0)
    final container = widget.guardianRecordBooks.cast<RecordBook?>().firstWhere(
      (b) => b?.bookNumber == 0,
      orElse: () => widget.guardianRecordBooks.first,
    );

    if (container != null) {
      widget.onRecordBookIdChanged(container.id);
    }
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
      widget.hijriDateCtrl.text =
          '${picked.hYear}-${picked.hMonth.toString().padLeft(2, '0')}-${picked.hDay.toString().padLeft(2, '0')}';
      final greg = picked.hijriToGregorian(
        picked.hYear,
        picked.hMonth,
        picked.hDay,
      );
      widget.gregorianDateCtrl.text =
          '${greg.year}-${greg.month.toString().padLeft(2, '0')}-${greg.day.toString().padLeft(2, '0')}';
    }
  }

  @override
  Widget build(BuildContext context) {
    // العثور على الحاوية المختارة
    final selectedContainer = widget.guardianRecordBookId != null
        ? widget.guardianRecordBooks.cast<RecordBook?>().firstWhere(
            (b) => b?.id == widget.guardianRecordBookId,
            orElse: () => null,
          )
        : null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Toggle for different guardian date
        Container(
          decoration: BoxDecoration(
            color: _useDifferentDate
                ? AppColors.warning.withValues(alpha: 0.08)
                : AppColors.surfaceVariant,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: _useDifferentDate ? AppColors.warning : AppColors.border,
            ),
          ),
          child: SwitchListTile(
            title: const Text(
              'تاريخ قيد مختلف عن تاريخ المحرر',
              style: TextStyle(
                fontFamily: 'Tajawal',
                fontWeight: FontWeight.w600,
                fontSize: 13,
              ),
            ),
            secondary: Icon(
              Icons.date_range,
              size: 20,
              color: _useDifferentDate
                  ? AppColors.warning
                  : AppColors.textSecondary,
            ),
            value: _useDifferentDate,
            onChanged: (v) => setState(() => _useDifferentDate = v),
            dense: true,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),

        // Guardian date fields (only shown when toggle is on)
        if (_useDifferentDate) ...[
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: widget.hijriDateCtrl,
                  readOnly: true,
                  textInputAction: TextInputAction.next,
                  decoration: const InputDecoration(
                    labelText: 'التاريخ الهجري',
                    hintText: 'اختر التاريخ',
                    hintStyle: TextStyle(color: Colors.grey, fontSize: 12),
                    prefixIcon: Icon(Icons.calendar_month, size: 20),
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                  ),
                  onTap: () => _selectHijriDate(context),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: TextFormField(
                  controller: widget.gregorianDateCtrl,
                  readOnly: true,
                  textInputAction: TextInputAction.next,
                  decoration: const InputDecoration(
                    labelText: 'التاريخ الميلادي',
                    hintText: 'يتحدث تلقائياً',
                    hintStyle: TextStyle(color: Colors.grey, fontSize: 12),
                    prefixIcon: Icon(Icons.date_range, size: 20),
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                  ),
                ),
              ),
            ],
          ),
        ],
        const SizedBox(height: 16),
        const Divider(),
        const SizedBox(height: 12),

        // ══════ بيانات السجل ══════
        const Text(
          'بيانات السجل',
          style: TextStyle(
            fontFamily: 'Tajawal',
            fontSize: 13,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),

        // ── الحاوية المركزية (تُعيَّن تلقائياً) ──
        if (selectedContainer != null)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            decoration: BoxDecoration(
              color: const Color(0xFF006400).withValues(alpha: 0.06),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: const Color(0xFF006400).withValues(alpha: 0.3),
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: const Color(0xFF006400).withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.folder_open,
                    color: Color(0xFF006400),
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'السجل العام',
                        style: TextStyle(
                          fontSize: 11,
                          color: Colors.grey[600],
                          fontFamily: 'Tajawal',
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        selectedContainer.contractType.isNotEmpty
                            ? selectedContainer.contractType
                            : selectedContainer.name,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF006400),
                          fontFamily: 'Tajawal',
                        ),
                      ),
                    ],
                  ),
                ),
                const Icon(
                  Icons.check_circle,
                  color: Color(0xFF006400),
                  size: 20,
                ),
              ],
            ),
          )
        else if (widget.guardianRecordBooks.isEmpty)
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.orange.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.orange.withValues(alpha: 0.3)),
            ),
            child: Row(
              children: [
                const Icon(Icons.warning_amber, color: Colors.orange, size: 20),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'لم يتم العثور على سجل أمين لهذا النوع. يرجى التواصل مع المسؤول.',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.orange[800],
                      fontFamily: 'Tajawal',
                    ),
                  ),
                ),
              ],
            ),
          ),

        const SizedBox(height: 12),

        // ── رقم الدفتر الفعلي (يُدخل يدوياً) ──
        TextFormField(
          controller: widget.recordBookNumberCtrl,
          textInputAction: TextInputAction.next,
          decoration: const InputDecoration(
            labelText: 'رقم الدفتر *',
            hintText: 'أدخل رقم الدفتر الفعلي',
            hintStyle: TextStyle(color: Colors.grey, fontSize: 12),
            prefixIcon: Icon(Icons.menu_book, size: 20),
            floatingLabelBehavior: FloatingLabelBehavior.always,
          ),
          keyboardType: TextInputType.number,
        ),
        const SizedBox(height: 12),

        // Entry, Page numbers
        Row(
          children: [
            Expanded(
              child: TextFormField(
                controller: widget.entryNumberCtrl,
                textInputAction: TextInputAction.next,
                decoration: const InputDecoration(
                  labelText: 'رقم القيد',
                  hintText: 'رقم القيد',
                  hintStyle: TextStyle(color: Colors.grey, fontSize: 12),
                  prefixIcon: Icon(Icons.tag, size: 20),
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                ),
                keyboardType: TextInputType.number,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: TextFormField(
                controller: widget.pageNumberCtrl,
                textInputAction: TextInputAction.next,
                decoration: const InputDecoration(
                  labelText: 'رقم الصفحة',
                  hintText: 'رقم الصفحة',
                  hintStyle: TextStyle(color: Colors.grey, fontSize: 12),
                  prefixIcon: Icon(Icons.description, size: 20),
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                ),
                keyboardType: TextInputType.number,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),

        // Info message
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.blue.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.blue.shade200),
          ),
          child: const Row(
            children: [
              Icon(Icons.info_outline, color: Colors.blue, size: 20),
              SizedBox(width: 12),
              Expanded(
                child: Text(
                  'أدخل رقم الدفتر الفيزيائي الفعلي الذي تم تسجيل المحرر فيه. السجل العام يُعيَّن تلقائياً بحسب نوع العقد.',
                  style: TextStyle(color: Colors.blue, fontSize: 12),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
