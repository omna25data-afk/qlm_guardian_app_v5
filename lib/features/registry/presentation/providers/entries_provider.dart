import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/registry_entry_model.dart';
import '../../data/repositories/registry_repository.dart';
import '../../../../core/di/injection.dart';

// Repository Provider
final registryRepositoryProvider = Provider<RegistryRepository>((ref) {
  return getIt<RegistryRepository>();
});

// Search Query Provider
final entrySearchQueryProvider = StateProvider<String>((ref) => '');

// Filter Status Provider (null = all, or specific status string)
final entryStatusFilterProvider = StateProvider<String?>((ref) => null);

// Raw Entries Provider (Fetched from Repo)
final rawEntriesProvider = FutureProvider<List<RegistryEntryModel>>((
  ref,
) async {
  final repository = ref.watch(registryRepositoryProvider);
  return await repository.getEntries();
});

// Filtered Entries Provider
final filteredEntriesProvider = Provider<AsyncValue<List<RegistryEntryModel>>>((
  ref,
) {
  final entriesAsync = ref.watch(rawEntriesProvider);
  final searchQuery = ref.watch(entrySearchQueryProvider).trim().toLowerCase();
  final statusFilter = ref.watch(entryStatusFilterProvider);

  return entriesAsync.whenData((entries) {
    return entries.where((entry) {
      // 1. Filter by Status
      if (statusFilter != null && entry.status != statusFilter) {
        return false;
      }

      // 2. Filter by Search Query
      if (searchQuery.isNotEmpty) {
        final matchesSubject =
            entry.subject?.toLowerCase().contains(searchQuery) ?? false;
        final matchesParty1 =
            entry.firstPartyName?.toLowerCase().contains(searchQuery) ?? false;
        final matchesParty2 =
            entry.secondPartyName?.toLowerCase().contains(searchQuery) ?? false;
        final matchesNumber =
            entry.registerNumber?.toString().contains(searchQuery) ?? false;

        return matchesSubject ||
            matchesParty1 ||
            matchesParty2 ||
            matchesNumber;
      }

      return true;
    }).toList();
  });
});
