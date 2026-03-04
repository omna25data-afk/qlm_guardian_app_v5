import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Actually, I'll just remove the lines reported as unused.

import '../../../../system/data/models/registry_entry_sections.dart';
import '../../../../admin/presentation/widgets/premium_entry_card.dart';
import '../../../../admin/data/repositories/admin_repository.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/di/injection.dart';
import '../../../../registry/presentation/screens/compact_registry_entry_screen.dart';
import '../../../../registry/presentation/screens/entry_details_screen.dart';
import '../admin_add_entry_screen.dart';

import '../../../../admin/presentation/widgets/advanced_all_entries_filter_sheet.dart';
import '../../../../admin/presentation/widgets/document_entry_sheet.dart';

class AllEntriesState {
  final List<RegistryEntrySections> entries;
  final bool isLoading;
  final bool isFetchingMore;
  final bool hasMore;
  final int page;
  final String? error;

  // Filters
  final String? searchQuery;
  final String? status;
  final int? year;
  final int? contractTypeId;
  final String? writerType;
  final int? filteredWriterId;
  final String? dateFilterType;
  final String? dateFrom;
  final String? dateTo;
  final String? hijriDateFrom;
  final String? hijriDateTo;
  final String? recordBookCategory;
  final int? recordBookTypeId;

  const AllEntriesState({
    this.entries = const [],
    this.isLoading = false,
    this.isFetchingMore = false,
    this.hasMore = true,
    this.page = 1,
    this.error,
    this.searchQuery,
    this.status,
    this.year,
    this.contractTypeId,
    this.writerType,
    this.filteredWriterId,
    this.dateFilterType,
    this.dateFrom,
    this.dateTo,
    this.hijriDateFrom,
    this.hijriDateTo,
    this.recordBookCategory,
    this.recordBookTypeId,
  });

  AllEntriesState copyWith({
    List<RegistryEntrySections>? entries,
    bool? isLoading,
    bool? isFetchingMore,
    bool? hasMore,
    int? page,
    String? error,
    String? searchQuery,
    bool clearSearchQuery = false,
    String? status,
    bool clearStatus = false,
    int? year,
    bool clearYear = false,
    int? contractTypeId,
    bool clearContractTypeId = false,
    String? writerType,
    bool clearWriterType = false,
    int? filteredWriterId,
    bool clearFilteredWriterId = false,
    String? dateFilterType,
    bool clearDateFilterType = false,
    String? dateFrom,
    String? dateTo,
    String? hijriDateFrom,
    String? hijriDateTo,
    bool clearDates = false,
    String? recordBookCategory,
    bool clearRecordBookCategory = false,
    int? recordBookTypeId,
    bool clearRecordBookTypeId = false,
  }) {
    return AllEntriesState(
      entries: entries ?? this.entries,
      isLoading: isLoading ?? this.isLoading,
      isFetchingMore: isFetchingMore ?? this.isFetchingMore,
      hasMore: hasMore ?? this.hasMore,
      page: page ?? this.page,
      error: error,
      searchQuery: clearSearchQuery ? null : (searchQuery ?? this.searchQuery),
      status: clearStatus ? null : (status ?? this.status),
      year: clearYear ? null : (year ?? this.year),
      contractTypeId: clearContractTypeId
          ? null
          : (contractTypeId ?? this.contractTypeId),
      writerType: clearWriterType ? null : (writerType ?? this.writerType),
      filteredWriterId: clearFilteredWriterId
          ? null
          : (filteredWriterId ?? this.filteredWriterId),
      dateFilterType: clearDateFilterType
          ? null
          : (dateFilterType ?? this.dateFilterType),
      dateFrom: clearDates ? null : (dateFrom ?? this.dateFrom),
      dateTo: clearDates ? null : (dateTo ?? this.dateTo),
      hijriDateFrom: clearDates ? null : (hijriDateFrom ?? this.hijriDateFrom),
      hijriDateTo: clearDates ? null : (hijriDateTo ?? this.hijriDateTo),
      recordBookCategory: clearRecordBookCategory
          ? null
          : (recordBookCategory ?? this.recordBookCategory),
      recordBookTypeId: clearRecordBookTypeId
          ? null
          : (recordBookTypeId ?? this.recordBookTypeId),
    );
  }
}

