import 'package:flutter/material.dart';
import 'contract_text_field.dart';

class AgencyContractFields extends StatelessWidget {
  final Map<String, TextEditingController> controllers;
  final List<Map<String, dynamic>>? externalFilteredFields;

  const AgencyContractFields({
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
          fieldKey: 'principal_national_id',
          label: 'رقم هوية الموكل',
          keyboardType: TextInputType.number,
          externalFilteredFields: externalFilteredFields,
        ),
        ContractTextField(
          controllers: controllers,
          fieldKey: 'agent_national_id',
          label: 'رقم هوية الوكيل',
          keyboardType: TextInputType.number,
          externalFilteredFields: externalFilteredFields,
        ),
        ContractTextField(
          controllers: controllers,
          fieldKey: 'agency_type',
          label: 'نوع الوكالة',
          externalFilteredFields: externalFilteredFields,
        ),
        ContractTextField(
          controllers: controllers,
          fieldKey: 'agency_purpose',
          label: 'الغرض من الوكالة',
          maxLines: 2,
          externalFilteredFields: externalFilteredFields,
        ),
        ContractTextField(
          controllers: controllers,
          fieldKey: 'agency_powers',
          label: 'الصلاحيات الممنوحة',
          maxLines: 3,
          externalFilteredFields: externalFilteredFields,
        ),
        ContractTextField(
          controllers: controllers,
          fieldKey: 'agency_duration',
          label: 'مدة الوكالة',
          externalFilteredFields: externalFilteredFields,
        ),
      ],
    );
  }
}
