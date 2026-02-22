import 'package:dio/dio.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/network/api_endpoints.dart';
import '../models/admin_area_model.dart';
import '../models/admin_assignment_model.dart';
import '../models/admin_dashboard_data.dart';
import '../models/admin_guardian_model.dart';
import '../models/admin_renewal_model.dart';
import '../../../records/data/models/record_book.dart';
import '../../../system/data/models/registry_entry_sections.dart';

import '../../../system/data/repositories/system_repository.dart';

class AdminRepository {
  final ApiClient _apiClient;
  final SystemRepository _systemRepository;

  AdminRepository(this._apiClient, this._systemRepository);

  // ─── Guardians ───────────────────────────────────────────

  /// Fetch guardians list with optional search query
  Future<List<AdminGuardianModel>> getGuardians({
    String? query,
    int page = 1,
  }) async {
    try {
      final params = <String, dynamic>{'page': page};
      if (query != null && query.isNotEmpty) {
        params['search'] = query;
      }
      final response = await _apiClient.get(
        ApiEndpoints.adminGuardians,
        queryParameters: params,
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
  /// Fetch dashboard data
  Future<AdminDashboardData> getDashboardData() async {
    try {
      final response = await _apiClient.get(ApiEndpoints.adminDashboard);
      final data =
          response.data is Map<String, dynamic> &&
              response.data.containsKey('data')
          ? response.data['data']
          : response.data;
      return AdminDashboardData.fromJson(data ?? {});
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
    final params = <String, dynamic>{'page': page};
    if (searchQuery != null && searchQuery.isNotEmpty) {
      params['search'] = searchQuery;
    }
    if (type != null) params['type'] = type;
    if (parentId != null) params['parent_id'] = parentId;

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

  // ─── Record Books ────────────────────────────────────────

  /// Fetch record books (Admin)
  Future<List<RecordBook>> getRecordBooks({
    int page = 1,
    String? searchQuery,
    String? status,
    int? contractTypeId,
    String? category,
    String? type,
    String? guardianId,
    String? sortBy,
    String? dateFrom,
    String? dateTo,
    String? periodType,
    String? periodValue,
    int? periodYear,
  }) async {
    final params = <String, dynamic>{'page': page};
    if (searchQuery != null && searchQuery.isNotEmpty) {
      params['search'] = searchQuery;
    }
    if (status != null && status != 'all') params['status'] = status;
    if (contractTypeId != null) params['contract_type_id'] = contractTypeId;
    if (category != null && category != 'all') params['category'] = category;
    if (type != null && type != 'all') params['type'] = type;
    if (guardianId != null && guardianId.isNotEmpty) {
      params['guardian_id'] = guardianId;
    }
    if (sortBy != null) params['sort_by'] = sortBy;
    if (dateFrom != null && dateFrom.isNotEmpty) {
      params['date_from'] = dateFrom;
    }
    if (dateTo != null && dateTo.isNotEmpty) params['date_to'] = dateTo;
    if (periodType != null) params['period_type'] = periodType;
    if (periodValue != null) params['period_value'] = periodValue;
    if (periodYear != null) params['hijri_year'] = periodYear;

    final response = await _systemRepository.getAdminRecordBooks(params);

    // The generated response returns the raw Dio Response.
    // We expect the data to be in response.data['data'] for paginated lists.
    final List? data = response.data['data'] is List
        ? response.data['data']
        : (response.data is List ? response.data : null);

    return data?.map((e) => RecordBook.fromJson(e)).toList() ?? [];
  }

  /// Fetch internal writers (data entry users)
  Future<List<Map<String, dynamic>>> getWriters() async {
    final response = await _apiClient.get(ApiEndpoints.adminWriters);
    return (response.data['data'] as List?)
            ?.map((e) => e as Map<String, dynamic>)
            .toList() ??
        [];
  }

  // Note: getRenewals() removed — /admin/renewals route does not exist.
  // Use getLicenses() and getCards() instead.

  // ─── Registry Entries ────────────────────────────────────

  /// Fetch registry entries (Admin)
  Future<List<RegistryEntrySections>> getRegistryEntries({
    int page = 1,
    String? searchQuery,
    String? status,
    int? recordBookId,
    int? year,
    int? contractTypeId,
    String? writerType,
    String? dateFrom,
    String? dateTo,
  }) async {
    final params = <String, dynamic>{'page': page};
    if (searchQuery != null && searchQuery.isNotEmpty) {
      params['search'] = searchQuery;
    }
    if (status != null && status != 'all') params['status'] = status;
    if (recordBookId != null) params['guardian_record_book_id'] = recordBookId;
    if (year != null) params['year'] = year;
    if (contractTypeId != null) params['contract_type_id'] = contractTypeId;
    if (writerType != null) params['writer_type'] = writerType;
    if (dateFrom != null) params['date_from'] = dateFrom;
    if (dateTo != null) params['date_to'] = dateTo;

    final response = await _systemRepository.getRegistryEntries(params);

    final List? data = response.data['data'] is List
        ? response.data['data']
        : (response.data is List ? response.data : null);

    return data?.map((e) => RegistryEntrySections.fromJson(e)).toList() ?? [];
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

  /// Fees report
  Future<Map<String, dynamic>> getFeesReport({
    int? year,
    String? periodType,
    String? periodValue,
    int? contractTypeId,
  }) async {
    final params = <String, dynamic>{};
    if (year != null) params['year'] = year;
    if (periodType != null) params['period_type'] = periodType;
    if (periodValue != null) params['period_value'] = periodValue;
    if (contractTypeId != null) params['contract_type_id'] = contractTypeId;

    final response = await _apiClient.get(
      ApiEndpoints.feesReport,
      queryParameters: params.isNotEmpty ? params : null,
    );
    return response.data;
  }

  /// Guardian detail report
  Future<Map<String, dynamic>> getGuardianDetailReport(
    int guardianId, {
    int? year,
    String? periodType,
    String? periodValue,
  }) async {
    final params = <String, dynamic>{};
    if (year != null) params['year'] = year;
    if (periodType != null) params['period_type'] = periodType;
    if (periodValue != null) params['period_value'] = periodValue;

    final response = await _apiClient.get(
      ApiEndpoints.guardianDetailReport(guardianId),
      queryParameters: params.isNotEmpty ? params : null,
    );
    return response.data;
  }

  // ─── Record Book Actions ────────────────────────────────

  /// Create a new record book
  Future<void> createRecordBook(Map<String, dynamic> data) async {
    await _apiClient.post(ApiEndpoints.adminRecordBooks, data: data);
  }

  /// Update a record book
  Future<void> updateRecordBook(int id, Map<String, dynamic> data) async {
    await _apiClient.put(ApiEndpoints.adminRecordBookUpdate(id), data: data);
  }

  /// Open a record book
  Future<void> openRecordBook(int id, {String? date}) async {
    await _apiClient.post(
      ApiEndpoints.adminRecordBookOpen(id),
      data: date != null ? {'opening_date': date} : null,
    );
  }

  /// Close a record book
  Future<void> closeRecordBook(int id, {String? date}) async {
    await _apiClient.post(
      ApiEndpoints.adminRecordBookClose(id),
      data: date != null ? {'closing_date': date} : null,
    );
  }

  /// Fetch record book procedures
  Future<List<Map<String, dynamic>>> getRecordBookProcedures(int id) async {
    final response = await _apiClient.get(
      ApiEndpoints.adminRecordBookProcedures(id),
    );
    return (response.data['data'] as List?)
            ?.map((e) => e as Map<String, dynamic>)
            .toList() ??
        [];
  }

  // ─── Registry Entry Actions ─────────────────────────────

  /// Fetch pending documentation entries
  Future<List<RegistryEntrySections>> getPendingEntries({
    int page = 1,
    String? search,
    int? year,
    int? contractTypeId,
  }) async {
    final params = <String, dynamic>{'page': page};
    if (search != null && search.isNotEmpty) params['search'] = search;
    if (year != null) params['year'] = year;
    if (contractTypeId != null) params['contract_type_id'] = contractTypeId;

    final response = await _apiClient.get(
      ApiEndpoints.adminPendingEntries,
      queryParameters: params,
    );
    return (response.data['data'] as List?)
            ?.map((e) => RegistryEntrySections.fromJson(e))
            .toList() ??
        [];
  }

  /// Document a registry entry
  Future<void> documentEntry(int id, Map<String, dynamic> data) async {
    await _apiClient.put(ApiEndpoints.adminDocumentEntry(id), data: data);
  }

  /// Calculate fees for a registry entry
  Future<Map<String, dynamic>> calculateFees(
    int id, {
    double? contractValue,
  }) async {
    final response = await _apiClient.post(
      ApiEndpoints.calculateFees(id),
      data: contractValue != null ? {'contract_value': contractValue} : null,
    );
    return response.data['data'] ?? response.data;
  }

  // ─── Registry Entry Creation ─────────────────────────────

  /// Store a new registry entry (Admin)
  Future<Map<String, dynamic>> storeRegistryEntry(
    Map<String, dynamic> data,
  ) async {
    final response = await _apiClient.post(
      ApiEndpoints.adminRegistryEntries,
      data: data,
    );
    return response.data is Map<String, dynamic>
        ? response.data
        : {'status': true};
  }

  /// Update a registry entry (Correction)
  Future<void> updateRegistryEntry(int id, Map<String, dynamic> data) async {
    await _apiClient.put(ApiEndpoints.registryEntry(id), data: data);
  }

  /// Fetch contract types list
  Future<List<Map<String, dynamic>>> getContractTypes() async {
    final response = await _apiClient.get(ApiEndpoints.contractTypes);
    final data = response.data;
    if (data is List) return data.cast<Map<String, dynamic>>();
    if (data is Map && data['data'] is List) {
      return (data['data'] as List).cast<Map<String, dynamic>>();
    }
    return [];
  }

  /// Fetch contract subtypes
  Future<List<Map<String, dynamic>>> getContractSubtypes(
    int contractTypeId, {
    String? parentCode,
  }) async {
    final params = <String, dynamic>{};
    if (parentCode != null) params['parent_code'] = parentCode;
    final response = await _apiClient.get(
      ApiEndpoints.contractSubtypes(contractTypeId),
      queryParameters: params,
    );
    final data = response.data;
    if (data is List) return data.cast<Map<String, dynamic>>();
    if (data is Map && data['data'] is List) {
      return (data['data'] as List).cast<Map<String, dynamic>>();
    }
    return [];
  }

  /// Fetch guardians for selection dropdown
  Future<List<AdminGuardianModel>> getActiveGuardians() async {
    final response = await _apiClient.get(
      ApiEndpoints.adminGuardians,
      queryParameters: {'per_page': 200},
    );
    final data = response.data;
    final list = data is List ? data : (data['data'] as List?) ?? [];
    return list.map((e) => AdminGuardianModel.fromJson(e)).toList();
  }

  // ─── Basic Data ─────────────────────────────────────────

  /// Fetch fee customizations
  Future<List<Map<String, dynamic>>> getFeeCustomizations() async {
    final response = await _apiClient.get(ApiEndpoints.adminFeeCustomizations);
    return (response.data['data'] as List?)
            ?.map((e) => e as Map<String, dynamic>)
            .toList() ??
        [];
  }

  /// Create a fee customization
  Future<void> createFeeCustomization(Map<String, dynamic> data) async {
    await _apiClient.post(ApiEndpoints.adminFeeCustomizations, data: data);
  }

  /// Fetch record book templates
  Future<List<Map<String, dynamic>>> getRecordBookTemplates() async {
    final response = await _apiClient.get(
      ApiEndpoints.adminRecordBookTemplates,
    );
    return (response.data['data'] as List?)
            ?.map((e) => e as Map<String, dynamic>)
            .toList() ??
        [];
  }

  /// Fetch other writers
  Future<List<Map<String, dynamic>>> getOtherWriters() async {
    final response = await _apiClient.get(ApiEndpoints.adminOtherWriters);
    return (response.data['data'] as List?)
            ?.map((e) => e as Map<String, dynamic>)
            .toList() ??
        [];
  }

  /// Fetch form fields for a contract type
  Future<List<Map<String, dynamic>>> getFormFields(int contractTypeId) async {
    final response = await _apiClient.get(
      ApiEndpoints.formFields(contractTypeId),
    );
    return (response.data['fields'] as List?)
            ?.map((e) => e as Map<String, dynamic>)
            .toList() ??
        [];
  }

  /// Fetch contract types (admin detailed)
  Future<List<Map<String, dynamic>>> getAdminContractTypes() async {
    final response = await _apiClient.get(ApiEndpoints.adminContractTypes);
    return (response.data['data'] as List?)
            ?.map((e) => e as Map<String, dynamic>)
            .toList() ??
        [];
  }

  /// Fetch constraint types
  Future<List<Map<String, dynamic>>> getConstraintTypes() async {
    final response = await _apiClient.get(ApiEndpoints.adminConstraintTypes);
    return (response.data['data'] as List?)
            ?.map((e) => e as Map<String, dynamic>)
            .toList() ??
        [];
  }

  /// Fetch record book types (admin detailed)
  Future<List<Map<String, dynamic>>> getAdminRecordBookTypes() async {
    final response = await _apiClient.get(ApiEndpoints.adminRecordBookTypes);
    return (response.data['data'] as List?)
            ?.map((e) => e as Map<String, dynamic>)
            .toList() ??
        [];
  }

  // ─── Inspection ─────────────────────────────────────────

  /// Fetch record books for inspection
  Future<List<Map<String, dynamic>>> getInspectionRecordBooks({
    int page = 1,
    String? search,
    int? guardianId,
    String? status,
  }) async {
    final params = <String, dynamic>{'page': page};
    if (search != null && search.isNotEmpty) params['search'] = search;
    if (guardianId != null) params['guardian_id'] = guardianId;
    if (status != null) params['status'] = status;

    final response = await _apiClient.get(
      ApiEndpoints.adminInspectionRecordBooks,
      queryParameters: params,
    );
    return (response.data['data'] as List?)
            ?.map((e) => e as Map<String, dynamic>)
            .toList() ??
        [];
  }

  /// Fetch record book detail for inspection
  Future<Map<String, dynamic>> getInspectionRecordBookDetail(int id) async {
    final response = await _apiClient.get(
      ApiEndpoints.adminInspectionRecordBookDetail(id),
    );
    return response.data['data'] ?? response.data;
  }

  /// Fetch entry inspection notes
  Future<List<Map<String, dynamic>>> getEntryInspectionNotes({
    int page = 1,
    int? registryEntryId,
    int? recordBookInspectionId,
  }) async {
    final params = <String, dynamic>{'page': page};
    if (registryEntryId != null) {
      params['registry_entry_id'] = registryEntryId;
    }
    if (recordBookInspectionId != null) {
      params['record_book_inspection_id'] = recordBookInspectionId;
    }

    final response = await _apiClient.get(
      ApiEndpoints.adminInspectionEntryNotes,
      queryParameters: params,
    );
    return (response.data['data'] as List?)
            ?.map((e) => e as Map<String, dynamic>)
            .toList() ??
        [];
  }

  // ─── Record Book Inspections (فحوصات السجلات) ─────────────

  /// Fetch record book inspections list
  Future<Map<String, dynamic>> getRecordBookInspections({
    int page = 1,
    String? search,
    String? status,
    int? hijriYear,
    int? quarter,
    int? guardianId,
  }) async {
    final params = <String, dynamic>{'page': page};
    if (search != null && search.isNotEmpty) params['search'] = search;
    if (status != null) params['status'] = status;
    if (hijriYear != null) params['hijri_year'] = hijriYear;
    if (quarter != null) params['quarter'] = quarter;
    if (guardianId != null) params['guardian_id'] = guardianId;

    final response = await _apiClient.get(
      ApiEndpoints.adminRecordBookInspections,
      queryParameters: params,
    );
    return response.data;
  }

  /// Fetch record book inspection detail
  Future<Map<String, dynamic>> getRecordBookInspectionDetail(int id) async {
    final response = await _apiClient.get(
      ApiEndpoints.adminRecordBookInspectionDetail(id),
    );
    return response.data['data'] ?? response.data;
  }

  /// Receive a record book for inspection
  Future<Map<String, dynamic>> receiveInspection(int id) async {
    final response = await _apiClient.post(
      ApiEndpoints.adminReceiveInspection(id),
    );
    return response.data;
  }

  /// Return a record book after inspection
  Future<Map<String, dynamic>> returnInspection(int id) async {
    final response = await _apiClient.post(
      ApiEndpoints.adminReturnInspection(id),
    );
    return response.data;
  }

  /// Complete an inspection
  Future<Map<String, dynamic>> completeInspection(
    int id, {
    String? generalNotes,
  }) async {
    final response = await _apiClient.post(
      ApiEndpoints.adminCompleteInspection(id),
      data: generalNotes != null ? {'general_notes': generalNotes} : null,
    );
    return response.data;
  }

  // ─── Record Book Procedures (إجراءات السجلات) ─────────────

  /// Fetch all inspection procedures (صرف/افتتاح/إغلاق/أرشفة)
  Future<List<Map<String, dynamic>>> getInspectionProcedures({
    int page = 1,
    String? search,
    String? procedureType,
    int? hijriYear,
    int? recordBookId,
  }) async {
    final params = <String, dynamic>{'page': page};
    if (search != null && search.isNotEmpty) params['search'] = search;
    if (procedureType != null) params['procedure_type'] = procedureType;
    if (hijriYear != null) params['hijri_year'] = hijriYear;
    if (recordBookId != null) params['record_book_id'] = recordBookId;

    final response = await _apiClient.get(
      ApiEndpoints.adminInspectionProcedures,
      queryParameters: params,
    );
    return (response.data['data'] as List?)
            ?.map((e) => e as Map<String, dynamic>)
            .toList() ??
        [];
  }

  /// Delete a guardian
  Future<void> deleteGuardian(int id) async {
    await _apiClient.delete('${ApiEndpoints.adminGuardians}/$id');
  }

  /// Fetch guardian inspections
  Future<List<Map<String, dynamic>>> getGuardianInspections(int id) async {
    final response = await _apiClient.get(
      ApiEndpoints.adminGuardianInspections(id),
    );
    return (response.data['data'] as List?)
            ?.map((e) => e as Map<String, dynamic>)
            .toList() ??
        [];
  }
}
