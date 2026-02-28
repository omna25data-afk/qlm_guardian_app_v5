import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qlm_guardian_app_v5/features/system/data/models/registry_entry_sections.dart';
import '../../data/repositories/registry_repository.dart';
import '../../../../core/di/injection.dart';

// Repository Provider
final registryRepositoryProvider = Provider<RegistryRepository>((ref) {
  return getIt<RegistryRepository>();
});

// Search Query Provider
final entrySearchQueryProvider = StateProvider<String>((ref) => '');

// Filter Statuses Provider (empty = all)
final entryStatusesFilterProvider = StateProvider<List<String>>((ref) => []);

// Sort Provider
final entrySortProvider = StateProvider<String>((ref) => 'newest');

// Raw Entries Provider (Fetched from Repo)
final rawEntriesProvider = FutureProvider<List<RegistryEntrySections>>((
  ref,
) async {
  final repository = ref.watch(registryRepositoryProvider);
  return await repository.getEntries();
});

// Filtered Entries Provider
final filteredEntriesProvider =
    Provider<AsyncValue<List<RegistryEntrySections>>>((ref) {
      final entriesAsync = ref.watch(rawEntriesProvider);
      final searchQuery = ref
          .watch(entrySearchQueryProvider)
          .trim()
          .toLowerCase();
      final statusesFilter = ref.watch(entryStatusesFilterProvider);
      final sortOption = ref.watch(entrySortProvider);

      return entriesAsync.whenData((entries) {
        var filtered = entries.where((entry) {
          // 1. Filter by Statuses
          if (statusesFilter.isNotEmpty &&
              !statusesFilter.contains(entry.statusInfo.status)) {
            return false;
          }

          // 2. Filter by Search Query
          if (searchQuery.isNotEmpty) {
            final matchesSubject =
                entry.basicInfo.subject?.toLowerCase().contains(searchQuery) ??
                false;
            final matchesParty1 = entry.basicInfo.firstPartyName
                .toLowerCase()
                .contains(searchQuery);
            final matchesParty2 = entry.basicInfo.secondPartyName
                .toLowerCase()
                .contains(searchQuery);

            // Check all possible identifiers
            final matchesRegNum =
                entry.basicInfo.registerNumber?.toString().contains(
                  searchQuery,
                ) ??
                false;
            final matchesSerialNum = entry.basicInfo.serialNumber
                .toString()
                .contains(searchQuery);
            final matchesGuardianNum =
                entry.guardianInfo.guardianEntryNumber?.toString().contains(
                  searchQuery,
                ) ??
                false;
            final matchesDocNum =
                entry.documentInfo.docEntryNumber?.toString().contains(
                  searchQuery,
                ) ??
                false;

            return matchesSubject ||
                matchesParty1 ||
                matchesParty2 ||
                matchesRegNum ||
                matchesSerialNum ||
                matchesGuardianNum ||
                matchesDocNum;
          }

          return true;
        }).toList();

        // 3. Sort
        if (sortOption == 'newest') {
          filtered.sort(
            (a, b) => (b.metadata.createdAt ?? '').compareTo(
              a.metadata.createdAt ?? '',
            ),
          );
        } else if (sortOption == 'oldest') {
          filtered.sort(
            (a, b) => (a.metadata.createdAt ?? '').compareTo(
              b.metadata.createdAt ?? '',
            ),
          );
        } else if (sortOption == 'highest_amount') {
          filtered.sort(
            (a, b) => b.financialInfo.totalAmount.compareTo(
              a.financialInfo.totalAmount,
            ),
          );
        } else if (sortOption == 'lowest_amount') {
          filtered.sort(
            (a, b) => a.financialInfo.totalAmount.compareTo(
              b.financialInfo.totalAmount,
            ),
          );
        }

        return filtered;
      });
    });
