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

  // Admin: Guardian Details (CRUD + inspections)
  static String adminGuardianDetails(int id) => '$baseUrl/admin/guardians/$id';
  static String adminGuardianInspections(int id) =>
      '$baseUrl/admin/guardians/$id/inspections';
  static String adminRenewLicense(int id) =>
      '$baseUrl/admin/guardians/$id/renew-license';
  static String adminRenewCard(int id) =>
      '$baseUrl/admin/guardians/$id/renew-card';

  // Admin: Record Book Actions
  static String adminRecordBookUpdate(int id) =>
      '$baseUrl/admin/record-books/$id';
  static String adminRecordBookOpen(int id) =>
      '$baseUrl/admin/record-books/$id/open';
  static String adminRecordBookClose(int id) =>
      '$baseUrl/admin/record-books/$id/close';
  static String adminRecordBookProcedures(int id) =>
      '$baseUrl/admin/record-books/$id/procedures';

  // Admin: Registry Entry Actions
  static String get adminPendingEntries =>
      '$baseUrl/admin/registry-entries/pending';
  static String adminDocumentEntry(int id) =>
      '$baseUrl/admin/registry-entries/$id/document';
  static String calculateFees(int id) =>
      '$baseUrl/registry-entries/$id/calculate-fees';

  // Admin: Basic Data Management
  static String get adminFeeCustomizations =>
      '$baseUrl/admin/fee-customizations';
  static String get adminRecordBookTemplates =>
      '$baseUrl/admin/record-book-templates';
  static String get adminOtherWriters => '$baseUrl/admin/other-writers';
  static String get adminWriters => '$baseUrl/admin/writers';
  static String get adminContractTypes => '$baseUrl/admin/contract-types';
  static String get adminConstraintTypes => '$baseUrl/admin/constraint-types';
  static String get adminRecordBookTypes => '$baseUrl/admin/record-book-types';

  // Admin: Inspection
  static String get adminInspectionRecordBooks =>
      '$baseUrl/admin/inspection/record-books';
  static String adminInspectionRecordBookDetail(int id) =>
      '$baseUrl/admin/inspection/record-books/$id';
  static String get adminInspectionEntryNotes =>
      '$baseUrl/admin/inspection/entry-notes';

  // Reports
  static String get reportsExport => '$baseUrl/reports/export';
  static String get reportsYears => '$baseUrl/reports/years';
  static String get guardiansStatistics =>
      '$baseUrl/reports/guardian-statistics';
  static String get entriesStatistics => '$baseUrl/reports/entries-statistics';
  static String get contractTypesSummary =>
      '$baseUrl/reports/contract-types-summary';
  static String get feesReport => '$baseUrl/reports/fees';
  static String guardianDetailReport(int guardianId) =>
      '$baseUrl/reports/guardian-details/$guardianId';
  static String get guardianSummaryReport =>
      '$baseUrl/guardian/reports/summary';
}
