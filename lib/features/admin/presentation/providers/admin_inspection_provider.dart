import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/admin_dashboard_provider.dart';

class AdminInspectionState {
  // سجلات الأمناء (Guardian Record Books)
  final List<Map<String, dynamic>> recordBooks;
  final Map<String, dynamic>? selectedRecordBook;
  final List<Map<String, dynamic>> entryNotes;

  // فحوصات السجلات (Record Book Inspections)
  final List<Map<String, dynamic>> inspections;
  final Map<String, dynamic>? selectedInspection;
  final List<Map<String, dynamic>> periods; // فترات الفحص المتاحة

  // إجراءات السجلات (Record Book Procedures)
  final List<Map<String, dynamic>> procedures;

  // Shared state
  final bool isLoading;
  final String? error;
  final bool hasMore;
  final int page;
  final String? searchQuery;
  final String activeSection; // 'inspections' | 'record_books' | 'procedures'

  const AdminInspectionState({
    this.recordBooks = const [],
    this.selectedRecordBook,
    this.entryNotes = const [],
    this.inspections = const [],
    this.selectedInspection,
    this.periods = const [],
    this.procedures = const [],
    this.isLoading = false,
    this.error,
    this.hasMore = true,
    this.page = 1,
    this.searchQuery,
    this.activeSection = 'inspections',
  });

  AdminInspectionState copyWith({
    List<Map<String, dynamic>>? recordBooks,
    Map<String, dynamic>? selectedRecordBook,
    bool clearSelectedRecordBook = false,
    List<Map<String, dynamic>>? entryNotes,
    List<Map<String, dynamic>>? inspections,
    Map<String, dynamic>? selectedInspection,
    bool clearSelectedInspection = false,
    List<Map<String, dynamic>>? periods,
    List<Map<String, dynamic>>? procedures,
    bool? isLoading,
    String? error,
    bool? hasMore,
    int? page,
    String? searchQuery,
    String? activeSection,
  }) {
    return AdminInspectionState(
      recordBooks: recordBooks ?? this.recordBooks,
      selectedRecordBook: clearSelectedRecordBook
          ? null
          : (selectedRecordBook ?? this.selectedRecordBook),
      entryNotes: entryNotes ?? this.entryNotes,
      inspections: inspections ?? this.inspections,
      selectedInspection: clearSelectedInspection
          ? null
          : (selectedInspection ?? this.selectedInspection),
      periods: periods ?? this.periods,
      procedures: procedures ?? this.procedures,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      hasMore: hasMore ?? this.hasMore,
      page: page ?? this.page,
      searchQuery: searchQuery ?? this.searchQuery,
      activeSection: activeSection ?? this.activeSection,
    );
  }
}

class AdminInspectionNotifier extends StateNotifier<AdminInspectionState> {
  final dynamic _repository;

  AdminInspectionNotifier(this._repository)
    : super(const AdminInspectionState());

  // ═══ سجلات الأمناء (Guardian Record Books) ═══

