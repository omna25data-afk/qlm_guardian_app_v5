import '../config/app_config.dart';

/// API Endpoints - aligned with Laravel backend routes/api.php
class ApiEndpoints {
  ApiEndpoints._();

  static String get baseUrl => AppConfig.apiBaseUrl;

  // Auth
  static String get login => '$baseUrl/login';
  static String get logout => '$baseUrl/logout';
  static String get user => '$baseUrl/user';
  static String get profile => '$baseUrl/profile';

  // Sync (Mobile API v1)
  static String get mobileSyncPull => '$baseUrl/v1/mobile/sync';
  static String get mobileSyncPush => '$baseUrl/v1/mobile/sync';

  // Registry Entries
  static String get registryEntries => '$baseUrl/registry-entries';
  static String registryEntry(int id) => '$baseUrl/registry-entries/$id';
  static String requestDocumentation(int id) =>
      '$baseUrl/registry-entries/$id/request-documentation';

  // Record Books
  static String get guardianRecordBooks => '$baseUrl/guardian/record-books';
  static String guardianRecordBook(int id) =>
      '$baseUrl/guardian/record-books/$id';
  static String get recordBookTypes => '$baseUrl/record-book-types';
  static String get recordBookTemplates => '$baseUrl/record-book-templates';
  static String recordBookNotebooks(int contractTypeId) =>
      '$baseUrl/record-books/$contractTypeId/notebooks';
  static String myRecordBook(int contractTypeId) =>
      '$baseUrl/my-record-books/$contractTypeId';

  // Contract Types (cached 24h on backend)
  static String get contractTypes => '$baseUrl/contract-types';
  static String contractSubtypes(int id) =>
      '$baseUrl/contract-types/$id/subtypes';
  static String formFields(int contractTypeId) =>
      '$baseUrl/form-fields/$contractTypeId';

  // Dashboard
  static String get dashboard => '$baseUrl/dashboard';
  static String get notifications => '$baseUrl/notifications';

  // Admin
  static String get adminDashboard => '$baseUrl/admin/dashboard';
  static String get adminGuardians => '$baseUrl/admin/guardians';
  static String get adminRegistryEntries => '$baseUrl/admin/registry-entries';
  static String get adminRecordBooks => '$baseUrl/admin/record-books';
  static String get adminLicenses => '$baseUrl/admin/licenses';
  static String get adminCards => '$baseUrl/admin/cards';
  static String get adminAreas => '$baseUrl/admin/areas';
  static String get adminAssignments => '$baseUrl/admin/assignments';
  // adminRenewals removed — /admin/renewals route does not exist
  static String get adminElectronicCardRenewals =>
      '$baseUrl/electronic-card-renewals';
  static String get licenseManagements => '$baseUrl/license-managements';

  // Reports
  static String get reportsExport => '$baseUrl/reports/export';
  static String get reportsYears => '$baseUrl/reports/years';
  static String get guardiansStatistics =>
      '$baseUrl/reports/guardian-statistics';
  static String get entriesStatistics => '$baseUrl/reports/entries-statistics';
  static String get contractTypesSummary =>
      '$baseUrl/reports/contract-types-summary';
}
