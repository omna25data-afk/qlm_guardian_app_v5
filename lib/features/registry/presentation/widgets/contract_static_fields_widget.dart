import 'package:flutter/material.dart';

import 'contract_fields/agency_contract_fields.dart';
import 'contract_fields/disposition_record_fields.dart';
import 'contract_fields/division_record_fields.dart';
import 'contract_fields/divorce_certificate_fields.dart';
import 'contract_fields/marriage_contract_fields.dart';
import 'contract_fields/return_certificate_fields.dart';
import 'contract_fields/sale_immovable_contract_fields.dart';
import 'contract_fields/sale_movable_contract_fields.dart';

class ContractStaticFieldsWidget extends StatelessWidget {
  final int contractTypeId;
  final Map<String, TextEditingController> controllers;

  /// حقول مصفاة خارجية - تُمرر لـ ContractTextField عبر ملفات الحقول الفرعية
  final List<Map<String, dynamic>>? externalFilteredFields;

  const ContractStaticFieldsWidget({
    Key? key,
    required this.contractTypeId,
    required this.controllers,
    this.externalFilteredFields,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // بناء النماذج الثابتة الذكية باستخدام ConsumerWidgets بداخلها
    switch (contractTypeId) {
      case 1:
        return MarriageContractFields(
          controllers: controllers,
          externalFilteredFields: externalFilteredFields,
        );
      case 2:
        return SaleMovableContractFields(
          controllers: controllers,
          externalFilteredFields: externalFilteredFields,
        );
      case 3:
        return SaleImmovableContractFields(
          controllers: controllers,
          externalFilteredFields: externalFilteredFields,
        );
      case 4:
        return AgencyContractFields(
          controllers: controllers,
          externalFilteredFields: externalFilteredFields,
        );
      case 5:
        return DispositionRecordFields(
          controllers: controllers,
          externalFilteredFields: externalFilteredFields,
        );
      case 6:
        return DivisionRecordFields(
          controllers: controllers,
          externalFilteredFields: externalFilteredFields,
        );
      case 7:
        return DivorceCertificateFields(
          controllers: controllers,
          externalFilteredFields: externalFilteredFields,
        );
      case 8:
        return ReturnCertificateFields(
          controllers: controllers,
          externalFilteredFields: externalFilteredFields,
        );
      default:
        return const SizedBox.shrink();
    }
  }
}
