import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/di/injection.dart';
import 'package:qlm_guardian_app_v5/features/system/data/models/registry_entry_sections.dart';
import '../../data/repositories/registry_repository.dart';

// Repository Provider
final registryRepositoryProvider = Provider<RegistryRepository>((ref) {
  return getIt<RegistryRepository>();
});

// Entries List Provider (AsyncValue for loading/error states)
final registryEntriesProvider = FutureProvider<List<RegistryEntrySections>>((
  ref,
) async {
  final repository = ref.watch(registryRepositoryProvider);
  return repository.getEntries();
});

// Single Entry Provider (Family)
final registryEntryProvider =
    FutureProvider.family<RegistryEntrySections?, String>((ref, uuid) async {
      // Can be optimized to fetch from local DB instead of full list re-fetch
      // For now, simpler implementation
      // Add getEntryByUuid to repo first
      // return repository.getEntryByUuid(uuid);
      return null; // Placeholder until repo method added
    });

// Filter entries by record book
final entriesByRecordBookProvider =
    FutureProvider.family<
      List<RegistryEntrySections>,
      ({int contractTypeId, int bookNumber})
    >((ref, args) async {
      final allEntries = await ref.watch(registryEntriesProvider.future);
      return allEntries.where((e) {
        // Extract possible book numbers
        final docBook = e.documentInfo.docRecordBookNumber;
        final guardianBook = e.guardianInfo.guardianRecordBookNumber;

        // Fallback to checking the record_book map directly if fields were null
        final Map<String, dynamic>? rawFormData = e.formData;
        int? rawGuardianBookNum;

        if (rawFormData != null && rawFormData.containsKey('record_book')) {
          final bookNode = rawFormData['record_book'];
          if (bookNode is Map) {
            final tempNum = bookNode['number'] ?? bookNode['book_number'];
            if (tempNum is String) {
              rawGuardianBookNum = int.tryParse(tempNum);
            } else if (tempNum is int) {
              rawGuardianBookNum = tempNum;
            }
          }
        }

        final bookNum = guardianBook ?? docBook ?? rawGuardianBookNum;

        // Just match the bookNumber directly for simplicity and robustness.
        // If a guardian has two books across different categories with same number,
        // we attempt to match contract_type_id if available on the entry.
        bool matchesBook = false;
        if (bookNum != null) {
          matchesBook = bookNum == args.bookNumber;
        }

        if (!matchesBook) return false;

        // If book matches, ensure contract type matches if it exists on the basicInfo
        if (e.basicInfo.contractTypeId != null) {
          // We allow it to pass if contract type matches, or if front-end passed fallback typeId
          return e.basicInfo.contractTypeId == args.contractTypeId ||
              e.basicInfo.contractTypeId.toString() ==
                  args.contractTypeId.toString();
        }

        return true;
      }).toList();
    });
