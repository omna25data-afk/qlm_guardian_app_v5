import 'package:dio/dio.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/network/api_endpoints.dart';
import '../models/admin_area_model.dart';
import '../models/admin_assignment_model.dart';
import '../models/admin_dashboard_data.dart';
import '../models/admin_guardian_model.dart';
import '../models/admin_renewal_model.dart';

class AdminRepository {
  final ApiClient _apiClient;

  AdminRepository(this._apiClient);

  // ─── Guardians ───────────────────────────────────────────

  /// Fetch guardians list with optional search query
  Future<List<AdminGuardianModel>> getGuardians({String? query}) async {
    try {
      final response = await _apiClient.get(
        ApiEndpoints.adminGuardians,
        queryParameters: query != null ? {'search': query} : null,
      );
      return (response.data['data'] as List?)
              ?.map((e) => AdminGuardianModel.fromJson(e))
              .toList() ??
          [];
    } catch (e) {
      rethrow;
    }
  }

  /// Fetch guardian details by ID
  Future<AdminGuardianModel> getGuardianDetails(int id) async {
    final response = await _apiClient.get('${ApiEndpoints.adminGuardians}/$id');
    return AdminGuardianModel.fromJson(response.data['data'] ?? response.data);
  }

  /// Create a new guardian
  Future<void> createGuardian(
    Map<String, dynamic> data, {
    String? imagePath,
  }) async {
    dynamic body = data;

    if (imagePath != null) {
      body = FormData.fromMap({
        ...data,
        'photo': await MultipartFile.fromFile(
          imagePath,
          filename: imagePath.split('/').last,
        ),
      });
    }

    await _apiClient.post(ApiEndpoints.adminGuardians, data: body);
  }

  /// Update an existing guardian
  Future<void> updateGuardian(
    int id,
    Map<String, dynamic> data, {
    String? imagePath,
  }) async {
    dynamic body = data;

    if (imagePath != null) {
      body = FormData.fromMap({
        ...data,
        'photo': await MultipartFile.fromFile(
          imagePath,
          filename: imagePath.split('/').last,
        ),
      });
    }

    // Using POST with _method=PUT to support multipart with PUT in Laravel
    if (imagePath != null) {
      (body as FormData).fields.add(const MapEntry('_method', 'PUT'));
      await _apiClient.post('${ApiEndpoints.adminGuardians}/$id', data: body);
    } else {
      await _apiClient.put('${ApiEndpoints.adminGuardians}/$id', data: body);
    }
  }

  // ─── Dashboard ───────────────────────────────────────────

  /// Fetch dashboard data
  Future<AdminDashboardData> getDashboardData() async {
    try {
      final response = await _apiClient.get(ApiEndpoints.adminDashboard);
      return AdminDashboardData.fromJson(response.data ?? {});
    } catch (e) {
      rethrow;
    }
  }

  /// Get urgent actions
  Future<List<UrgentAction>> getUrgentActions() async {
    try {
      final response = await _apiClient.get(
        '${ApiEndpoints.adminDashboard}/urgent-actions',
      );
      return (response.data['data'] as List?)
              ?.map((e) => UrgentAction.fromJson(e))
              .toList() ??
          [];
    } catch (e) {
      rethrow;
    }
  }

  // ─── Areas ───────────────────────────────────────────────

  /// Fetch areas with pagination and filters
  Future<List<AdminAreaModel>> getAreas({
    int page = 1,
    String? searchQuery,
    String? type,
    String? parentId,
  }) async {
    final params = <String, dynamic>{'page': page, 'filter[is_active]': '1'};
    if (searchQuery != null && searchQuery.isNotEmpty) {
      params['filter[name]'] = searchQuery;
    }
    if (type != null) params['filter[type]'] = type;
    if (parentId != null) params['filter[parent_id]'] = parentId;

    final response = await _apiClient.get(
      ApiEndpoints.adminAreas,
      queryParameters: params,
    );
    return (response.data['data'] as List?)
            ?.map((e) => AdminAreaModel.fromJson(e))
            .toList() ??
        [];
  }

  Future<List<AdminAreaModel>> getDistricts({String? query}) =>
      getAreas(searchQuery: query, type: 'عزلة');

  Future<List<AdminAreaModel>> getVillages({String? query, String? parentId}) =>
      getAreas(searchQuery: query, type: 'قرية', parentId: parentId);

  Future<List<AdminAreaModel>> getLocalities({
    String? query,
    String? parentId,
  }) => getAreas(searchQuery: query, type: 'محل', parentId: parentId);

  /// Create a new area
  Future<void> createArea(Map<String, dynamic> data) async {
    await _apiClient.post(ApiEndpoints.adminAreas, data: data);
  }

  // ─── Assignments ─────────────────────────────────────────

