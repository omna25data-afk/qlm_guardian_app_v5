import 'package:flutter_test/flutter_test.dart';
import 'package:qlm_guardian_app_v5/features/system/data/models/registry_entry_sections.dart';

void main() {
  test(
    'RegistryEntrySections should parse flat JSON including new fields and form data',
    () {
      final Map<String, dynamic> json = {
        'id': 1,
        'uuid': 'uuid-123',
        'remote_id': 999,
        'serial_number': 123,
        'hijri_year': 1445,
        'first_party_name': 'Party A',
        'second_party_name': 'Party B',
        'writer_type': 'External',
        'writer_name': 'Writer X',
        'fee_amount': 100.0,
        'support_amount': 50.0,
        'sustainability_amount': 25.0,
        'penalty_amount': 10.0,
        'status': 'active',
        'delivery_status': 'pending',
        'created_by': 1,
        'form_data': {'custom_field_1': 'value1', 'custom_field_2': 123},
        'status_label': 'نشط',
        'status_color': '#00FF00',
      };

      final entry = RegistryEntrySections.fromJson(json);

      expect(entry.id, 1);
      expect(entry.uuid, 'uuid-123');
      expect(entry.remoteId, 999);
      expect(entry.basicInfo.serialNumber, 123);

      // Check new financial fields
      expect(entry.financialInfo.feeAmount, 100.0);
      expect(entry.financialInfo.penaltyAmount, 10.0);

      // Check status info extended fields
      expect(entry.statusInfo.statusLabel, 'نشط');
      expect(entry.statusInfo.statusColor, '#00FF00');

      // Check form data
      expect(entry.formData?.containsKey('custom_field_1'), true);
      expect(entry.formData?['custom_field_1'], 'value1');
    },
  );

  test('RegistryEntrySections Equality Check (Equatable)', () {
    final entry1 = RegistryEntrySections(
      id: 1,
      basicInfo: const RegistryBasicInfo(
        serialNumber: 1,
        hijriYear: 1445,
        firstPartyName: 'A',
        secondPartyName: 'B',
      ),
      writerInfo: const RegistryWriterInfo(writerType: 'w', writerName: 'n'),
      documentInfo: const RegistryDocumentInfo(),
      financialInfo: const RegistryFinancialInfo(
        feeAmount: 0,
        supportAmount: 0,
        sustainabilityAmount: 0,
      ),
      guardianInfo: const RegistryGuardianInfo(),
      statusInfo: const RegistryStatusInfo(status: 's', deliveryStatus: 'd'),
      metadata: const RegistryMetadata(createdBy: 1),
      formData: const {'key': 'val'},
    );

    final entry2 = RegistryEntrySections(
      id: 1,
      basicInfo: const RegistryBasicInfo(
        serialNumber: 1,
        hijriYear: 1445,
        firstPartyName: 'A',
        secondPartyName: 'B',
      ),
      writerInfo: const RegistryWriterInfo(writerType: 'w', writerName: 'n'),
      documentInfo: const RegistryDocumentInfo(),
      financialInfo: const RegistryFinancialInfo(
        feeAmount: 0,
        supportAmount: 0,
        sustainabilityAmount: 0,
      ),
      guardianInfo: const RegistryGuardianInfo(),
      statusInfo: const RegistryStatusInfo(status: 's', deliveryStatus: 'd'),
      metadata: const RegistryMetadata(createdBy: 1),
      formData: const {'key': 'val'},
    );

    expect(entry1, entry2); // Should be equal due to Equatable
    expect(entry1 == entry2, true);
  });
}
