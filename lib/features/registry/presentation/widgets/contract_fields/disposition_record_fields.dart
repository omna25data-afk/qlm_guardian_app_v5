import 'package:flutter/material.dart';
import 'contract_text_field.dart';

class DispositionRecordFields extends StatelessWidget {
  final Map<String, TextEditingController> controllers;
  final List<Map<String, dynamic>>? externalFilteredFields;

  const DispositionRecordFields({
    super.key,
    required this.controllers,
    this.externalFilteredFields,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ContractTextField(
          controllers: controllers,
          fieldKey: 'disposition_type',
          label: 'نوع التصرف',
          externalFilteredFields: externalFilteredFields,
        ),
        ContractTextField(
          controllers: controllers,
          fieldKey: 'disposition_subject',
          label: 'موضوع التصرف',
          maxLines: 4,
          externalFilteredFields: externalFilteredFields,
        ),
      ],
    );
  }
}
