import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';
import '../../../../core/network/api_client.dart';
import '../../data/models/contract_type_summary_model.dart';
import '../../data/models/fees_report_model.dart';
import '../../data/models/guardian_statistics_model.dart';
import '../../data/repositories/reports_repository.dart';

// Repository Provider
final reportsRepositoryProvider = Provider<ReportsRepository>((ref) {
  return ReportsRepository(GetIt.instance<ApiClient>());
});

// State for Filters
class ReportsFilter {
  final int year;
  final String periodType; // 'annual', 'quarterly', 'semi_annual'
  final String? periodValue; // 'Q1', '1', etc.

  ReportsFilter({
    required this.year,
    this.periodType = 'annual',
    this.periodValue,
  });

  ReportsFilter copyWith({int? year, String? periodType, String? periodValue}) {
    return ReportsFilter(
      year: year ?? this.year,
      periodType: periodType ?? this.periodType,
      periodValue: periodValue ?? this.periodValue,
    );
  }
}

final reportsFilterProvider = StateProvider<ReportsFilter>((ref) {
  return ReportsFilter(year: 1446); // Default year, maybe fetch current
});

// Providers for Data
final availableYearsProvider = FutureProvider<List<int>>((ref) async {
  final repo = ref.read(reportsRepositoryProvider);
  return repo.getAvailableYears();
});

final guardianStatisticsProvider =
    FutureProvider<List<GuardianStatisticsModel>>((ref) async {
      final repo = ref.read(reportsRepositoryProvider);
      final filter = ref.watch(reportsFilterProvider);
      return repo.getGuardianStatistics(
        year: filter.year,
        periodType: filter.periodType,
        periodValue: filter.periodValue,
      );
    });

final feesReportProvider = FutureProvider<FeesReportModel>((ref) async {
  final repo = ref.read(reportsRepositoryProvider);
  final filter = ref.watch(reportsFilterProvider);
  return repo.getFeesReport(
    year: filter.year,
    periodType: filter.periodType,
    periodValue: filter.periodValue,
  );
});

final contractTypeSummaryProvider = FutureProvider<ContractTypeSummaryModel>((
  ref,
) async {
  final repo = ref.read(reportsRepositoryProvider);
  final filter = ref.watch(reportsFilterProvider);
  return repo.getContractTypesSummary(year: filter.year);
});
