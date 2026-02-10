import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'admin_dashboard_provider.dart';

/// Reports state
class ReportsState {
  final List<int> years;
  final Map<String, dynamic>? guardianStats;
  final Map<String, dynamic>? entriesStats;
  final Map<String, dynamic>? contractTypesSummary;
  final bool isLoading;
  final String? error;

  const ReportsState({
    this.years = const [],
    this.guardianStats,
    this.entriesStats,
    this.contractTypesSummary,
    this.isLoading = false,
    this.error,
  });

  ReportsState copyWith({
    List<int>? years,
    Map<String, dynamic>? guardianStats,
    Map<String, dynamic>? entriesStats,
    Map<String, dynamic>? contractTypesSummary,
    bool? isLoading,
    String? error,
  }) {
    return ReportsState(
      years: years ?? this.years,
      guardianStats: guardianStats ?? this.guardianStats,
      entriesStats: entriesStats ?? this.entriesStats,
      contractTypesSummary: contractTypesSummary ?? this.contractTypesSummary,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

/// Reports notifier
class ReportsNotifier extends StateNotifier<ReportsState> {
  final Ref _ref;

  ReportsNotifier(this._ref) : super(const ReportsState());

  Future<void> loadYears() async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final repository = _ref.read(adminRepositoryProvider);
      final years = await repository.getAvailableYears();
      state = state.copyWith(years: years, isLoading: false);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> loadGuardianStats({
    int? year,
    String? periodType,
    String? periodValue,
  }) async {
    state = state.copyWith(isLoading: true);
    try {
      final repository = _ref.read(adminRepositoryProvider);
      final stats = await repository.getGuardianStatistics(
        year: year,
        periodType: periodType,
        periodValue: periodValue,
      );
      state = state.copyWith(guardianStats: stats, isLoading: false);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> loadEntriesStats({
    int? year,
    String? periodType,
    String? periodValue,
  }) async {
    state = state.copyWith(isLoading: true);
    try {
      final repository = _ref.read(adminRepositoryProvider);
      final stats = await repository.getEntriesStatistics(
        year: year,
        periodType: periodType,
        periodValue: periodValue,
      );
      state = state.copyWith(entriesStats: stats, isLoading: false);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> loadContractTypesSummary({
    int? year,
    String? periodType,
    String? periodValue,
  }) async {
    state = state.copyWith(isLoading: true);
    try {
      final repository = _ref.read(adminRepositoryProvider);
      final summary = await repository.getContractTypesSummary(
        year: year,
        periodType: periodType,
        periodValue: periodValue,
      );
      state = state.copyWith(contractTypesSummary: summary, isLoading: false);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }
}

final reportsProvider = StateNotifierProvider<ReportsNotifier, ReportsState>((
  ref,
) {
  return ReportsNotifier(ref);
});
