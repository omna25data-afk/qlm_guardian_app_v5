import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/di/injection.dart';

class SystemRepository {
  final Dio _dio;
  final String _baseUrl;

  SystemRepository(this._dio, {String baseUrl = 'https://api.example.com'})
    : _baseUrl = baseUrl;

  Future<Response> getAdminAreas(Map<String, dynamic>? queryParams) async {
    return _dio.request(
      '$_baseUrl/api/admin/areas',
      options: Options(method: 'GET'),
      queryParameters: queryParams,
    );
  }

  Future<Response> postAdminAreas(dynamic data) async {
    return _dio.request(
      '$_baseUrl/api/admin/areas',
      options: Options(method: 'POST'),
      data: data,
    );
  }

  Future<Response> getAdminAssignments(
    Map<String, dynamic>? queryParams,
  ) async {
    return _dio.request(
      '$_baseUrl/api/admin/assignments',
      options: Options(method: 'GET'),
      queryParameters: queryParams,
    );
  }

  Future<Response> postAdminAssignments(dynamic data) async {
    return _dio.request(
      '$_baseUrl/api/admin/assignments',
      options: Options(method: 'POST'),
      data: data,
    );
  }

  Future<Response> getAdminCards(Map<String, dynamic>? queryParams) async {
    return _dio.request(
      '$_baseUrl/api/admin/cards',
      options: Options(method: 'GET'),
      queryParameters: queryParams,
    );
  }

  Future<Response> getAdminDashboard(Map<String, dynamic>? queryParams) async {
    return _dio.request(
      '$_baseUrl/api/admin/dashboard',
      options: Options(method: 'GET'),
      queryParameters: queryParams,
    );
  }

  Future<Response> getAdminGuardians(Map<String, dynamic>? queryParams) async {
    return _dio.request(
      '$_baseUrl/api/admin/guardians',
      options: Options(method: 'GET'),
      queryParameters: queryParams,
    );
  }

  Future<Response> postAdminGuardiansIdRenewCard(
    String id,
    dynamic data,
  ) async {
    return _dio.request(
      '$_baseUrl/api/admin/guardians/${id}/renew-card',
      options: Options(method: 'POST'),
      data: data,
    );
  }

  Future<Response> postAdminGuardiansIdRenewLicense(
    String id,
    dynamic data,
  ) async {
    return _dio.request(
      '$_baseUrl/api/admin/guardians/${id}/renew-license',
      options: Options(method: 'POST'),
      data: data,
    );
  }

  Future<Response> getAdminLicenses(Map<String, dynamic>? queryParams) async {
    return _dio.request(
      '$_baseUrl/api/admin/licenses',
      options: Options(method: 'GET'),
      queryParameters: queryParams,
    );
  }

  Future<Response> getAdminRecordBooks(
    Map<String, dynamic>? queryParams,
  ) async {
    return _dio.request(
      '$_baseUrl/api/admin/record-books',
      options: Options(method: 'GET'),
      queryParameters: queryParams,
    );
  }

  Future<Response> getContractTypes(Map<String, dynamic>? queryParams) async {
    return _dio.request(
      '$_baseUrl/api/contract-types',
      options: Options(method: 'GET'),
      queryParameters: queryParams,
    );
  }

  Future<Response> getContractTypesIdSubtypes(
    String id,
    Map<String, dynamic>? queryParams,
  ) async {
    return _dio.request(
      '$_baseUrl/api/contract-types/${id}/subtypes',
      options: Options(method: 'GET'),
      queryParameters: queryParams,
    );
  }

  Future<Response> getDashboard(Map<String, dynamic>? queryParams) async {
    return _dio.request(
      '$_baseUrl/api/dashboard',
      options: Options(method: 'GET'),
      queryParameters: queryParams,
    );
  }

  Future<Response> getElectronicCardRenewals(
    Map<String, dynamic>? queryParams,
  ) async {
    return _dio.request(
      '$_baseUrl/api/electronic-card-renewals',
      options: Options(method: 'GET'),
      queryParameters: queryParams,
    );
  }

  Future<Response> postElectronicCardRenewals(dynamic data) async {
    return _dio.request(
      '$_baseUrl/api/electronic-card-renewals',
      options: Options(method: 'POST'),
      data: data,
    );
  }

  Future<Response> getElectronicCardRenewalsElectronic_card_renewal(
    String electronic_card_renewal,
    Map<String, dynamic>? queryParams,
  ) async {
    return _dio.request(
      '$_baseUrl/api/electronic-card-renewals/${electronic_card_renewal}',
      options: Options(method: 'GET'),
      queryParameters: queryParams,
    );
  }

