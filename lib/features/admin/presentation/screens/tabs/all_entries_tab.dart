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
import '../../../../admin/presentation/providers/admin_dashboard_provider.dart';

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
  final String? dateFrom;
  final String? dateTo;

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
    this.dateFrom,
    this.dateTo,
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
    String? dateFrom,
    String? dateTo,
    bool clearDates = false,
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
      dateFrom: clearDates ? null : (dateFrom ?? this.dateFrom),
      dateTo: clearDates ? null : (dateTo ?? this.dateTo),
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
        dateFrom: state.dateFrom,
        dateTo: state.dateTo,
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
    String? dateFrom,
    String? dateTo,
    bool clearDates = false,
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
      dateFrom: dateFrom ?? state.dateFrom,
      dateTo: dateTo ?? state.dateTo,
      clearDates: clearDates,
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

  void clearFilters() {
    state =
        const AllEntriesState(); // Resets everything to default but we want to fetch right after
    state = state.copyWith(isLoading: true);
    fetchEntries(refresh: true);
  }
}

class AllEntriesTab extends ConsumerWidget {
  const AllEntriesTab({super.key});

  Widget _buildFilterChip({
    required String label,
    required bool isActive,
    required VoidCallback onTap,
  }) {
    return FilterChip(
      label: Text(
        label,
        style: TextStyle(
          fontFamily: 'Tajawal',
          fontSize: 13,
          color: isActive ? Colors.white : Colors.grey.shade700,
        ),
      ),
      selected: isActive,
      onSelected: (_) => onTap(),
      selectedColor: AppColors.primary,
      backgroundColor: Colors.grey.shade100,
      checkmarkColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(
          color: isActive ? AppColors.primary : Colors.grey.shade300,
        ),
      ),
    );
  }

  void _showAdvancedFilters(
    BuildContext context,
    WidgetRef ref,
    AllEntriesNotifier notifier,
    AllEntriesState entriesState,
  ) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => DraggableScrollableSheet(
        initialChildSize: 0.6,
        minChildSize: 0.4,
        maxChildSize: 0.9,
        expand: false,
        builder: (context, scrollController) {
          return FutureBuilder<List<dynamic>>(
            future: Future.wait<dynamic>([
              ref.read(adminRepositoryProvider).getAdminRecordBookTypes(),
            ]),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              }

              final types =
                  snapshot.data?[0] as List<Map<String, dynamic>>? ?? [];

              // Current filter values
              int? selectedYear = entriesState.year;
              int? selectedContractType = entriesState.contractTypeId;

              return StatefulBuilder(
                builder: (context, setModalState) {
                  return Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(
                          child: Container(
                            width: 40,
                            height: 4,
                            decoration: BoxDecoration(
                              color: Colors.grey[300],
                              borderRadius: BorderRadius.circular(2),
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),
                        const Text(
                          'تصفية متقدمة',
                          style: TextStyle(
                            fontFamily: 'Tajawal',
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 24),

                        // Year Dropdown
                        const Text(
                          'سنة الإصدار',
                          style: TextStyle(
                            fontFamily: 'Tajawal',
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey[300]!),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<int>(
                              value: selectedYear,
                              isExpanded: true,
                              hint: const Text(
                                'الكل',
                                style: TextStyle(fontFamily: 'Tajawal'),
                              ),
                              items: [
                                const DropdownMenuItem<int>(
                                  value: null,
                                  child: Text(
                                    'الكل',
                                    style: TextStyle(fontFamily: 'Tajawal'),
                                  ),
                                ),
                                ...List.generate(30, (index) {
                                  final year = DateTime.now().year - index;
                                  return DropdownMenuItem<int>(
                                    value: year,
                                    child: Text(
                                      year.toString(),
                                      style: const TextStyle(
                                        fontFamily: 'Tajawal',
                                      ),
                                    ),
                                  );
                                }),
                              ],
                              onChanged: (val) {
                                setModalState(() => selectedYear = val);
                              },
                            ),
                          ),
                        ),

                        const SizedBox(height: 16),

                        // Contract Type Dropdown
                        const Text(
                          'نوع العقد/القيد',
                          style: TextStyle(
                            fontFamily: 'Tajawal',
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey[300]!),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<int>(
                              value: selectedContractType,
                              isExpanded: true,
                              hint: const Text(
                                'الكل',
                                style: TextStyle(fontFamily: 'Tajawal'),
                              ),
                              items: [
                                const DropdownMenuItem<int>(
                                  value: null,
                                  child: Text(
                                    'الكل',
                                    style: TextStyle(fontFamily: 'Tajawal'),
                                  ),
                                ),
                                ...types.map(
                                  (t) => DropdownMenuItem<int>(
                                    value: t['id'] as int,
                                    child: Text(
                                      t['name']?.toString() ?? '',
                                      style: const TextStyle(
                                        fontFamily: 'Tajawal',
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                              onChanged: (val) {
                                setModalState(() => selectedContractType = val);
                              },
                            ),
                          ),
                        ),

                        const SizedBox(height: 16),

                        // Date of Editing filter
                        const Text(
                          'تاريخ التحرير',
                          style: TextStyle(
                            fontFamily: 'Tajawal',
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey,
                          ),
                        ),
                        const SizedBox(height: 8),
                        OutlinedButton.icon(
                          onPressed: () async {
                            final picked = await showDateRangePicker(
                              context: context,
                              firstDate: DateTime(2020),
                              lastDate: DateTime.now().add(
                                const Duration(days: 365),
                              ),
                              locale: const Locale('ar'),
                            );
                            if (picked != null) {
                              final from =
                                  '${picked.start.year}-${picked.start.month.toString().padLeft(2, '0')}-${picked.start.day.toString().padLeft(2, '0')}';
                              final to =
                                  '${picked.end.year}-${picked.end.month.toString().padLeft(2, '0')}-${picked.end.day.toString().padLeft(2, '0')}';
                              setModalState(() {
                                notifier.setDates(from, to);
                              });
                            }
                          },
                          icon: const Icon(Icons.date_range, size: 18),
                          label: Text(
                            entriesState.dateFrom != null
                                ? '${entriesState.dateFrom} → ${entriesState.dateTo ?? '...'} '
                                : 'اختر فترة التحرير',
                            style: const TextStyle(
                              fontFamily: 'Tajawal',
                              fontSize: 13,
                            ),
                          ),
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 12,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),

                        const Spacer(),

                        // Apply Button
                        SizedBox(
                          width: double.infinity,
                          child: FilledButton(
                            onPressed: () {
                              notifier.updateFilters(
                                year: selectedYear,
                                clearYear: selectedYear == null,
                                contractTypeId: selectedContractType,
                                clearContractTypeId:
                                    selectedContractType == null,
                              );
                              Navigator.pop(ctx);
                            },
                            style: FilledButton.styleFrom(
                              backgroundColor: AppColors.primary,
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: const Text(
                              'تطبيق الفلتر',
                              style: TextStyle(
                                fontFamily: 'Tajawal',
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        // Clear Filters
                        Center(
                          child: TextButton(
                            onPressed: () {
                              notifier.clearFilters();
                              Navigator.pop(ctx);
                            },
                            child: const Text(
                              'مسح الفلاتر',
                              style: TextStyle(
                                fontFamily: 'Tajawal',
                                color: Colors.grey,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              );
            },
          );
        },
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
          // Writer Type Sub-tabs (SegmentedButton)
          Container(
            color: Colors.white,
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
            child: SizedBox(
              width: double.infinity,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: SegmentedButton<int?>(
                  style: SegmentedButton.styleFrom(
                    backgroundColor: Colors.white,
                    selectedForegroundColor: Colors.white,
                    selectedBackgroundColor: AppColors.primary,
                    textStyle: const TextStyle(
                      fontFamily: 'Tajawal',
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    side: BorderSide(color: Colors.grey.shade300),
                  ),
                  segments: const [
                    ButtonSegment<int?>(
                      value: null,
                      label: Text('الكل', overflow: TextOverflow.ellipsis),
                    ),
                    ButtonSegment<int?>(
                      value: 1,
                      label: Text('زواج', overflow: TextOverflow.ellipsis),
                    ),
                    ButtonSegment<int?>(
                      value: 7,
                      label: Text('طلاق', overflow: TextOverflow.ellipsis),
                    ),
                    ButtonSegment<int?>(
                      value: 8,
                      label: Text('رجعة', overflow: TextOverflow.ellipsis),
                    ),
                    ButtonSegment<int?>(
                      value: 10,
                      label: Text('مبيع', overflow: TextOverflow.ellipsis),
                    ),
                    ButtonSegment<int?>(
                      value: 5,
                      label: Text('تصرف', overflow: TextOverflow.ellipsis),
                    ),
                    ButtonSegment<int?>(
                      value: 4,
                      label: Text('وكالة', overflow: TextOverflow.ellipsis),
                    ),
                    ButtonSegment<int?>(
                      value: 6,
                      label: Text('قسمة', overflow: TextOverflow.ellipsis),
                    ),
                  ],
                  selected: {entriesState.contractTypeId},
                  onSelectionChanged: (Set<int?> newSelection) {
                    if (newSelection.isEmpty) return;
                    notifier.setContractType(newSelection.first);
                  },
                  showSelectedIcon: false,
                  emptySelectionAllowed: false,
                ),
              ),
            ),
          ),
          // Filter Bar (Search + Status Chips)
          Container(
            color: Colors.white,
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        decoration: InputDecoration(
                          hintText: 'بحث في المحررات (رقم القيد، الأطراف...)',
                          prefixIcon: const Icon(
                            Icons.search,
                            color: Colors.grey,
                          ),
                          filled: true,
                          fillColor: Colors.grey[50],
                          contentPadding: const EdgeInsets.symmetric(
                            vertical: 0,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none,
                          ),
                        ),
                        onChanged: (val) {
                          notifier.updateFilters(
                            search: val,
                            clearSearch: val.isEmpty,
                          );
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
                          _showAdvancedFilters(
                            context,
                            ref,
                            notifier,
                            entriesState,
                          );
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                // Status Filter Chips
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      _buildFilterChip(
                        label: 'الكل',
                        isActive: entriesState.status == null,
                        onTap: () => notifier.setStatus(null),
                      ),
                      const SizedBox(width: 8),
                      _buildFilterChip(
                        label: 'موثق',
                        isActive: entriesState.status == 'documented',
                        onTap: () => notifier.setStatus('documented'),
                      ),
                      const SizedBox(width: 8),
                      _buildFilterChip(
                        label: 'مقيدة',
                        isActive: entriesState.status == 'registered',
                        onTap: () => notifier.setStatus('registered'),
                      ),
                      const SizedBox(width: 8),
                      _buildFilterChip(
                        label: 'قيد التدقيق',
                        isActive: entriesState.status == 'pending',
                        onTap: () => notifier.setStatus('pending'),
                      ),
                      const SizedBox(width: 8),
                      _buildFilterChip(
                        label: 'مسودة',
                        isActive: entriesState.status == 'draft',
                        onTap: () => notifier.setStatus('draft'),
                      ),
                      const SizedBox(width: 8),
                      _buildFilterChip(
                        label: 'مرفوض',
                        isActive: entriesState.status == 'rejected',
                        onTap: () => notifier.setStatus('rejected'),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const Divider(height: 1),

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
                              // Refresh entries after returning from edit screen
                              ref
                                  .read(allEntriesProvider.notifier)
                                  .fetchEntries(refresh: true);
                            });
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
