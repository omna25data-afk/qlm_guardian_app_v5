import 'package:flutter/material.dart';
import '../../../../../core/utils/validators.dart';

/// Guardian data section of the entry form
/// Contains subject and content fields
class GuardianDataSection extends StatelessWidget {
  final TextEditingController subjectController;
  final TextEditingController contentController;

  const GuardianDataSection({
    super.key,
    required this.subjectController,
    required this.contentController,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFormField(
          controller: subjectController,
          decoration: const InputDecoration(
            labelText: 'الموضوع *',
            hintText: 'أدخل موضوع القيد',
            prefixIcon: Icon(Icons.subject),
            border: OutlineInputBorder(),
          ),
          validator: (v) => Validators.required(v, 'الموضوع'),
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: contentController,
          decoration: const InputDecoration(
            labelText: 'المحتوى',
            hintText: 'أدخل تفاصيل القيد',
            prefixIcon: Icon(Icons.description),
            border: OutlineInputBorder(),
            alignLabelWithHint: true,
          ),
          maxLines: 5,
          minLines: 3,
        ),
      ],
    );
  }
}
