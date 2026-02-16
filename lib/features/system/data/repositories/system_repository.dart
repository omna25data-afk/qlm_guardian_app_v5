import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SystemRepository {
  final Dio _dio;
  final String _baseUrl;

  SystemRepository(
    this._dio, {
    String baseUrl = 'https://darkturquoise-lark-306795.hostingersite.com/api',
  }) : _baseUrl = baseUrl;

  Future<Response> getAdminAreas(Map<String, dynamic>? queryParams) async {
    return _dio.request(
      '$_baseUrl/admin/areas',
      options: Options(method: 'GET'),
      queryParameters: queryParams,
    );
  }

  Future<Response> postAdminAreas(dynamic data) async {
    return _dio.request(
      '$_baseUrl/admin/areas',
      options: Options(method: 'POST'),
      data: data,
    );
  }

  Future<Response> getAdminAssignments(
    Map<String, dynamic>? queryParams,
  ) async {
    return _dio.request(
      '$_baseUrl/admin/assignments',
      options: Options(method: 'GET'),
      queryParameters: queryParams,
    );
  }

  Future<Response> postAdminAssignments(dynamic data) async {
    return _dio.request(
      '$_baseUrl/admin/assignments',
      options: Options(method: 'POST'),
      data: data,
    );
  }

  Future<Response> getAdminCards(Map<String, dynamic>? queryParams) async {
    return _dio.request(
      '$_baseUrl/admin/cards',
      options: Options(method: 'GET'),
      queryParameters: queryParams,
    );
  }

  Future<Response> getAdminDashboard(Map<String, dynamic>? queryParams) async {
    return _dio.request(
      '$_baseUrl/admin/dashboard',
      options: Options(method: 'GET'),
      queryParameters: queryParams,
    );
  }

  Future<Response> getAdminGuardians(Map<String, dynamic>? queryParams) async {
    return _dio.request(
      '$_baseUrl/admin/guardians',
      options: Options(method: 'GET'),
      queryParameters: queryParams,
    );
  }

  Future<Response> postAdminGuardiansIdRenewCard(
    String id,
    dynamic data,
  ) async {
    return _dio.request(
      '$_baseUrl/admin/guardians/$id/renew-card',
      options: Options(method: 'POST'),
      data: data,
    );
  }

  Future<Response> postAdminGuardiansIdRenewLicense(
    String id,
    dynamic data,
  ) async {
    return _dio.request(
      '$_baseUrl/admin/guardians/$id/renew-license',
      options: Options(method: 'POST'),
      data: data,
    );
  }

  Future<Response> getAdminLicenses(Map<String, dynamic>? queryParams) async {
    return _dio.request(
      '$_baseUrl/admin/licenses',
      options: Options(method: 'GET'),
      queryParameters: queryParams,
    );
  }

  Future<Response> getAdminRecordBooks(
    Map<String, dynamic>? queryParams,
  ) async {
    return _dio.request(
      '$_baseUrl/admin/record-books',
      options: Options(method: 'GET'),
      queryParameters: queryParams,
    );
  }

  Future<Response> getContractTypes(Map<String, dynamic>? queryParams) async {
    return _dio.request(
      '$_baseUrl/contract-types',
      options: Options(method: 'GET'),
      queryParameters: queryParams,
    );
  }

  Future<Response> getContractTypesIdSubtypes(
    String id,
    Map<String, dynamic>? queryParams,
  ) async {
    return _dio.request(
      '$_baseUrl/contract-types/$id/subtypes',
      options: Options(method: 'GET'),
      queryParameters: queryParams,
    );
  }

  Future<Response> getDashboard(Map<String, dynamic>? queryParams) async {
    return _dio.request(
      '$_baseUrl/dashboard',
      options: Options(method: 'GET'),
      queryParameters: queryParams,
    );
  }

  Future<Response> getElectronicCardRenewals(
    Map<String, dynamic>? queryParams,
  ) async {
    return _dio.request(
      '$_baseUrl/electronic-card-renewals',
      options: Options(method: 'GET'),
      queryParameters: queryParams,
    );
  }

  Future<Response> postElectronicCardRenewals(dynamic data) async {
    return _dio.request(
      '$_baseUrl/electronic-card-renewals',
      options: Options(method: 'POST'),
      data: data,
    );
  }

  Future<Response> getElectronicCardRenewalsElectronic_card_renewal(
    String electronic_card_renewal,
    Map<String, dynamic>? queryParams,
  ) async {
    return _dio.request(
      '$_baseUrl/electronic-card-renewals/$electronic_card_renewal',
      options: Options(method: 'GET'),
      queryParameters: queryParams,
    );
  }

  Future<Response> putElectronicCardRenewalsElectronic_card_renewal(
    String electronic_card_renewal,
    dynamic data,
  ) async {
    return _dio.request(
      '$_baseUrl/electronic-card-renewals/$electronic_card_renewal',
      options: Options(method: 'PUT'),
      data: data,
    );
  }

  Future<Response> deleteElectronicCardRenewalsElectronic_card_renewal(
    String electronic_card_renewal,
    dynamic data,
  ) async {
    return _dio.request(
      '$_baseUrl/electronic-card-renewals/$electronic_card_renewal',
      options: Options(method: 'DELETE'),
      data: data,
    );
  }

  Future<Response> getFormFieldsContractTypeId(
    String contractTypeId,
    Map<String, dynamic>? queryParams,
  ) async {
    return _dio.request(
      '$_baseUrl/form-fields/${contractTypeId}',
      options: Options(method: 'GET'),
      queryParameters: queryParams,
    );
  }

  Future<Response> getGeographicAreas(Map<String, dynamic>? queryParams) async {
    return _dio.request(
      '$_baseUrl/geographic-areas',
      options: Options(method: 'GET'),
      queryParameters: queryParams,
    );
  }

  Future<Response> postGeographicAreas(dynamic data) async {
    return _dio.request(
      '$_baseUrl/geographic-areas',
      options: Options(method: 'POST'),
      data: data,
    );
  }

  Future<Response> getGeographicAreasGeographic_area(
    String geographic_area,
    Map<String, dynamic>? queryParams,
  ) async {
    return _dio.request(
      '$_baseUrl/geographic-areas/${geographic_area}',
      options: Options(method: 'GET'),
      queryParameters: queryParams,
    );
  }

  Future<Response> putGeographicAreasGeographic_area(
    String geographic_area,
    dynamic data,
  ) async {
    return _dio.request(
      '$_baseUrl/geographic-areas/${geographic_area}',
      options: Options(method: 'PUT'),
      data: data,
    );
  }

  Future<Response> deleteGeographicAreasGeographic_area(
    String geographic_area,
    dynamic data,
  ) async {
    return _dio.request(
      '$_baseUrl/geographic-areas/${geographic_area}',
      options: Options(method: 'DELETE'),
      data: data,
    );
  }

  Future<Response> getGuardianAssignments(
    Map<String, dynamic>? queryParams,
  ) async {
    return _dio.request(
      '$_baseUrl/guardian-assignments',
      options: Options(method: 'GET'),
      queryParameters: queryParams,
    );
  }

  Future<Response> postGuardianAssignments(dynamic data) async {
    return _dio.request(
      '$_baseUrl/guardian-assignments',
      options: Options(method: 'POST'),
      data: data,
    );
  }

  Future<Response> getGuardianAssignmentsGuardian_assignment(
    String guardian_assignment,
    Map<String, dynamic>? queryParams,
  ) async {
    return _dio.request(
      '$_baseUrl/guardian-assignments/${guardian_assignment}',
      options: Options(method: 'GET'),
      queryParameters: queryParams,
    );
  }

  Future<Response> putGuardianAssignmentsGuardian_assignment(
    String guardian_assignment,
    dynamic data,
  ) async {
    return _dio.request(
      '$_baseUrl/guardian-assignments/${guardian_assignment}',
      options: Options(method: 'PUT'),
      data: data,
    );
  }

  Future<Response> deleteGuardianAssignmentsGuardian_assignment(
    String guardian_assignment,
    dynamic data,
  ) async {
    return _dio.request(
      '$_baseUrl/guardian-assignments/${guardian_assignment}',
      options: Options(method: 'DELETE'),
      data: data,
    );
  }

  Future<Response> getGuardianRecordBooksLegacy(
    Map<String, dynamic>? queryParams,
  ) async {
    return _dio.request(
      '$_baseUrl/guardian-record-books',
      options: Options(method: 'GET'),
      queryParameters: queryParams,
    );
  }

  Future<Response> postGuardianRecordBooks(dynamic data) async {
    return _dio.request(
      '$_baseUrl/guardian-record-books',
      options: Options(method: 'POST'),
      data: data,
    );
  }

  Future<Response> getGuardianRecordBooksGuardian_record_book(
    String guardian_record_book,
    Map<String, dynamic>? queryParams,
  ) async {
    return _dio.request(
      '$_baseUrl/guardian-record-books/$guardian_record_book',
      options: Options(method: 'GET'),
      queryParameters: queryParams,
    );
  }

  Future<Response> putGuardianRecordBooksGuardian_record_book(
    String guardian_record_book,
    dynamic data,
  ) async {
    return _dio.request(
      '$_baseUrl/guardian-record-books/${guardian_record_book}',
      options: Options(method: 'PUT'),
      data: data,
    );
  }

  Future<Response> deleteGuardianRecordBooksGuardian_record_book(
    String guardian_record_book,
    dynamic data,
  ) async {
    return _dio.request(
      '$_baseUrl/guardian-record-books/${guardian_record_book}',
      options: Options(method: 'DELETE'),
      data: data,
    );
  }

  Future<Response> getGuardianRecordBooks(
    Map<String, dynamic>? queryParams,
  ) async {
    return _dio.request(
      '$_baseUrl/guardian/record-books',
      options: Options(method: 'GET'),
      queryParameters: queryParams,
    );
  }

  Future<Response> getGuardianRecordBooksNotebooks(
    Map<String, dynamic>? queryParams,
  ) async {
    return _dio.request(
      '$_baseUrl/guardian/record-books/notebooks',
      options: Options(method: 'GET'),
      queryParameters: queryParams,
    );
  }

  Future<Response> getGuardianRecordBooksId(
    String id,
    Map<String, dynamic>? queryParams,
  ) async {
    return _dio.request(
      '$_baseUrl/guardian/record-books/${id}',
      options: Options(method: 'GET'),
      queryParameters: queryParams,
    );
  }

  Future<Response> getGuardians(Map<String, dynamic>? queryParams) async {
    return _dio.request(
      '$_baseUrl/guardians',
      options: Options(method: 'GET'),
      queryParameters: queryParams,
    );
  }

  Future<Response> postGuardians(dynamic data) async {
    return _dio.request(
      '$_baseUrl/guardians',
      options: Options(method: 'POST'),
      data: data,
    );
  }

  Future<Response> getGuardiansGuardian(
    String guardian,
    Map<String, dynamic>? queryParams,
  ) async {
    return _dio.request(
      '$_baseUrl/guardians/${guardian}',
      options: Options(method: 'GET'),
      queryParameters: queryParams,
    );
  }

  Future<Response> putGuardiansGuardian(String guardian, dynamic data) async {
    return _dio.request(
      '$_baseUrl/guardians/${guardian}',
      options: Options(method: 'PUT'),
      data: data,
    );
  }

  Future<Response> deleteGuardiansGuardian(
    String guardian,
    dynamic data,
  ) async {
    return _dio.request(
      '$_baseUrl/guardians/${guardian}',
      options: Options(method: 'DELETE'),
      data: data,
    );
  }

  Future<Response> getLicenseManagements(
    Map<String, dynamic>? queryParams,
  ) async {
    return _dio.request(
      '$_baseUrl/license-managements',
      options: Options(method: 'GET'),
      queryParameters: queryParams,
    );
  }

  Future<Response> postLicenseManagements(dynamic data) async {
    return _dio.request(
      '$_baseUrl/license-managements',
      options: Options(method: 'POST'),
      data: data,
    );
  }

  Future<Response> getLicenseManagementsLicense_management(
    String license_management,
    Map<String, dynamic>? queryParams,
  ) async {
    return _dio.request(
      '$_baseUrl/license-managements/${license_management}',
      options: Options(method: 'GET'),
      queryParameters: queryParams,
    );
  }

  Future<Response> putLicenseManagementsLicense_management(
    String license_management,
    dynamic data,
  ) async {
    return _dio.request(
      '$_baseUrl/license-managements/${license_management}',
      options: Options(method: 'PUT'),
      data: data,
    );
  }

  Future<Response> deleteLicenseManagementsLicense_management(
    String license_management,
    dynamic data,
  ) async {
    return _dio.request(
      '$_baseUrl/license-managements/${license_management}',
      options: Options(method: 'DELETE'),
      data: data,
    );
  }

  Future<Response> postLogin(dynamic data) async {
    return _dio.request(
      '$_baseUrl/login',
      options: Options(method: 'POST'),
      data: data,
    );
  }

  Future<Response> postLogout(dynamic data) async {
    return _dio.request(
      '$_baseUrl/logout',
      options: Options(method: 'POST'),
      data: data,
    );
  }

  Future<Response> getMyRecordBooksContractTypeId(
    String contractTypeId,
    Map<String, dynamic>? queryParams,
  ) async {
    return _dio.request(
      '$_baseUrl/my-record-books/${contractTypeId}',
      options: Options(method: 'GET'),
      queryParameters: queryParams,
    );
  }

  Future<Response> getNotifications(Map<String, dynamic>? queryParams) async {
    return _dio.request(
      '$_baseUrl/notifications',
      options: Options(method: 'GET'),
      queryParameters: queryParams,
    );
  }

  Future<Response> getProfile(Map<String, dynamic>? queryParams) async {
    return _dio.request(
      '$_baseUrl/profile',
      options: Options(method: 'GET'),
      queryParameters: queryParams,
    );
  }

  Future<Response> getRecordBookTemplates(
    Map<String, dynamic>? queryParams,
  ) async {
    return _dio.request(
      '$_baseUrl/record-book-templates',
      options: Options(method: 'GET'),
      queryParameters: queryParams,
    );
  }

  Future<Response> getRecordBooks(Map<String, dynamic>? queryParams) async {
    return _dio.request(
      '$_baseUrl/record-books',
      options: Options(method: 'GET'),
      queryParameters: queryParams,
    );
  }

  Future<Response> postRecordBooksUpdatePhysicalNotebook(dynamic data) async {
    return _dio.request(
      '$_baseUrl/record-books/update-physical-notebook',
      options: Options(method: 'POST'),
      data: data,
    );
  }

  Future<Response> getRecordBooksContractTypeIdNotebooks(
    String contractTypeId,
    Map<String, dynamic>? queryParams,
  ) async {
    return _dio.request(
      '$_baseUrl/record-books/${contractTypeId}/notebooks',
      options: Options(method: 'GET'),
      queryParameters: queryParams,
    );
  }

  Future<Response> getRecordBooksRecord_book(
    String record_book,
    Map<String, dynamic>? queryParams,
  ) async {
    return _dio.request(
      '$_baseUrl/record-books/${record_book}',
      options: Options(method: 'GET'),
      queryParameters: queryParams,
    );
  }

  Future<Response> getRegistryEntries(Map<String, dynamic>? queryParams) async {
    return _dio.request(
      '$_baseUrl/registry-entries',
      options: Options(method: 'GET'),
      queryParameters: queryParams,
    );
  }

  Future<Response> postRegistryEntries(dynamic data) async {
    return _dio.request(
      '$_baseUrl/registry-entries',
      options: Options(method: 'POST'),
      data: data,
    );
  }

  Future<Response> putRegistryEntriesIdRequestDocumentation(
    String id,
    dynamic data,
  ) async {
    return _dio.request(
      '$_baseUrl/registry-entries/${id}/request-documentation',
      options: Options(method: 'PUT'),
      data: data,
    );
  }

  Future<Response> getRegistryEntriesRegistry_entry(
    String registry_entry,
    Map<String, dynamic>? queryParams,
  ) async {
    return _dio.request(
      '$_baseUrl/registry-entries/${registry_entry}',
      options: Options(method: 'GET'),
      queryParameters: queryParams,
    );
  }

  Future<Response> putRegistryEntriesRegistry_entry(
    String registry_entry,
    dynamic data,
  ) async {
    return _dio.request(
      '$_baseUrl/registry-entries/${registry_entry}',
      options: Options(method: 'PUT'),
      data: data,
    );
  }

  Future<Response> deleteRegistryEntriesRegistry_entry(
    String registry_entry,
    dynamic data,
  ) async {
    return _dio.request(
      '$_baseUrl/registry-entries/${registry_entry}',
      options: Options(method: 'DELETE'),
      data: data,
    );
  }

  Future<Response> getUser(Map<String, dynamic>? queryParams) async {
    return _dio.request(
      '$_baseUrl/user',
      options: Options(method: 'GET'),
      queryParameters: queryParams,
    );
  }

  Future<Response> getV1MobileSync(Map<String, dynamic>? queryParams) async {
    return _dio.request(
      '$_baseUrl/v1/mobile/sync',
      options: Options(method: 'GET'),
      queryParameters: queryParams,
    );
  }

  Future<Response> postV1MobileSync(dynamic data) async {
    return _dio.request(
      '$_baseUrl/v1/mobile/sync',
      options: Options(method: 'POST'),
      data: data,
    );
  }
}

final systemRepositoryProvider = Provider((ref) => SystemRepository(Dio()));
