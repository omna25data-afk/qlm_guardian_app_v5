import 'package:flutter/material.dart';
import 'contract_text_field.dart';

class DivorceCertificateFields extends StatelessWidget {
  final Map<String, TextEditingController> controllers;
  final List<Map<String, dynamic>>? externalFilteredFields;

  const DivorceCertificateFields({
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
          fieldKey: 'marriage_contract_number',
          label: 'رقم عقد الزواج',
          externalFilteredFields: externalFilteredFields,
        ),
        ContractTextField(
          controllers: controllers,
          fieldKey: 'divorce_type',
          label: 'نوع الطلاق',
          externalFilteredFields: externalFilteredFields,
        ),
        ContractTextField(
          controllers: controllers,
          fieldKey: 'divorce_count',
          label: 'عدد الطلقات',
          keyboardType: TextInputType.number,
          externalFilteredFields: externalFilteredFields,
        ),
      ],
    );
  }
}
