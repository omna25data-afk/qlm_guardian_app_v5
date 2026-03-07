import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qlm_guardian_app_v5/features/system/data/models/registry_entry_sections.dart';
import 'package:qlm_guardian_app_v5/features/registry/data/repositories/registry_repository.dart';
import 'package:qlm_guardian_app_v5/features/registry/presentation/providers/entries_provider.dart';

/// Provider مخصص للأمين — يجلب القيود من API مباشرة
/// بدلاً من التصفية المحلية المحدودة بـ 15 قيد
final guardianEntriesByBookProvider =
    FutureProvider.family<
      List<RegistryEntrySections>,
      ({int contractTypeId, int bookNumber})
    >((ref, args) async {
      final repository = ref.watch(registryRepositoryProvider);
      return repository.getEntriesByBook(
        contractTypeId: args.contractTypeId,
        bookNumber: args.bookNumber,
      );
    });

// ─── Filter Providers for Guardian My Entries ─── //
final guardianEntrySearchQueryProvider = StateProvider<String>((ref) => '');
final guardianEntryStatusesFilterProvider = StateProvider<List<String>>(
  (ref) => ['draft', 'pending_documentation', 'registered_guardian'],
);
final guardianEntryContractTypeFilterProvider = StateProvider<int?>(
  (ref) => null,
);

// ─── Raw Data Provider (Notifier for Pagination with backend filtering) ─── //
class GuardianAllEntriesNotifier extends StateNotifier<EntriesState> {
  final RegistryRepository repository;
  final Ref ref;
  static const int _perPage = 15;

  GuardianAllEntriesNotifier(this.repository, this.ref)
    : super(const EntriesState()) {
    loadInitial();
  }

  Future<void> loadInitial() async {
    if (state.isLoading) return;

    state = state.copyWith(
      isLoading: true,
      error: null,
      currentPage: 1,
      hasReachedMax: false,
    );
    try {
      final search = ref.read(guardianEntrySearchQueryProvider);
      final statuses = ref.read(guardianEntryStatusesFilterProvider);
      final contractTypeId = ref.read(guardianEntryContractTypeFilterProvider);

      final entries = await repository.getEntries(
        page: 1,
        perPage: _perPage,
        search: search,
        statuses: statuses,
        contractTypeId: contractTypeId,
      );
      state = state.copyWith(
        entries: entries,
        isLoading: false,
        hasReachedMax: entries.length < _perPage,
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> loadMore() async {
    if (state.isFetchingMore || state.hasReachedMax || state.isLoading) return;

    state = state.copyWith(isFetchingMore: true, error: null);
    try {
      final nextPage = state.currentPage + 1;
      final search = ref.read(guardianEntrySearchQueryProvider);
      final statuses = ref.read(guardianEntryStatusesFilterProvider);
      final contractTypeId = ref.read(guardianEntryContractTypeFilterProvider);

      final newEntries = await repository.getEntries(
        page: nextPage,
        perPage: _perPage,
        search: search,
        statuses: statuses,
        contractTypeId: contractTypeId,
      );

      state = state.copyWith(
        entries: [...state.entries, ...newEntries],
        currentPage: nextPage,
        isFetchingMore: false,
        hasReachedMax: newEntries.length < _perPage,
      );
    } catch (e) {
      state = state.copyWith(isFetchingMore: false, error: e.toString());
    }
  }

  void refresh() {
    loadInitial(); // To retrigger cleanly and reset pagination
  }
}

final guardianAllEntriesProvider =
    StateNotifierProvider<GuardianAllEntriesNotifier, EntriesState>((ref) {
      final repository = ref.watch(registryRepositoryProvider);
      return GuardianAllEntriesNotifier(repository, ref);
    });
