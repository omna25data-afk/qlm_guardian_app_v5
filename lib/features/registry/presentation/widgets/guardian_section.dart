import 'package:flutter/material.dart';
import '../../../records/data/models/record_book.dart';
import '../../../../core/widgets/searchable_dropdown.dart';

class GuardianSection extends StatelessWidget {
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
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // تاريخ القيد في سجل الأمين
        const Text(
          'تاريخ القيد في سجل الأمين',
          style: TextStyle(
            fontFamily: 'Tajawal',
            fontSize: 13,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: TextFormField(
                controller: hijriDateCtrl,
                readOnly: true,
                decoration: const InputDecoration(
                  labelText: 'التاريخ الهجري',
                  prefixIcon: Icon(Icons.calendar_month, size: 20),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: TextFormField(
                controller: gregorianDateCtrl,
                readOnly: true,
                decoration: const InputDecoration(
                  labelText: 'التاريخ الميلادي',
                  prefixIcon: Icon(Icons.date_range, size: 20),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        const Divider(),
        const SizedBox(height: 12),
        // بيانات السجل
        const Text(
          'بيانات السجل',
          style: TextStyle(
            fontFamily: 'Tajawal',
            fontSize: 13,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        // Book selector in its own row
        SearchableDropdown<RecordBook>(
          label: 'سجل قيد محررات الأمين',
          hint: 'اختر السجل',
          items: guardianRecordBooks,
          itemLabelBuilder: (b) => b.compositeName,
          value: guardianRecordBookId != null
              ? guardianRecordBooks.cast<RecordBook?>().firstWhere(
                  (b) => b?.id == guardianRecordBookId,
                  orElse: () => null,
                )
              : null,
          onChanged: (book) {
            if (book != null) {
              recordBookNumberCtrl.text = book.bookNumber.toString();
              onRecordBookIdChanged(book.id);
            } else {
              recordBookNumberCtrl.clear();
              onRecordBookIdChanged(null);
            }
          },
        ),
        const SizedBox(height: 12),
        // Entry, Page, Book Number in one row
        Row(
          children: [
            Expanded(
              child: TextFormField(
                controller: entryNumberCtrl,
                decoration: const InputDecoration(
                  labelText: 'رقم القيد',
                  prefixIcon: Icon(Icons.tag, size: 20),
                ),
                keyboardType: TextInputType.number,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: TextFormField(
                controller: pageNumberCtrl,
                decoration: const InputDecoration(
                  labelText: 'رقم الصفحة',
                  prefixIcon: Icon(Icons.description, size: 20),
                ),
                keyboardType: TextInputType.number,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: TextFormField(
                controller: recordBookNumberCtrl,
                readOnly: true,
                decoration: const InputDecoration(
                  labelText: 'رقم السجل',
                  prefixIcon: Icon(Icons.menu_book, size: 20),
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
                  'سيتم تحديث رقم الصفحة ورقم القيد تلقائياً بما يتوافق مع تسلسل سجلات الأمين.',
                  style: TextStyle(color: Colors.blue, fontSize: 13),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
