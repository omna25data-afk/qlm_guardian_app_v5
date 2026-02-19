import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:qlm_guardian_app_v5/core/network/api_client.dart';
import 'package:qlm_guardian_app_v5/features/registry/data/models/contract_type_model.dart';
import 'package:qlm_guardian_app_v5/features/system/data/models/registry_entry_sections.dart';
import 'package:qlm_guardian_app_v5/features/registry/data/repositories/registry_repository.dart';
import 'package:qlm_guardian_app_v5/features/registry/presentation/providers/add_registry_entry_provider.dart';

@GenerateMocks([RegistryRepository, ApiClient])
import 'add_registry_entry_provider_test.mocks.dart';

void main() {
  late AddRegistryEntryNotifier notifier;
  late MockRegistryRepository mockRepository;
  late MockApiClient mockApiClient;

  // Dummy RegistryEntrySections for return value
  final tEntry = RegistryEntrySections(
    id: 100,
    basicInfo: const RegistryBasicInfo(
      serialNumber: 0,
      hijriYear: 1445,
      firstPartyName: '',
      secondPartyName: '',
    ),
    writerInfo: const RegistryWriterInfo(),
    documentInfo: const RegistryDocumentInfo(),
    financialInfo: const RegistryFinancialInfo(),
    guardianInfo: const RegistryGuardianInfo(),
    statusInfo: const RegistryStatusInfo(),
    metadata: const RegistryMetadata(),
  );

  setUp(() {
    mockRepository = MockRegistryRepository();
    mockApiClient = MockApiClient();
    // Stub getContractTypes to prevent constructor error
    when(mockRepository.getContractTypes()).thenAnswer((_) async => []);
    notifier = AddRegistryEntryNotifier(mockRepository, mockApiClient);
  });

  group('submitEntry', () {
    test(
      'should include all form data in RegistryEntrySections with correct mapping',
      () async {
        // Arrange
        final tContractType = ContractTypeModel(id: 1, name: 'Marriage');
        notifier.selectContractType(tContractType);

        // Simulate filling form
        notifier.updateFormData('subject', 'Test Subject');
        notifier.updateFormData(
          'content',
          'Test Content',
        ); // Should map to content and notes
        notifier.updateFormData('hijri_year', 1445);
        notifier.updateFormData('register_number', '12345');
        notifier.updateFormData('first_party_name', 'Party A');
        notifier.updateFormData('second_party_name', 'Party B');
        notifier.updateFormData('subtype_1', '101'); // Should map to subtype1
        notifier.updateFormData('subtype_2', '202'); // Should map to subtype2
        notifier.updateFormData(
          'fee_amount',
          '500.0',
        ); // Should map to feeAmount
        notifier.updateFormData(
          'dynamic_field_1',
          'Value 1',
        ); // Should be in formData

        // Stub createEntry
        when(
          mockRepository.createEntry(
            any,
            attachmentPath: anyNamed('attachmentPath'),
          ),
        ).thenAnswer((_) async => tEntry);

        // Act
        final result = await notifier.submitEntry(
          manualBookNumber: null,
          manualPageNumber: null,
          manualEntryNumber: null,
          documentDateGregorian: DateTime(2023, 10, 27),
          documentDateHijri: '1445-04-12',
          textFieldValues: {},
        );

        // Assert
        expect(result, true);

        final capturedEntry =
            verify(
                  mockRepository.createEntry(
                    captureAny,
                    attachmentPath: anyNamed('attachmentPath'),
                  ),
                ).captured.single
                as RegistryEntrySections;

        expect(capturedEntry.basicInfo.contractTypeId, 1);
        expect(capturedEntry.basicInfo.firstPartyName, 'Party A');
        expect(capturedEntry.basicInfo.secondPartyName, 'Party B');

        // Mapped fields assertions
        expect(capturedEntry.basicInfo.subject, 'Test Subject');
        expect(capturedEntry.basicInfo.content, 'Test Content');
        // Notes is mapped from content in the provider logic
        expect(
          capturedEntry.statusInfo.notes,
          'Test Content',
          reason: 'Content should be mapped to notes',
        );
        expect(capturedEntry.basicInfo.hijriYear, 1445);
        expect(capturedEntry.basicInfo.registerNumber, '12345');

        // New validations
        expect(
          capturedEntry.basicInfo.subtype1,
          101,
          reason: 'Subtype 1 should be parsed as int',
        );
        expect(
          capturedEntry.basicInfo.subtype2,
          202,
          reason: 'Subtype 2 should be parsed as int',
        );
        expect(
          capturedEntry.financialInfo.feeAmount,
          500.0,
          reason: 'Fee amount should be parsed as double',
        );

        // Dynamic FormData check
        expect(capturedEntry.formData, isNotNull);
        expect(
          capturedEntry.formData!['dynamic_field_1'],
          'Value 1',
          reason: 'Dynamic fields should be in formData',
        );

        // Ensure mapped fields are REMOVED from formData to avoid duplication
        expect(
          capturedEntry.formData!.containsKey('subtype_1'),
          isFalse,
          reason: 'subtype_1 should be excluded from formData',
        );
        expect(
          capturedEntry.formData!.containsKey('content'),
          isFalse,
          reason: 'content should be excluded from formData',
        );
      },
    );
  });
}
