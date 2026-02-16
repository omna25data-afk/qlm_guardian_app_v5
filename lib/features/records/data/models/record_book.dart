import 'package:flutter/material.dart';

/// Record Book model — migrated from v4 with full field set.
/// Uses manual fromJson to handle complex field mappings and defaults.
class RecordBook {
  final int id;
  final int number;
  final String title;
  final int hijriYear;
  final String statusLabel;
  final String contractType;
  final int totalPages;
  final int usedPages;
  final int usagePercentage;
  final String category;
  final String? categoryLabel;
  final bool isActive;
  final int totalEntries;
  final int completedEntries;
  final int draftEntries;
  final int notebooksCount;
  final int? contractTypeId;
  final int bookNumber;
  final int entriesCount;
  final String? ministryRecordNumber;
  final int? templateId;
  final String? templateName;
  final int? issuanceYear;
  final List<int> years;
  final int currentPageNumber;
  final String writerName;
  final String writerTypeLabel;

  RecordBook({
    this.id = 0,
    this.number = 0,
    this.title = '',
    this.hijriYear = 0,
    this.statusLabel = '',
    this.contractType = '',
    this.totalPages = 0,
    this.usedPages = 0,
    this.usagePercentage = 0,
    this.category = 'guardian_recording', // Default to avoid nulls
    this.categoryLabel,
    this.isActive = false,
    this.totalEntries = 0,
    this.completedEntries = 0,
    this.draftEntries = 0,
    this.notebooksCount = 0,
    this.contractTypeId,
    int? bookNumber,
    int? entriesCount,
    this.ministryRecordNumber,
    this.templateId,
    this.templateName,
    this.issuanceYear,
    List<int>? years,
    this.currentPageNumber = 0,
    this.writerName = '',
    this.writerTypeLabel = '',
  }) : bookNumber = bookNumber ?? number,
       entriesCount = entriesCount ?? totalEntries,
       years = years ?? [];

  factory RecordBook.fromJson(Map<String, dynamic> json) {
    // Helper to extract name safely
    String extractName() {
      // 1. Direct assignments from API
      if (json['writer_name'] != null &&
          json['writer_name'].toString().isNotEmpty) {
        return json['writer_name'];
      }
      if (json['assigned_name'] != null &&
          json['assigned_name'].toString().isNotEmpty) {
        return json['assigned_name'];
      }

      // 2. Legitimate Guardian (Amin) - From Backend Resource
      // The backend returns 'full_name', 'first_name', 'family_name'. NOT 'name'.
      if (json['legitimate_guardian'] is Map) {
        final g = json['legitimate_guardian'];
        if (g['full_name'] != null) return g['full_name'];
        if (g['name'] != null) return g['name']; // Fallback
        if (g['first_name'] != null) {
          return '${g['first_name']} ${g['family_name'] ?? ''}'.trim();
        }
      }
      // CamelCase check
      if (json['legitimateGuardian'] is Map) {
        final g = json['legitimateGuardian'];
        if (g['full_name'] != null) return g['full_name'];
        if (g['name'] != null) return g['name'];
        if (g['first_name'] != null) {
          return '${g['first_name']} ${g['family_name'] ?? ''}'.trim();
        }
      }

      // 3. User / Writer / Assigned (Generic Fallbacks)
      if (json['writer'] is Map && json['writer']['name'] != null) {
        return json['writer']['name'];
      }
      if (json['assigned'] is Map && json['assigned']['name'] != null) {
        return json['assigned']['name'];
      }
      if (json['user'] is Map && json['user']['name'] != null) {
        return json['user']['name'];
      }

      return '';
    }

    return RecordBook(
      id: json['id'] ?? 0,
      number: json['book_number'] ?? 0,
      title: json['name'] ?? '',
      hijriYear: json['hijri_year'] ?? 0,
      statusLabel: json['status_label'] ?? '',
      contractType: json['contract_type_name'] ?? json['type_name'] ?? '',
      totalPages: json['total_pages'] ?? 0,
      usedPages: json['constraints_count'] ?? 0,
      usagePercentage: json['used_percentage'] ?? 0,
      category: json['category'] ?? 'guardian_recording',
      categoryLabel: json['category_label'],
      isActive: json['is_active'] == true || json['is_active'] == 1,
      totalEntries:
          json['total_entries_count'] ?? json['constraints_count'] ?? 0,
      completedEntries: json['completed_entries_count'] ?? 0,
      draftEntries: json['draft_entries_count'] ?? 0,
      notebooksCount: json['notebooks_count'] ?? 1,
      contractTypeId: json['contract_type_id'],
      bookNumber: json['book_number'] as int?,
      entriesCount: json['entries_count'] as int?,
      ministryRecordNumber: json['ministry_record_number'] as String?,
      templateId: json['template_id'] as int?,
      templateName: json['template_name'] as String?,
      issuanceYear: json['issuance_year'] as int?,
      years: (json['years'] as List<dynamic>?)?.map((e) => e as int).toList(),
      currentPageNumber: json['current_page_number'] ?? 0,
      writerName: extractName(),
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
}
