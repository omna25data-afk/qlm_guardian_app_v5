import 'package:flutter/material.dart';
import 'contract_text_field.dart';

class ReturnCertificateFields extends StatelessWidget {
  final Map<String, TextEditingController> controllers;
  final List<Map<String, dynamic>>? externalFilteredFields;

  const ReturnCertificateFields({
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
          fieldKey: 'divorce_certificate_number',
          label: 'رقم إشهاد الطلاق',
          keyboardType: TextInputType.number,
          externalFilteredFields: externalFilteredFields,
        ),
        ContractTextField(
          controllers: controllers,
          fieldKey: 'return_date',
          label: 'تاريخ الرجعة',
          keyboardType: TextInputType.datetime,
          externalFilteredFields: externalFilteredFields,
        ),
        ContractTextField(
          controllers: controllers,
          fieldKey: 'revocation_date',
          label: 'تاريخ المراجعة',
          keyboardType: TextInputType.datetime,
          externalFilteredFields: externalFilteredFields,
        ),
      ],
    );
  }
}