  Future<Response> putElectronicCardRenewalsElectronic_card_renewal(
    String electronic_card_renewal,
    dynamic data,
  ) async {
    return _dio.request(
      '$_baseUrl/api/electronic-card-renewals/${electronic_card_renewal}',
      options: Options(method: 'PUT'),
      data: data,
    );
  }

  Future<Response> deleteElectronicCardRenewalsElectronic_card_renewal(
    String electronic_card_renewal,
    dynamic data,
  ) async {
    return _dio.request(
      '$_baseUrl/api/electronic-card-renewals/${electronic_card_renewal}',
      options: Options(method: 'DELETE'),
      data: data,
    );
  }

  Future<Response> getFormFieldsContractTypeId(
    String contractTypeId,
    Map<String, dynamic>? queryParams,
  ) async {
    return _dio.request(
      '$_baseUrl/api/form-fields/${contractTypeId}',
      options: Options(method: 'GET'),
      queryParameters: queryParams,
    );
  }

  Future<Response> getGeographicAreas(Map<String, dynamic>? queryParams) async {
    return _dio.request(
      '$_baseUrl/api/geographic-areas',
      options: Options(method: 'GET'),
      queryParameters: queryParams,
    );
  }

  Future<Response> postGeographicAreas(dynamic data) async {
    return _dio.request(
      '$_baseUrl/api/geographic-areas',
      options: Options(method: 'POST'),
      data: data,
    );
  }

  Future<Response> getGeographicAreasGeographic_area(
    String geographic_area,
    Map<String, dynamic>? queryParams,
  ) async {
    return _dio.request(
      '$_baseUrl/api/geographic-areas/${geographic_area}',
      options: Options(method: 'GET'),
      queryParameters: queryParams,
    );
  }

  Future<Response> putGeographicAreasGeographic_area(
    String geographic_area,
    dynamic data,
  ) async {
    return _dio.request(
      '$_baseUrl/api/geographic-areas/${geographic_area}',
      options: Options(method: 'PUT'),
      data: data,
    );
  }

  Future<Response> deleteGeographicAreasGeographic_area(
    String geographic_area,
    dynamic data,
  ) async {
    return _dio.request(
      '$_baseUrl/api/geographic-areas/${geographic_area}',
      options: Options(method: 'DELETE'),
      data: data,
    );
  }

  Future<Response> getGuardianAssignments(
    Map<String, dynamic>? queryParams,
  ) async {
    return _dio.request(
      '$_baseUrl/api/guardian-assignments',
      options: Options(method: 'GET'),
      queryParameters: queryParams,
    );
  }

  Future<Response> postGuardianAssignments(dynamic data) async {
    return _dio.request(
      '$_baseUrl/api/guardian-assignments',
      options: Options(method: 'POST'),
      data: data,
    );
  }

  Future<Response> getGuardianAssignmentsGuardian_assignment(
    String guardian_assignment,
    Map<String, dynamic>? queryParams,
  ) async {
    return _dio.request(
      '$_baseUrl/api/guardian-assignments/${guardian_assignment}',
      options: Options(method: 'GET'),
      queryParameters: queryParams,
    );
  }

  Future<Response> putGuardianAssignmentsGuardian_assignment(
    String guardian_assignment,
    dynamic data,
  ) async {
    return _dio.request(
      '$_baseUrl/api/guardian-assignments/${guardian_assignment}',
      options: Options(method: 'PUT'),
      data: data,
    );
  }

  Future<Response> deleteGuardianAssignmentsGuardian_assignment(
    String guardian_assignment,
    dynamic data,
  ) async {
    return _dio.request(
      '$_baseUrl/api/guardian-assignments/${guardian_assignment}',
      options: Options(method: 'DELETE'),
      data: data,
    );
  }

  Future<Response> getGuardianRecordBooks(
    Map<String, dynamic>? queryParams,
  ) async {
    return _dio.request(
      '$_baseUrl/api/guardian-record-books',
      options: Options(method: 'GET'),
      queryParameters: queryParams,
    );
  }

  Future<Response> postGuardianRecordBooks(dynamic data) async {
    return _dio.request(
      '$_baseUrl/api/guardian-record-books',
      options: Options(method: 'POST'),
      data: data,
    );
  }

  Future<Response> getGuardianRecordBooksGuardian_record_book(
    String guardian_record_book,
    Map<String, dynamic>? queryParams,
  ) async {
    return _dio.request(
      '$_baseUrl/api/guardian-record-books/${guardian_record_book}',
      options: Options(method: 'GET'),
      queryParameters: queryParams,
    );
  }

