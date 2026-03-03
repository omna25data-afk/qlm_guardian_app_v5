import 'package:flutter/material.dart';
import 'contract_text_field.dart';

class MarriageContractFields extends StatelessWidget {
  final Map<String, TextEditingController> controllers;
  final List<Map<String, dynamic>>? externalFilteredFields;

  const MarriageContractFields({
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
          fieldKey: 'groom_national_id',
          label: 'رقم هوية الزوج',
          keyboardType: TextInputType.number,
          externalFilteredFields: externalFilteredFields,
        ),
        ContractTextField(
          controllers: controllers,
          fieldKey: 'husband_birth_date',
          label: 'تاريخ ميلاد الزوج',
          keyboardType: TextInputType.datetime,
          externalFilteredFields: externalFilteredFields,
        ),
        ContractTextField(
          controllers: controllers,
          fieldKey: 'husband_age',
          label: 'عمر الزوج',
          keyboardType: TextInputType.number,
          externalFilteredFields: externalFilteredFields,
        ),
        const Divider(),
        ContractTextField(
          controllers: controllers,
          fieldKey: 'bride_national_id',
          label: 'رقم هوية الزوجة',
          keyboardType: TextInputType.number,
          externalFilteredFields: externalFilteredFields,
        ),
        ContractTextField(
          controllers: controllers,
          fieldKey: 'wife_birth_date',
          label: 'تاريخ ميلاد الزوجة',
          keyboardType: TextInputType.datetime,
          externalFilteredFields: externalFilteredFields,
        ),
        ContractTextField(
          controllers: controllers,
          fieldKey: 'bride_age',
          label: 'عمر الزوجة',
          keyboardType: TextInputType.number,
          externalFilteredFields: externalFilteredFields,
        ),
        const Divider(),
        ContractTextField(
          controllers: controllers,
          fieldKey: 'guardian_name',
          label: 'اسم ولي الزوجة',
          externalFilteredFields: externalFilteredFields,
        ),
        ContractTextField(
          controllers: controllers,
          fieldKey: 'guardian_relation',
          label: 'صلة القرابة',
          externalFilteredFields: externalFilteredFields,
        ),
        const Divider(),
        ContractTextField(
          controllers: controllers,
          fieldKey: 'dowry_amount',
          label: 'المهر (الإجمالي)',
          keyboardType: TextInputType.number,
          externalFilteredFields: externalFilteredFields,
        ),
        ContractTextField(
          controllers: controllers,
          fieldKey: 'dowry_paid',
          label: 'المقدم المدفوع',
          keyboardType: TextInputType.number,
          externalFilteredFields: externalFilteredFields,
        ),
        const Divider(),
        ContractTextField(
          controllers: controllers,
          fieldKey: 'witnesses',
          label: 'الشهود',
          maxLines: 3,
          externalFilteredFields: externalFilteredFields,
        ),
      ],
    );
  }
}
