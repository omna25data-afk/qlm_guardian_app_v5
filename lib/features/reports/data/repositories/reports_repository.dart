import '../../../../core/network/api_client.dart';
import '../../../../core/network/api_endpoints.dart';
import '../models/contract_type_summary_model.dart';
import '../models/fees_report_model.dart';
import '../models/guardian_statistics_model.dart';

class ReportsRepository {
  final ApiClient _apiClient;

  ReportsRepository(this._apiClient);

  Future<List<GuardianStatisticsModel>> getGuardianStatistics({
    required int year,
    String periodType = 'annual',
    String? periodValue,
  }) async {
    try {
      final response = await _apiClient.get(
        ApiEndpoints
            .guardiansStatistics, // Make sure this endpoint exists in ApiEndpoints
        queryParameters: {
          'year': year,
          'period_type': periodType,
          if (periodValue != null) 'period_value': periodValue,
        },
      );

      final data = response.data;
      final List list = data['by_guardian'] ?? [];
      return list.map((e) => GuardianStatisticsModel.fromJson(e)).toList();
    } catch (e) {
      rethrow;
    }
  }

  Future<FeesReportModel> getFeesReport({
    required int year,
    String periodType = 'annual',
    String? periodValue,
    int? guardianId,
  }) async {
    try {
      final response = await _apiClient.get(
        ApiEndpoints.feesReport,
        queryParameters: {
          'year': year,
          'period_type': periodType,
          if (periodValue != null) 'period_value': periodValue,
          if (guardianId != null) 'guardian_id': guardianId,
        },
      );

      // The controller returns { status: true, data: { ... } }
      return FeesReportModel.fromJson(response.data);
    } catch (e) {
      rethrow;
    }
  }

  Future<ContractTypeSummaryModel> getContractTypesSummary({
    required int year,
  }) async {
    try {
      final response = await _apiClient.get(
        ApiEndpoints.contractTypesSummary,
        queryParameters: {'year': year},
      );

      return ContractTypeSummaryModel.fromJson(response.data);
    } catch (e) {
      rethrow;
    }
  }

  Future<List<int>> getAvailableYears() async {
    try {
      final response = await _apiClient.get(ApiEndpoints.reportsYears);
      return (response.data['years'] as List?)?.map((e) => e as int).toList() ??
          [];
    } catch (e) {
      return [1446, 1445]; // Default fallback
    }
  }
}
