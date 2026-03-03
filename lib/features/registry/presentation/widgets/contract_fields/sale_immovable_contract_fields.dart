import 'package:flutter/material.dart';
import 'contract_text_field.dart';

class SaleImmovableContractFields extends StatelessWidget {
  final Map<String, TextEditingController> controllers;
  final List<Map<String, dynamic>>? externalFilteredFields;

  const SaleImmovableContractFields({
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
          fieldKey: 'seller_national_id',
          label: 'رقم الهوية الوطنية للبائع',
          keyboardType: TextInputType.number,
          externalFilteredFields: externalFilteredFields,
        ),
        ContractTextField(
          controllers: controllers,
          fieldKey: 'buyer_national_id',
          label: 'رقم الهوية الوطنية للمشتري',
          keyboardType: TextInputType.number,
          externalFilteredFields: externalFilteredFields,
        ),
        ContractTextField(
          controllers: controllers,
          fieldKey: 'property_type',
          label: 'نوع العقار',
          externalFilteredFields: externalFilteredFields,
        ),
        ContractTextField(
          controllers: controllers,
          fieldKey: 'property_location',
          label: 'موقع العقار',
          maxLines: 2,
          externalFilteredFields: externalFilteredFields,
        ),
        ContractTextField(
          controllers: controllers,
          fieldKey: 'property_area',
          label: 'مساحة العقار (متر مربع)',
          keyboardType: TextInputType.number,
          externalFilteredFields: externalFilteredFields,
        ),
        ContractTextField(
          controllers: controllers,
          fieldKey: 'property_boundaries',
          label: 'حدود العقار',
          maxLines: 3,
          externalFilteredFields: externalFilteredFields,
        ),
        ContractTextField(
          controllers: controllers,
          fieldKey: 'deed_number',
          label: 'رقم الصك (إن وجد)',
          externalFilteredFields: externalFilteredFields,
        ),
        ContractTextField(
          controllers: controllers,
          fieldKey: 'sale_price',
          label: 'ثمن البيع (ريال)',
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