  Future<Response> putGuardianRecordBooksGuardian_record_book(
    String guardian_record_book,
    dynamic data,
  ) async {
    return _dio.request(
      '$_baseUrl/api/guardian-record-books/${guardian_record_book}',
      options: Options(method: 'PUT'),
      data: data,
    );
  }

  Future<Response> deleteGuardianRecordBooksGuardian_record_book(
    String guardian_record_book,
    dynamic data,
  ) async {
    return _dio.request(
      '$_baseUrl/api/guardian-record-books/${guardian_record_book}',
      options: Options(method: 'DELETE'),
      data: data,
    );
  }

  Future<Response> getGuardianRecordBooks2(
    Map<String, dynamic>? queryParams,
  ) async {
    return _dio.request(
      '$_baseUrl/api/guardian/record-books',
      options: Options(method: 'GET'),
      queryParameters: queryParams,
    );
  }

  Future<Response> getGuardianRecordBooksNotebooks(
    Map<String, dynamic>? queryParams,
  ) async {
    return _dio.request(
      '$_baseUrl/api/guardian/record-books/notebooks',
      options: Options(method: 'GET'),
      queryParameters: queryParams,
    );
  }

  Future<Response> getGuardianRecordBooksId(
    String id,
    Map<String, dynamic>? queryParams,
  ) async {
    return _dio.request(
      '$_baseUrl/api/guardian/record-books/${id}',
      options: Options(method: 'GET'),
      queryParameters: queryParams,
    );
  }

  Future<Response> getGuardians(Map<String, dynamic>? queryParams) async {
    return _dio.request(
      '$_baseUrl/api/guardians',
      options: Options(method: 'GET'),
      queryParameters: queryParams,
    );
  }

  Future<Response> postGuardians(dynamic data) async {
    return _dio.request(
      '$_baseUrl/api/guardians',
      options: Options(method: 'POST'),
      data: data,
    );
  }

  Future<Response> getGuardiansGuardian(
    String guardian,
    Map<String, dynamic>? queryParams,
  ) async {
    return _dio.request(
      '$_baseUrl/api/guardians/${guardian}',
      options: Options(method: 'GET'),
      queryParameters: queryParams,
    );
  }

  Future<Response> putGuardiansGuardian(String guardian, dynamic data) async {
    return _dio.request(
      '$_baseUrl/api/guardians/${guardian}',
      options: Options(method: 'PUT'),
      data: data,
    );
  }

  Future<Response> deleteGuardiansGuardian(
    String guardian,
    dynamic data,
  ) async {
    return _dio.request(
      '$_baseUrl/api/guardians/${guardian}',
      options: Options(method: 'DELETE'),
      data: data,
    );
  }

  Future<Response> getLicenseManagements(
    Map<String, dynamic>? queryParams,
  ) async {
    return _dio.request(
      '$_baseUrl/api/license-managements',
      options: Options(method: 'GET'),
      queryParameters: queryParams,
    );
  }

  Future<Response> postLicenseManagements(dynamic data) async {
    return _dio.request(
      '$_baseUrl/api/license-managements',
      options: Options(method: 'POST'),
      data: data,
    );
  }

  Future<Response> getLicenseManagementsLicense_management(
    String license_management,
    Map<String, dynamic>? queryParams,
  ) async {
    return _dio.request(
      '$_baseUrl/api/license-managements/${license_management}',
      options: Options(method: 'GET'),
      queryParameters: queryParams,
    );
  }

  Future<Response> putLicenseManagementsLicense_management(
    String license_management,
    dynamic data,
  ) async {
    return _dio.request(
      '$_baseUrl/api/license-managements/${license_management}',
      options: Options(method: 'PUT'),
      data: data,
    );
  }

  Future<Response> deleteLicenseManagementsLicense_management(
    String license_management,
    dynamic data,
  ) async {
    return _dio.request(
      '$_baseUrl/api/license-managements/${license_management}',
      options: Options(method: 'DELETE'),
      data: data,
    );
  }

  Future<Response> postLogin(dynamic data) async {
    return _dio.request(
      '$_baseUrl/api/login',
      options: Options(method: 'POST'),
      data: data,
    );
  }

  Future<Response> postLogout(dynamic data) async {
    return _dio.request(
      '$_baseUrl/api/logout',
      options: Options(method: 'POST'),
      data: data,
    );
  }

