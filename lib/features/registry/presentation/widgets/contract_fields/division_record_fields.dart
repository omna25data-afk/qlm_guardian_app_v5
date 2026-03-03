import 'package:flutter/material.dart';
import 'contract_text_field.dart';

class DivisionRecordFields extends StatelessWidget {
  final Map<String, TextEditingController> controllers;
  final List<Map<String, dynamic>>? externalFilteredFields;

  const DivisionRecordFields({
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
          fieldKey: 'deceased_name',
          label: 'اسم المتوفى',
          externalFilteredFields: externalFilteredFields,
        ),
        ContractTextField(
          controllers: controllers,
          fieldKey: 'estate_description',
          label: 'وصف التركة',
          maxLines: 4,
          externalFilteredFields: externalFilteredFields,
        ),
        ContractTextField(
          controllers: controllers,
          fieldKey: 'heirs_names',
          label: 'أسماء الورثة',
          maxLines: 4,
          externalFilteredFields: externalFilteredFields,
        ),
      ],
    );
  }
}