  Future<void> fetchRecordBooks({bool refresh = false}) async {
    if (state.isLoading) return;

    final newState = refresh
        ? AdminInspectionState(
            searchQuery: state.searchQuery,
            isLoading: true,
            activeSection: state.activeSection,
            periods: state.periods,
          )
        : state.copyWith(isLoading: true, error: null);
    state = newState;

    if (!state.hasMore && !refresh) return;

    try {
      final items = await _repository.getInspectionRecordBooks(
        page: state.page,
        search: state.searchQuery,
      );

      state = state.copyWith(
        recordBooks: refresh ? items : [...state.recordBooks, ...items],
        isLoading: false,
        hasMore: items.length >= 15,
        page: state.page + 1,
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> fetchRecordBookDetail(int id) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final detail = await _repository.getInspectionRecordBookDetail(id);
      state = state.copyWith(isLoading: false, selectedRecordBook: detail);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> fetchEntryNotes({int? registryEntryId}) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final notes = await _repository.getEntryInspectionNotes(
        registryEntryId: registryEntryId,
      );
      state = state.copyWith(isLoading: false, entryNotes: notes);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  // ═══ فحوصات السجلات (Record Book Inspections) ═══

  Future<void> fetchInspections({
    bool refresh = false,
    String? status,
    int? hijriYear,
    int? quarter,
  }) async {
    if (state.isLoading) return;

    if (refresh) {
      state = AdminInspectionState(
        searchQuery: state.searchQuery,
        isLoading: true,
        activeSection: state.activeSection,
        periods: state.periods,
      );
    } else {
      state = state.copyWith(isLoading: true, error: null);
    }

    if (!state.hasMore && !refresh) return;

    try {
      final result = await _repository.getRecordBookInspections(
        page: refresh ? 1 : state.page,
        search: state.searchQuery,
        status: status,
        hijriYear: hijriYear,
        quarter: quarter,
      );

      final items =
          (result['data'] as List?)
              ?.map((e) => e as Map<String, dynamic>)
              .toList() ??
          [];

      final meta = result['meta'] as Map<String, dynamic>? ?? {};
      final periodsData =
          (result['periods'] as List?)
              ?.map((e) => e as Map<String, dynamic>)
              .toList() ??
          [];

      state = state.copyWith(
        inspections: refresh ? items : [...state.inspections, ...items],
        periods: periodsData.isNotEmpty ? periodsData : state.periods,
        isLoading: false,
        hasMore: (meta['current_page'] ?? 1) < (meta['last_page'] ?? 1),
        page: (meta['current_page'] ?? 1) + 1,
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> fetchInspectionDetail(int id) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final detail = await _repository.getRecordBookInspectionDetail(id);
      state = state.copyWith(isLoading: false, selectedInspection: detail);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> receiveInspection(int id) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      await _repository.receiveInspection(id);
      // Refresh inspections list to reflect new status
      await fetchInspections(refresh: true);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> returnInspection(int id) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      await _repository.returnInspection(id);
      await fetchInspections(refresh: true);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> completeInspection(int id, {String? notes}) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      await _repository.completeInspection(id, generalNotes: notes);
      await fetchInspections(refresh: true);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  // ═══ الإجراءات (Procedures) ═══

  Future<void> fetchProcedures({
    bool refresh = false,
    String? procedureType,
    int? hijriYear,
  }) async {
    if (state.isLoading) return;

    if (refresh) {
      state = AdminInspectionState(
        searchQuery: state.searchQuery,
        isLoading: true,
        activeSection: state.activeSection,
        periods: state.periods,
      );
    } else {
      state = state.copyWith(isLoading: true, error: null);
    }

    if (!state.hasMore && !refresh) return;

    try {
      final items = await _repository.getInspectionProcedures(
        page: refresh ? 1 : state.page,
        search: state.searchQuery,
        procedureType: procedureType,
        hijriYear: hijriYear,
      );

      state = state.copyWith(
        procedures: refresh ? items : [...state.procedures, ...items],
        isLoading: false,
        hasMore: items.length >= 20,
        page: state.page + 1,
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  // ═══ Shared ═══

  void setSearchQuery(String query) {
    state = state.copyWith(searchQuery: query);
    _fetchCurrentSection(refresh: true);
  }

  void setActiveSection(String section) {
    state = state.copyWith(activeSection: section, page: 1, hasMore: true);
    _fetchCurrentSection(refresh: true);
  }

  void _fetchCurrentSection({bool refresh = false}) {
    switch (state.activeSection) {
      case 'inspections':
        fetchInspections(refresh: refresh);
        break;
      case 'record_books':
        fetchRecordBooks(refresh: refresh);
        break;
      case 'procedures':
        fetchProcedures(refresh: refresh);
        break;
    }
  }
}

final adminInspectionProvider =
    StateNotifierProvider<AdminInspectionNotifier, AdminInspectionState>((ref) {
      final repository = ref.watch(adminRepositoryProvider);
      return AdminInspectionNotifier(repository);
    });
