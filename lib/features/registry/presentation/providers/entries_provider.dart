import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qlm_guardian_app_v5/features/system/data/models/registry_entry_sections.dart';
import '../../data/repositories/registry_repository.dart';
import '../../../../core/di/injection.dart';

// Repository Provider
final registryRepositoryProvider = Provider<RegistryRepository>((ref) {
  return getIt<RegistryRepository>();
});

// ─── Filter Providers ─── //
final entrySearchQueryProvider = StateProvider<String>((ref) => '');
final entryStatusesFilterProvider = StateProvider<List<String>>((ref) => []);
final entryContractTypeFilterProvider = StateProvider<int?>((ref) => null);
final entryDateFromFilterProvider = StateProvider<DateTime?>((ref) => null);
final entryDateToFilterProvider = StateProvider<DateTime?>((ref) => null);
final entryDeliveryStatusFilterProvider = StateProvider<String?>((ref) => null);

// ─── Sort Provider ─── //
final entrySortProvider = StateProvider<String>((ref) => 'newest');

// ─── Raw Data Provider (Notifier for Pagination) ─── //
class EntriesState {
  final List<RegistryEntrySections> entries;
  final bool isLoading;
  final bool isFetchingMore;
  final bool hasReachedMax;
  final String? error;
  final int currentPage;

  const EntriesState({
    this.entries = const [],
    this.isLoading = false,
    this.isFetchingMore = false,
    this.hasReachedMax = false,
    this.error,
    this.currentPage = 1,
  });

  EntriesState copyWith({
    List<RegistryEntrySections>? entries,
    bool? isLoading,
    bool? isFetchingMore,
    bool? hasReachedMax,
    String? error,
    int? currentPage,
  }) {
    return EntriesState(
      entries: entries ?? this.entries,
      isLoading: isLoading ?? this.isLoading,
      isFetchingMore: isFetchingMore ?? this.isFetchingMore,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      error: error,
      currentPage: currentPage ?? this.currentPage,
    );
  }
}

class EntriesNotifier extends StateNotifier<EntriesState> {
  final RegistryRepository repository;
  static const int _perPage = 15;

  EntriesNotifier(this.repository) : super(const EntriesState()) {
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
      final entries = await repository.getEntries(page: 1, perPage: _perPage);
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
      final newEntries = await repository.getEntries(
        page: nextPage,
        perPage: _perPage,
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
}

final rawEntriesProvider = StateNotifierProvider<EntriesNotifier, EntriesState>(
  (ref) {
    return EntriesNotifier(ref.watch(registryRepositoryProvider));
  },
);

// ─── Filtered Data Provider ─── //
final filteredEntriesProvider =
    Provider<AsyncValue<List<RegistryEntrySections>>>((ref) {
      final entriesState = ref.watch(rawEntriesProvider);

      final searchQuery = ref
          .watch(entrySearchQueryProvider)
          .trim()
          .toLowerCase();
      final statusesFilter = ref.watch(entryStatusesFilterProvider);
      final contractTypeFilter = ref.watch(entryContractTypeFilterProvider);
      final dateFrom = ref.watch(entryDateFromFilterProvider);
      final dateTo = ref.watch(entryDateToFilterProvider);
      final deliveryStatus = ref.watch(entryDeliveryStatusFilterProvider);
      final sortOption = ref.watch(entrySortProvider);

      if (entriesState.isLoading) {
        return const AsyncValue.loading();
      } else if (entriesState.error != null) {
        return AsyncValue.error(entriesState.error!, StackTrace.current);
      }

      var filtered = entriesState.entries.where((entry) {
        // 1. Status Filter
        if (statusesFilter.isNotEmpty &&
            !statusesFilter.contains(entry.statusInfo.status)) {
          return false;
        }

        // 2. Contract Type Filter
        if (contractTypeFilter != null &&
            entry.basicInfo.contractTypeId != contractTypeFilter) {
          return false;
        }

        // 3. Delivery Status Filter
        if (deliveryStatus != null &&
            entry.statusInfo.deliveryStatus != deliveryStatus) {
          return false;
        }

        // 4. Date Range Filter (Document Gregorian Date)
        if (dateFrom != null || dateTo != null) {
          final docDateStr = entry.documentInfo.documentGregorianDate;
          if (docDateStr == null || docDateStr.isEmpty) return false;

          final docDate = DateTime.tryParse(docDateStr);
          if (docDate == null) return false;

          if (dateFrom != null &&
              docDate.isBefore(
                dateFrom.copyWith(
                  hour: 0,
                  minute: 0,
                  second: 0,
                  microsecond: 0,
                ),
              )) {
            return false;
          }
          if (dateTo != null &&
              docDate.isAfter(
                dateTo.copyWith(hour: 23, minute: 59, second: 59),
              )) {
            return false;
          }
        }

        // 5. Search Query Filter
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

      // ─── Sort Data ─── //
      switch (sortOption) {
        case 'newest':
          filtered.sort(
            (a, b) => (b.metadata.createdAt ?? '').compareTo(
              a.metadata.createdAt ?? '',
            ),
          );
          break;
        case 'oldest':
          filtered.sort(
            (a, b) => (a.metadata.createdAt ?? '').compareTo(
              b.metadata.createdAt ?? '',
            ),
          );
          break;
        case 'highest_amount':
          filtered.sort(
            (a, b) => b.financialInfo.totalAmount.compareTo(
              a.financialInfo.totalAmount,
            ),
          );
          break;
        case 'lowest_amount':
          filtered.sort(
            (a, b) => a.financialInfo.totalAmount.compareTo(
              b.financialInfo.totalAmount,
            ),
          );
          break;
        case 'newest_doc_date':
          filtered.sort(
            (a, b) => (b.documentInfo.documentGregorianDate ?? '').compareTo(
              a.documentInfo.documentGregorianDate ?? '',
            ),
          );
          break;
        case 'oldest_doc_date':
          filtered.sort(
            (a, b) => (a.documentInfo.documentGregorianDate ?? '').compareTo(
              b.documentInfo.documentGregorianDate ?? '',
            ),
          );
          break;
        case 'status':
          filtered.sort(
            (a, b) => a.statusInfo.status.compareTo(b.statusInfo.status),
          );
          break;
        case 'contract_type':
          filtered.sort(
            (a, b) => (a.basicInfo.contractTypeId ?? 0).compareTo(
              b.basicInfo.contractTypeId ?? 0,
            ),
          );
          break;
      }

      return AsyncValue.data(filtered);
    });
