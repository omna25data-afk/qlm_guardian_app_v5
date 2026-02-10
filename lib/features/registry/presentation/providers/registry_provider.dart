import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/di/injection.dart';
import '../../data/models/registry_entry_model.dart';
import '../../data/repositories/registry_repository.dart';

// Repository Provider
final registryRepositoryProvider = Provider<RegistryRepository>((ref) {
  return getIt<RegistryRepository>();
});

// Entries List Provider (AsyncValue for loading/error states)
final registryEntriesProvider = FutureProvider<List<RegistryEntryModel>>((
  ref,
) async {
  final repository = ref.watch(registryRepositoryProvider);
  return repository.getEntries();
});

// Single Entry Provider (Family)
final registryEntryProvider =
    FutureProvider.family<RegistryEntryModel?, String>((ref, uuid) async {
      // Can be optimized to fetch from local DB instead of full list re-fetch
      // For now, simpler implementation
      // Add getEntryByUuid to repo first
      // return repository.getEntryByUuid(uuid);
      return null; // Placeholder until repo method added
    });