  /// Fetch assignments with pagination and filters
  Future<List<AdminAssignmentModel>> getAssignments({
    int page = 1,
    String? searchQuery,
    String? status,
    String? type,
  }) async {
    final params = <String, dynamic>{'page': page};
    if (searchQuery != null && searchQuery.isNotEmpty) {
      params['filter[serial_number]'] = searchQuery;
    }
    if (status != null && status != 'all') params['status'] = status;
    if (type != null && type != 'all') params['type'] = type;

    final response = await _apiClient.get(
      ApiEndpoints.adminAssignments,
      queryParameters: params,
    );
    return (response.data['data'] as List?)
            ?.map((e) => AdminAssignmentModel.fromJson(e))
            .toList() ??
        [];
  }

  /// Create a new assignment
  Future<void> createAssignment(Map<String, dynamic> data) async {
    await _apiClient.post(ApiEndpoints.adminAssignments, data: data);
  }

  // ─── Cards ───────────────────────────────────────────────

  /// Fetch profession cards
  Future<List<AdminRenewalModel>> getCards({int page = 1}) async {
    final response = await _apiClient.get(
      ApiEndpoints.adminCards,
      queryParameters: {'page': page},
    );
    return (response.data['data'] as List?)
            ?.map((e) => AdminRenewalModel.fromJson(e))
            .toList() ??
        [];
  }

  /// Fetch card renewals
  Future<List<AdminRenewalModel>> getCardRenewals({int page = 1}) async {
    final response = await _apiClient.get(
      ApiEndpoints.adminElectronicCardRenewals,
      queryParameters: {'page': page},
    );
    return (response.data['data'] as List?)
            ?.map((e) => AdminRenewalModel.fromJson(e))
            .toList() ??
        [];
  }

  // ─── Licenses ────────────────────────────────────────────

  /// Fetch licenses
  Future<List<AdminRenewalModel>> getLicenses({int page = 1}) async {
    final response = await _apiClient.get(
      ApiEndpoints.adminLicenses,
      queryParameters: {'page': page},
    );
    return (response.data['data'] as List?)
            ?.map((e) => AdminRenewalModel.fromJson(e))
            .toList() ??
        [];
  }

  /// Get license details
  Future<Map<String, dynamic>> getLicenseDetails(int id) async {
    final response = await _apiClient.get(
      '${ApiEndpoints.licenseManagements}/$id',
    );
    return response.data;
  }

  // ─── Renewals ────────────────────────────────────────────

  /// Submit license renewal for a guardian
  Future<void> submitLicenseRenewal(
    int guardianId,
    Map<String, dynamic> data,
  ) async {
    await _apiClient.post(
      '${ApiEndpoints.adminGuardians}/$guardianId/renew-license',
      data: data,
    );
  }

  /// Submit profession card renewal for a guardian
  Future<void> submitCardRenewal(
    int guardianId,
    Map<String, dynamic> data,
  ) async {
    await _apiClient.post(
      '${ApiEndpoints.adminGuardians}/$guardianId/renew-card',
      data: data,
    );
  }

  /// Fetch guardian renewals
  Future<List<AdminRenewalModel>> getRenewals({int page = 1}) async {
    final response = await _apiClient.get(
      ApiEndpoints.adminRenewals,
      queryParameters: {'page': page},
    );
    return (response.data['data'] as List?)
            ?.map((e) => AdminRenewalModel.fromJson(e))
            .toList() ??
        [];
  }

  // ─── Reports ─────────────────────────────────────────────

  /// Get available report years
  Future<List<int>> getAvailableYears() async {
    final response = await _apiClient.get(ApiEndpoints.reportsYears);
    final data = response.data is List ? response.data : response.data['data'];
    return (data as List).map((e) => e as int).toList();
  }

  /// Guardian statistics for reports
  Future<Map<String, dynamic>> getGuardianStatistics({
    int? year,
    String? periodType,
    String? periodValue,
  }) async {
    final params = <String, dynamic>{};
    if (year != null) params['year'] = year;
    if (periodType != null) params['period_type'] = periodType;
    if (periodValue != null) params['period_value'] = periodValue;

    final response = await _apiClient.get(
      ApiEndpoints.guardiansStatistics,
      queryParameters: params.isNotEmpty ? params : null,
    );
    return response.data;
  }

  /// Entries statistics for reports
  Future<Map<String, dynamic>> getEntriesStatistics({
    int? year,
    String? periodType,
    String? periodValue,
  }) async {
    final params = <String, dynamic>{};
    if (year != null) params['year'] = year;
    if (periodType != null) params['period_type'] = periodType;
    if (periodValue != null) params['period_value'] = periodValue;

    final response = await _apiClient.get(
      ApiEndpoints.entriesStatistics,
      queryParameters: params.isNotEmpty ? params : null,
    );
    return response.data;
  }

  /// Contract types summary for reports
  Future<Map<String, dynamic>> getContractTypesSummary({
    int? year,
    String? periodType,
    String? periodValue,
  }) async {
    final params = <String, dynamic>{};
    if (year != null) params['year'] = year;
    if (periodType != null) params['period_type'] = periodType;
    if (periodValue != null) params['period_value'] = periodValue;

    final response = await _apiClient.get(
      ApiEndpoints.contractTypesSummary,
      queryParameters: params.isNotEmpty ? params : null,
    );
    return response.data;
  }
}
