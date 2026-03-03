import 'package:flutter/material.dart';
import 'contract_text_field.dart';

class SaleMovableContractFields extends StatelessWidget {
  final Map<String, TextEditingController> controllers;
  final List<Map<String, dynamic>>? externalFilteredFields;

  const SaleMovableContractFields({
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
          fieldKey: 'item_description',
          label: 'وصف المبيع',
          maxLines: 3,
          externalFilteredFields: externalFilteredFields,
        ),
        ContractTextField(
          controllers: controllers,
          fieldKey: 'sale_price',
          label: 'ثمن البيع (ريال)',
          keyboardType: TextInputType.number,
          externalFilteredFields: externalFilteredFields,
        ),
        ContractTextField(
          controllers: controllers,
          fieldKey: 'payment_method',
          label: 'طريقة الدفع',
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