  Future<Response> getMyRecordBooksContractTypeId(
    String contractTypeId,
    Map<String, dynamic>? queryParams,
  ) async {
    return _dio.request(
      '$_baseUrl/api/my-record-books/${contractTypeId}',
      options: Options(method: 'GET'),
      queryParameters: queryParams,
    );
  }

  Future<Response> getNotifications(Map<String, dynamic>? queryParams) async {
    return _dio.request(
      '$_baseUrl/api/notifications',
      options: Options(method: 'GET'),
      queryParameters: queryParams,
    );
  }

  Future<Response> getProfile(Map<String, dynamic>? queryParams) async {
    return _dio.request(
      '$_baseUrl/api/profile',
      options: Options(method: 'GET'),
      queryParameters: queryParams,
    );
  }

  Future<Response> getRecordBookTemplates(
    Map<String, dynamic>? queryParams,
  ) async {
    return _dio.request(
      '$_baseUrl/api/record-book-templates',
      options: Options(method: 'GET'),
      queryParameters: queryParams,
    );
  }

  Future<Response> getRecordBooks(Map<String, dynamic>? queryParams) async {
    return _dio.request(
      '$_baseUrl/api/record-books',
      options: Options(method: 'GET'),
      queryParameters: queryParams,
    );
  }

  Future<Response> postRecordBooksUpdatePhysicalNotebook(dynamic data) async {
    return _dio.request(
      '$_baseUrl/api/record-books/update-physical-notebook',
      options: Options(method: 'POST'),
      data: data,
    );
  }

  Future<Response> getRecordBooksContractTypeIdNotebooks(
    String contractTypeId,
    Map<String, dynamic>? queryParams,
  ) async {
    return _dio.request(
      '$_baseUrl/api/record-books/${contractTypeId}/notebooks',
      options: Options(method: 'GET'),
      queryParameters: queryParams,
    );
  }

  Future<Response> getRecordBooksRecord_book(
    String record_book,
    Map<String, dynamic>? queryParams,
  ) async {
    return _dio.request(
      '$_baseUrl/api/record-books/${record_book}',
      options: Options(method: 'GET'),
      queryParameters: queryParams,
    );
  }

  Future<Response> getRegistryEntries(Map<String, dynamic>? queryParams) async {
    return _dio.request(
      '$_baseUrl/api/registry-entries',
      options: Options(method: 'GET'),
      queryParameters: queryParams,
    );
  }

  Future<Response> postRegistryEntries(dynamic data) async {
    return _dio.request(
      '$_baseUrl/api/registry-entries',
      options: Options(method: 'POST'),
      data: data,
    );
  }

  Future<Response> putRegistryEntriesIdRequestDocumentation(
    String id,
    dynamic data,
  ) async {
    return _dio.request(
      '$_baseUrl/api/registry-entries/${id}/request-documentation',
      options: Options(method: 'PUT'),
      data: data,
    );
  }

  Future<Response> getRegistryEntriesRegistry_entry(
    String registry_entry,
    Map<String, dynamic>? queryParams,
  ) async {
    return _dio.request(
      '$_baseUrl/api/registry-entries/${registry_entry}',
      options: Options(method: 'GET'),
      queryParameters: queryParams,
    );
  }

  Future<Response> putRegistryEntriesRegistry_entry(
    String registry_entry,
    dynamic data,
  ) async {
    return _dio.request(
      '$_baseUrl/api/registry-entries/${registry_entry}',
      options: Options(method: 'PUT'),
      data: data,
    );
  }

  Future<Response> deleteRegistryEntriesRegistry_entry(
    String registry_entry,
    dynamic data,
  ) async {
    return _dio.request(
      '$_baseUrl/api/registry-entries/${registry_entry}',
      options: Options(method: 'DELETE'),
      data: data,
    );
  }

  Future<Response> getUser(Map<String, dynamic>? queryParams) async {
    return _dio.request(
      '$_baseUrl/api/user',
      options: Options(method: 'GET'),
      queryParameters: queryParams,
    );
  }

  Future<Response> getV1MobileSync(Map<String, dynamic>? queryParams) async {
    return _dio.request(
      '$_baseUrl/api/v1/mobile/sync',
      options: Options(method: 'GET'),
      queryParameters: queryParams,
    );
  }

  Future<Response> postV1MobileSync(dynamic data) async {
    return _dio.request(
      '$_baseUrl/api/v1/mobile/sync',
      options: Options(method: 'POST'),
      data: data,
    );
  }
}

// Use GetIt instance to ensure singleton and correct configuration
final systemRepositoryProvider = Provider((ref) => getIt<SystemRepository>());
