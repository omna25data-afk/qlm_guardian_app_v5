import 'package:flutter/material.dart';

/// Record Book model — aligned with generated system model.
/// This model acts as the primary data structure for the UI,
/// combining database fields with computed properties for the frontend.
class RecordBook {
  final int id;
  final int? recordBookTypeId;
  final int? recordBookTemplateId;
  final String name;
  final String category;
  final int? contractTypeId;
  final int? legitimateGuardianId;
  final int bookNumber;
  final String? ministryRecordNumber;
  final String? formNumber;
  final int hijriYear;
  final int totalPages;
  final int constraintsPerPage;
  final int startConstraintNumber;
  final int endConstraintNumber;
  final int? assignedTo;
  final int createdBy;
  final String status;
  final int? issuedProcedureId;
  final int? currentOpeningProcedureId;
  final String? openingProcedureDate;
  final String? openingProcedureDateHijri;
  final String? closingProcedureDate;
  final String? closureType;
  final String? closureReason;
  final String? closingProcedureDateHijri;
  final String? notes;
  final bool isActive;
  final String? createdAt;
  final String? updatedAt;
  final String? deletedAt;
  final String? recordGroup;
  final String? recordCategory;

  // Computed & UI-specific fields (from API Resource)
  final String statusLabel;
  final String contractType;
  final int usedPages;
  final int usagePercentage;
  final String? categoryLabel;
  final String? categoryColor;
  final String? categoryIcon;
  final int totalEntries;
  final int completedEntries;
  final int draftEntries;
  final int pendingEntries;
  final int registeredEntries;
  final int rejectedEntries;
  final int notebooksCount;
  final String? templateName;
  final String writerName;
  final String writerTypeLabel;

  RecordBook({
    required this.id,
    this.recordBookTypeId,
    this.recordBookTemplateId,
    required this.name,
    required this.category,
    this.contractTypeId,
    this.legitimateGuardianId,
    required this.bookNumber,
    this.ministryRecordNumber,
    this.formNumber,
    required this.hijriYear,
    required this.totalPages,
    required this.constraintsPerPage,
    required this.startConstraintNumber,
    required this.endConstraintNumber,
    this.assignedTo,
    required this.createdBy,
    required this.status,
    this.issuedProcedureId,
    this.currentOpeningProcedureId,
    this.openingProcedureDate,
    this.openingProcedureDateHijri,
    this.closingProcedureDate,
    this.closureType,
    this.closureReason,
    this.closingProcedureDateHijri,
    this.notes,
    required this.isActive,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
    this.recordGroup,
    this.recordCategory,
    // Helpers
    this.statusLabel = '',
    this.contractType = '',
    this.usedPages = 0,
    this.usagePercentage = 0,
    this.categoryLabel,
    this.categoryColor,
    this.categoryIcon,
    this.totalEntries = 0,
    this.completedEntries = 0,
    this.draftEntries = 0,
    this.pendingEntries = 0,
    this.registeredEntries = 0,
    this.rejectedEntries = 0,

    this.notebooksCount = 1,
    this.templateName,
    this.writerName = '',
    this.writerTypeLabel = '',
  });

  factory RecordBook.fromJson(Map<String, dynamic> json) {
    // Helper to extract writer name safely
    String extractWriterName() {
      if (json['writer_name'] != null &&
          json['writer_name'].toString().isNotEmpty) {
        return json['writer_name'];
      }
      if (json['assigned_name'] != null &&
          json['assigned_name'].toString().isNotEmpty) {
        return json['assigned_name'];
      }

      final lg = json['legitimate_guardian'] ?? json['legitimateGuardian'];
      if (lg is Map) {
        if (lg['full_name'] != null) {
          return lg['full_name'];
        }
        if (lg['name'] != null) {
          return lg['name'];
        }
        if (lg['first_name'] != null) {
          return '${lg['first_name']} ${lg['family_name'] ?? ''}'.trim();
        }
      }

      return '';
    }

    return RecordBook(
      id: json['id'] is int
          ? json['id']
          : int.tryParse(json['id']?.toString() ?? '') ?? 0,
      recordBookTypeId: json['record_book_type_id'],
      recordBookTemplateId: json['record_book_template_id'],
      name: json['name'] ?? '',
      category: json['category'] ?? 'guardian_recording',
      contractTypeId: json['contract_type_id'],
      legitimateGuardianId: json['legitimate_guardian_id'],
      bookNumber: json['book_number'] ?? 0,
      ministryRecordNumber: json['ministry_record_number'],
      formNumber: json['form_number'],
      hijriYear: json['hijri_year'] ?? 0,
      totalPages: json['total_pages'] ?? 0,
      constraintsPerPage: json['constraints_per_page'] ?? 0,
      startConstraintNumber: json['start_constraint_number'] ?? 0,
      endConstraintNumber: json['end_constraint_number'] ?? 0,
      assignedTo: json['assigned_to'],
      createdBy: json['created_by'] ?? 0,
      status: json['status'] ?? '',
      issuedProcedureId: json['issued_procedure_id'],
      currentOpeningProcedureId: json['current_opening_procedure_id'],
      openingProcedureDate: json['opening_procedure_date'],
      openingProcedureDateHijri: json['opening_procedure_date_hijri'],
      closingProcedureDate: json['closing_procedure_date'],
      closureType: json['closure_type'],
      closureReason: json['closure_reason'],
      closingProcedureDateHijri: json['closing_procedure_date_hijri'],
      notes: json['notes'],
      isActive:
          json['is_active'] == true ||
          json['is_active'] == 1 ||
          json['is_active'] == '1',
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      deletedAt: json['deleted_at'],
      recordGroup: json['record_group'],
      recordCategory: json['record_category'],
      // Helpers
      statusLabel: json['status_label'] ?? '',
      contractType: json['contract_type_name'] ?? json['type_name'] ?? '',
      usedPages: json['used_pages'] ?? json['constraints_count'] ?? 0,
      usagePercentage: json['used_percentage'] ?? 0,
      categoryLabel: json['category_label'],
      categoryColor: json['category_color'],
      categoryIcon: json['category_icon'],
      totalEntries: json['total_entries_count'] ?? json['entries_count'] ?? 0,
      completedEntries: json['completed_entries_count'] ?? 0,
      draftEntries: json['draft_entries_count'] ?? 0,
      pendingEntries: json['pending_entries_count'] ?? 0,
      registeredEntries: json['registered_entries_count'] ?? 0,
      rejectedEntries: json['rejected_entries_count'] ?? 0,

      notebooksCount: json['notebooks_count'] ?? 1,
      templateName: json['template_name'],
      writerName: extractWriterName(),
      writerTypeLabel: json['writer_type_label'] ?? '',
    );
  }

  Color get statusColor {
    if (statusLabel.contains('نشط') || statusLabel.contains('Active')) {
      return Colors.green;
    }
    if (statusLabel.contains('مكتمل') || statusLabel.contains('Full')) {
      return Colors.blue;
    }
    if (statusLabel.contains('ملغى') || statusLabel.contains('Cancelled')) {
      return Colors.red;
    }
    return Colors.grey;
  }

  // Backward compatibility getters
  String get title => name;
  int get number => bookNumber;
  int get entriesCount => totalEntries;
  int get issuanceYear => hijriYear;
  List<String> get years => [hijriYear.toString()];
  int get currentPageNumber =>
      (usedPages < totalPages) ? usedPages + 1 : totalPages;
}