// Create a provider for All Entries specifically
final allEntriesProvider =
    StateNotifierProvider.autoDispose<AllEntriesNotifier, AllEntriesState>((
      ref,
    ) {
      return AllEntriesNotifier(getIt<AdminRepository>());
    });

class AllEntriesNotifier extends StateNotifier<AllEntriesState> {
  final AdminRepository _repository;

  AllEntriesNotifier(this._repository) : super(const AllEntriesState()) {
    fetchEntries();
  }

  Future<void> fetchEntries({bool refresh = false}) async {
    if (state.isLoading || (state.isFetchingMore && !refresh)) return;

    if (refresh) {
      state = state.copyWith(
        isLoading: true,
        page: 1,
        hasMore: true,
        error: null,
      );
    } else {
      if (!state.hasMore) return;
      state = state.copyWith(isFetchingMore: true, error: null);
    }

    try {
      final newEntries = await _repository.getRegistryEntries(
        page: state.page,
        searchQuery: state.searchQuery,
        status: state.status,
        year: state.year,
        contractTypeId: state.contractTypeId,
        writerType: state.writerType,
        filteredWriterId: state.filteredWriterId,
        dateFilterType: state.dateFilterType,
        dateFrom: state.dateFrom,
        dateTo: state.dateTo,
        hijriDateFrom: state.hijriDateFrom,
        hijriDateTo: state.hijriDateTo,
        recordBookCategory: state.recordBookCategory,
        recordBookTypeId: state.recordBookTypeId,
      );

      state = state.copyWith(
        entries: refresh ? newEntries : [...state.entries, ...newEntries],
        isLoading: false,
        isFetchingMore: false,
        hasMore: newEntries.length >= 10, // Assuming 10 is the per_page limit
        page: state.page + 1,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        isFetchingMore: false,
        error: e.toString(),
      );
    }
  }

  void loadMore() {
    fetchEntries();
  }

  void updateFilters({
    String? search,
    bool clearSearch = false,
    String? status,
    bool clearStatus = false,
    int? year,
    bool clearYear = false,
    int? contractTypeId,
    bool clearContractTypeId = false,
    String? writerType,
    bool clearWriterType = false,
    int? filteredWriterId,
    bool clearFilteredWriterId = false,
    String? dateFilterType,
    bool clearDateFilterType = false,
    String? dateFrom,
    String? dateTo,
    String? hijriDateFrom,
    String? hijriDateTo,
    bool clearDates = false,
    String? recordBookCategory,
    bool clearRecordBookCategory = false,
    int? recordBookTypeId,
    bool clearRecordBookTypeId = false,
  }) {
    state = state.copyWith(
      searchQuery: search ?? state.searchQuery,
      clearSearchQuery: clearSearch,
      status: status ?? state.status,
      clearStatus: clearStatus,
      year: year ?? state.year,
      clearYear: clearYear,
      contractTypeId: contractTypeId ?? state.contractTypeId,
      clearContractTypeId: clearContractTypeId,
      writerType: writerType ?? state.writerType,
      clearWriterType: clearWriterType,
      filteredWriterId: filteredWriterId ?? state.filteredWriterId,
      clearFilteredWriterId: clearFilteredWriterId,
      dateFilterType: dateFilterType ?? state.dateFilterType,
      clearDateFilterType: clearDateFilterType,
      dateFrom: dateFrom ?? state.dateFrom,
      dateTo: dateTo ?? state.dateTo,
      hijriDateFrom: hijriDateFrom ?? state.hijriDateFrom,
      hijriDateTo: hijriDateTo ?? state.hijriDateTo,
      clearDates: clearDates,
      recordBookCategory: recordBookCategory ?? state.recordBookCategory,
      clearRecordBookCategory: clearRecordBookCategory,
      recordBookTypeId: recordBookTypeId ?? state.recordBookTypeId,
      clearRecordBookTypeId: clearRecordBookTypeId,
    );
    fetchEntries(refresh: true);
  }

  void setContractType(int? typeId) {
    state = state.copyWith(
      contractTypeId: typeId,
      clearContractTypeId: typeId == null,
    );
    fetchEntries(refresh: true);
  }

