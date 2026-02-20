import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/add_registry_entry_provider.dart';
import '../../../records/data/models/record_book.dart';
import '../../../../core/widgets/searchable_dropdown.dart';

class GuardianSection extends ConsumerWidget {
  final int? guardianRecordBookId;
  final TextEditingController recordBookNumberCtrl;
  final TextEditingController pageNumberCtrl;
  final TextEditingController entryNumberCtrl;
  final TextEditingController hijriDateCtrl;
  final TextEditingController gregorianDateCtrl;
  final ValueChanged<int?> onRecordBookIdChanged;

  const GuardianSection({
    super.key,
    required this.guardianRecordBookId,
    required this.recordBookNumberCtrl,
    required this.pageNumberCtrl,
    required this.entryNumberCtrl,
    required this.hijriDateCtrl,
    required this.gregorianDateCtrl,
    required this.onRecordBookIdChanged,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(addRegistryEntryProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Record book number, page, entry
        Column(
          children: [
            Row(
              children: [
                Expanded(
                  flex: 2,
                  child: SearchableDropdown<RecordBook>(
                    label: 'سجل قيد محررات الأمين',
                    hint: 'اختر السجل',
                    items: state.guardianRecordBooks,
                    itemLabelBuilder: (b) =>
                        '${b.name} - رقم ${b.bookNumber} لسنة ${b.hijriYear}هـ (${b.writerName})',
                    value: state.guardianRecordBooks
                        .cast<RecordBook?>()
                        .firstWhere(
                          (b) => b?.id.toString() == recordBookNumberCtrl.text,
                          orElse: () => null,
                        ),
                    onChanged: (book) {
                      if (book != null) {
                        recordBookNumberCtrl.text = book.id.toString();
                        // Update the page and entry number if needed, or leave it to manual if they can edit
                      } else {
                        recordBookNumberCtrl.clear();
                      }
                    },
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  flex: 1,
                  child: TextFormField(
                    controller: pageNumberCtrl,
                    decoration: const InputDecoration(
                      labelText: 'رقم الصفحة',
                      prefixIcon: Icon(Icons.description, size: 20),
                    ),
                    keyboardType: TextInputType.number,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  flex: 1,
                  child: TextFormField(
                    controller: entryNumberCtrl,
                    decoration: const InputDecoration(
                      labelText: 'رقم القيد',
                      prefixIcon: Icon(Icons.numbers, size: 20),
                    ),
                    keyboardType: TextInputType.number,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: hijriDateCtrl,
                    readOnly: true,
                    decoration: const InputDecoration(
                      labelText: 'تاريخ القيد (هـ)',
                      prefixIcon: Icon(Icons.calendar_month, size: 20),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: TextFormField(
                    controller: gregorianDateCtrl,
                    readOnly: true,
                    decoration: const InputDecoration(
                      labelText: 'تاريخ القيد (م)',
                      prefixIcon: Icon(Icons.date_range, size: 20),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            // Info message about auto-updating entry numbers
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
        ),
      ],
    );
  }
}
