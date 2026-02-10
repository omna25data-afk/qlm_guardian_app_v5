import 'package:flutter/material.dart';
import '../../../../../core/utils/date_utils.dart';

/// Dates section of the entry form
/// Contains Hijri date and year fields
class DatesSection extends StatelessWidget {
  final TextEditingController hijriDateController;
  final TextEditingController hijriYearController;

  const DatesSection({
    super.key,
    required this.hijriDateController,
    required this.hijriYearController,
  });

  @override
  Widget build(BuildContext context) {
    // Pre-fill with approximate Hijri year if empty
    if (hijriYearController.text.isEmpty) {
      hijriYearController.text = AppDateUtils.approximateHijriYear().toString();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFormField(
          controller: hijriDateController,
          decoration: const InputDecoration(
            labelText: 'التاريخ الهجري',
            hintText: '1446/05/12',
            prefixIcon: Icon(Icons.calendar_today),
            border: OutlineInputBorder(),
          ),
          keyboardType: TextInputType.datetime,
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: hijriYearController,
          decoration: const InputDecoration(
            labelText: 'السنة الهجرية',
            hintText: '1446',
            prefixIcon: Icon(Icons.date_range),
            border: OutlineInputBorder(),
          ),
          keyboardType: TextInputType.number,
        ),
        const SizedBox(height: 12),
        Text(
          'التاريخ الميلادي: ${AppDateUtils.formatGregorian(DateTime.now())}',
          style: Theme.of(
            context,
          ).textTheme.bodySmall?.copyWith(color: Colors.grey),
        ),
      ],
    );
  }
}