  void setWriterType(String? type) {
    state = state.copyWith(writerType: type, clearWriterType: type == null);
    fetchEntries(refresh: true);
  }

  void setStatus(String? newStatus) {
    state = state.copyWith(status: newStatus, clearStatus: newStatus == null);
    fetchEntries(refresh: true);
  }

  void setDates(String? from, String? to) {
    state = state.copyWith(
      dateFrom: from,
      dateTo: to,
      clearDates: from == null && to == null,
    );
    fetchEntries(refresh: true);
  }

  void setHijriDates(String? from, String? to) {
    state = state.copyWith(
      hijriDateFrom: from,
      hijriDateTo: to,
      clearDates: from == null && to == null,
    );
    fetchEntries(refresh: true);
  }

  void clearFilters() {
    state =
        const AllEntriesState(); // Resets everything to default but we want to fetch right after
    state = state.copyWith(isLoading: true);
    fetchEntries(refresh: true);
  }
}

class AllEntriesTab extends ConsumerWidget {
  const AllEntriesTab({super.key});

  Widget _buildSearchBarAndFilterIcon(
    BuildContext context,
    WidgetRef ref,
    AllEntriesNotifier notifier,
    AllEntriesState entriesState,
  ) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              decoration: InputDecoration(
                hintText: 'بحث في المحررات (رقم القيد، الأطراف...)',
                hintStyle: TextStyle(
                  fontFamily: 'Tajawal',
                  fontSize: 13,
                  color: Colors.grey.shade400,
                ),
                prefixIcon: const Icon(Icons.search, color: AppColors.primary),
                filled: true,
                fillColor: Colors.grey[100],
                contentPadding: const EdgeInsets.symmetric(vertical: 0),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
              onChanged: (val) {
                notifier.updateFilters(search: val, clearSearch: val.isEmpty);
              },
            ),
          ),
          const SizedBox(width: 8),
          Container(
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(12),
            ),
            child: IconButton(
              icon: const Icon(Icons.tune, color: AppColors.primary),
              onPressed: () {
                showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  backgroundColor: Colors.transparent,
                  builder: (ctx) => const AdvancedAllEntriesFilterSheet(),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActiveFiltersRow(
    AllEntriesState state,
    AllEntriesNotifier notifier,
  ) {
    final activeFilters = <Widget>[];

    if (state.contractTypeId != null) {
      activeFilters.add(
        _buildActiveFilterChip(
          'نوع العقد مخصص',
          () => notifier.updateFilters(clearContractTypeId: true),
        ),
      );
    }

    if (state.status != null) {
      final statuses = {
        'documented': 'موثق',
        'registered': 'مقيدة',
        'pending': 'قيد التدقيق',
        'draft': 'مسودة',
        'rejected': 'مرفوض',
      };
      activeFilters.add(
        _buildActiveFilterChip(
          statuses[state.status] ?? state.status!,
          () => notifier.setStatus(null),
        ),
      );
    }

    if (state.writerType != null) {
      activeFilters.add(
        _buildActiveFilterChip(
          state.writerType!,
          () => notifier.updateFilters(clearWriterType: true),
        ),
      );
    }

    if (state.year != null) {
      activeFilters.add(
        _buildActiveFilterChip(
          'سنة ${state.year}',
          () => notifier.updateFilters(clearYear: true),
        ),
      );
    }

    if (state.dateFrom != null || state.dateTo != null) {
      activeFilters.add(
        _buildActiveFilterChip(
          '${state.dateFrom ?? '...'} - ${state.dateTo ?? '...'}',
          () => notifier.updateFilters(clearDates: true),
        ),
      );
    }

    if (activeFilters.isEmpty) return const SizedBox.shrink();

    return Container(
      width: double.infinity,
      color: Colors.white,
      padding: const EdgeInsets.only(bottom: 8, right: 16, left: 16),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            const Text(
              'فلاتر نشطة:',
              style: TextStyle(
                fontFamily: 'Tajawal',
                fontSize: 11,
                color: Colors.grey,
              ),
            ),
            const SizedBox(width: 8),
            ...activeFilters.expand((chip) => [chip, const SizedBox(width: 8)]),
          ],
        ),
      ),
    );
  }

  Widget _buildActiveFilterChip(String label, VoidCallback onRemove) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontFamily: 'Tajawal',
              fontSize: 11,
              color: AppColors.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(width: 4),
          GestureDetector(
            onTap: onRemove,
            child: const Icon(Icons.close, size: 14, color: AppColors.primary),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final entriesState = ref.watch(allEntriesProvider);
    final notifier = ref.read(allEntriesProvider.notifier);

    return Scaffold(
      backgroundColor: Colors.transparent,
      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          FloatingActionButton.extended(
            heroTag: 'add_entry_compact_btn',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const CompactRegistryEntryScreen(),
                ),
              );
            },
            icon: const Icon(Icons.architecture, size: 20),
            label: const Text(
              'النموذج المقسم (تجريبي)',
              style: TextStyle(
                fontFamily: 'Tajawal',
                fontWeight: FontWeight.bold,
              ),
            ),
            backgroundColor: AppColors.accent,
            foregroundColor: Colors.white,
            elevation: 4,
          ),
          const SizedBox(height: 12),
          FloatingActionButton.extended(
            heroTag: 'add_entry_normal_btn',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const AdminAddEntryScreen()),
              );
            },
            icon: const Icon(Icons.add_circle, size: 20),
            label: const Text(
              'إضافة قيد جديد',
              style: TextStyle(
                fontFamily: 'Tajawal',
                fontWeight: FontWeight.bold,
              ),
            ),
            backgroundColor: AppColors.primary,
            foregroundColor: Colors.white,
            elevation: 4,
          ),
        ],
      ),
      body: Column(
        children: [
          _buildSearchBarAndFilterIcon(context, ref, notifier, entriesState),
          _buildActiveFiltersRow(entriesState, notifier),
          // Entries List
          Expanded(
            child: entriesState.isLoading && entriesState.entries.isEmpty
                ? const Center(child: CircularProgressIndicator())
                : entriesState.error != null && entriesState.entries.isEmpty
                ? Center(
                    child: Text(
                      'حدث خطأ: ${entriesState.error}',
                      style: const TextStyle(fontFamily: 'Tajawal'),
                    ),
                  )
                : entriesState.entries.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.inbox_outlined,
                          size: 64,
                          color: Colors.grey[300],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'لا توجد محررات مطابقة',
                          style: TextStyle(
                            fontFamily: 'Tajawal',
                            color: Colors.grey[500],
                          ),
                        ),
                      ],
                    ),
                  )
                : NotificationListener<ScrollNotification>(
                    onNotification: (ScrollNotification scrollInfo) {
                      if (!entriesState.isFetchingMore &&
                          entriesState.hasMore &&
                          scrollInfo.metrics.pixels >=
                              scrollInfo.metrics.maxScrollExtent - 200) {
                        notifier.loadMore();
                      }
                      return false;
                    },
                    child: ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount:
                          entriesState.entries.length +
                          (entriesState.isFetchingMore ? 1 : 0),
                      itemBuilder: (context, index) {
                        if (index == entriesState.entries.length) {
                          return const Padding(
                            padding: EdgeInsets.symmetric(vertical: 24),
                            child: Center(child: CircularProgressIndicator()),
                          );
                        }
                        final entry = entriesState.entries[index];
                        return PremiumEntryCard(
                          entry: entry,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) =>
                                    EntryDetailsScreen(entry: entry),
                              ),
                            );
                          },
                          onEdit: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => CompactRegistryEntryScreen(
                                  initialData: entry,
                                ),
                              ),
                            ).then((_) {
                              ref
                                  .read(allEntriesProvider.notifier)
                                  .fetchEntries(refresh: true);
                            });
                          },
                          onDocument: () {
                            showModalBottomSheet(
                              context: context,
                              isScrollControlled: true,
                              backgroundColor: Colors.transparent,
                              builder: (_) => DocumentEntrySheet(
                                entry: entry,
                                onSuccess: () {
                                  ref
                                      .read(allEntriesProvider.notifier)
                                      .fetchEntries(refresh: true);
                                },
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}
