import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';

class GuardianSection extends ConsumerWidget {
  final int? guardianRecordBookId;
  final TextEditingController recordBookNumberCtrl;
  final TextEditingController pageNumberCtrl;
  final TextEditingController entryNumberCtrl;
  final ValueChanged<int?> onRecordBookIdChanged;

  const GuardianSection({
    super.key,
    required this.guardianRecordBookId,
    required this.recordBookNumberCtrl,
    required this.pageNumberCtrl,
    required this.entryNumberCtrl,
    required this.onRecordBookIdChanged,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Record book number, page, entry
        Row(
          children: [
            Expanded(
              child: TextFormField(
                controller: recordBookNumberCtrl,
                decoration: const InputDecoration(
                  labelText: 'رقم السجل',
                  prefixIcon: Icon(Icons.menu_book, size: 20),
                ),
                keyboardType: TextInputType.number,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: TextFormField(
                controller: pageNumberCtrl,
                decoration: const InputDecoration(
                  labelText: 'رقم الصفحة',
                  prefixIcon: Icon(Icons.find_in_page, size: 20),
                ),
                keyboardType: TextInputType.number,
              ),
            ),
            const SizedBox(width: 10),
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
          ],
        ),
        const SizedBox(height: 12),
        // Status info
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          decoration: BoxDecoration(
            color: AppColors.infoLight.withValues(alpha: 0.5),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: AppColors.info.withValues(alpha: 0.2)),
          ),
          child: Row(
            children: [
              Icon(Icons.info_outline, size: 16, color: AppColors.info),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'سيتم تحديث رقم القيد تلقائياً عند الحفظ إذا كان السجل متصلاً',
                  style: TextStyle(
                    fontFamily: 'Tajawal',
                    fontSize: 11,
                    color: AppColors.info,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
