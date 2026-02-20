class ConstraintInspectionNote {
  final int id;
  final int recordBookInspectionId;
  final int constraintId;
  final String? notes;
  final String? createdAt;
  final String? updatedAt;
  final int missingSellerOwnershipDocument;
  final int missingAnnotationOrCancellation;
  final int missingInheritanceRuling;
  final int missingPowerOfAttorney;
  final int missingLeaseDocument;
  final int missingWaqfDocument;
  final int missingStatePropertyPermission;
  final int missingMinorsPropertyPermission;
  final int unrecordedOwnershipRealEstateRegistry;
  final int unrecordedOwnershipDocumentationPen;
  final int jurisdictionViolation;
  final bool hasBlanks;
  final bool hasScratchesOrInsertions;
  final String? deletedAt;

  ConstraintInspectionNote({
    required this.id,
    required this.recordBookInspectionId,
    required this.constraintId,
    this.notes,
    this.createdAt,
    this.updatedAt,
    required this.missingSellerOwnershipDocument,
    required this.missingAnnotationOrCancellation,
    required this.missingInheritanceRuling,
    required this.missingPowerOfAttorney,
    required this.missingLeaseDocument,
    required this.missingWaqfDocument,
    required this.missingStatePropertyPermission,
    required this.missingMinorsPropertyPermission,
    required this.unrecordedOwnershipRealEstateRegistry,
    required this.unrecordedOwnershipDocumentationPen,
    required this.jurisdictionViolation,
    required this.hasBlanks,
    required this.hasScratchesOrInsertions,
    this.deletedAt,
  });

  factory ConstraintInspectionNote.fromJson(Map<String, dynamic> json) {
    return ConstraintInspectionNote(
      id: json['id'] != null
          ? (json['id'] is int
                ? json['id']
                : int.tryParse(json['id'].toString()) ?? 0)
          : 0,
      recordBookInspectionId: json['record_book_inspection_id'] != null
          ? (json['record_book_inspection_id'] is int
                ? json['record_book_inspection_id']
                : int.tryParse(json['record_book_inspection_id'].toString()) ??
                      0)
          : 0,
      constraintId: json['constraint_id'] != null
          ? (json['constraint_id'] is int
                ? json['constraint_id']
                : int.tryParse(json['constraint_id'].toString()) ?? 0)
          : 0,
      notes: json['notes'] ?? null,
      createdAt: json['created_at'] ?? null,
      updatedAt: json['updated_at'] ?? null,
      missingSellerOwnershipDocument:
          json['missing_seller_ownership_document'] != null
          ? (json['missing_seller_ownership_document'] is int
                ? json['missing_seller_ownership_document']
                : int.tryParse(
                        json['missing_seller_ownership_document'].toString(),
                      ) ??
                      0)
          : 0,
      missingAnnotationOrCancellation:
          json['missing_annotation_or_cancellation'] != null
          ? (json['missing_annotation_or_cancellation'] is int
                ? json['missing_annotation_or_cancellation']
                : int.tryParse(
                        json['missing_annotation_or_cancellation'].toString(),
                      ) ??
                      0)
          : 0,
      missingInheritanceRuling: json['missing_inheritance_ruling'] != null
          ? (json['missing_inheritance_ruling'] is int
                ? json['missing_inheritance_ruling']
                : int.tryParse(json['missing_inheritance_ruling'].toString()) ??
                      0)
          : 0,
      missingPowerOfAttorney: json['missing_power_of_attorney'] != null
          ? (json['missing_power_of_attorney'] is int
                ? json['missing_power_of_attorney']
                : int.tryParse(json['missing_power_of_attorney'].toString()) ??
                      0)
          : 0,
      missingLeaseDocument: json['missing_lease_document'] != null
          ? (json['missing_lease_document'] is int
                ? json['missing_lease_document']
                : int.tryParse(json['missing_lease_document'].toString()) ?? 0)
          : 0,
      missingWaqfDocument: json['missing_waqf_document'] != null
          ? (json['missing_waqf_document'] is int
                ? json['missing_waqf_document']
                : int.tryParse(json['missing_waqf_document'].toString()) ?? 0)
          : 0,
      missingStatePropertyPermission:
          json['missing_state_property_permission'] != null
          ? (json['missing_state_property_permission'] is int
                ? json['missing_state_property_permission']
                : int.tryParse(
                        json['missing_state_property_permission'].toString(),
                      ) ??
                      0)
          : 0,
      missingMinorsPropertyPermission:
          json['missing_minors_property_permission'] != null
          ? (json['missing_minors_property_permission'] is int
                ? json['missing_minors_property_permission']
                : int.tryParse(
                        json['missing_minors_property_permission'].toString(),
                      ) ??
                      0)
          : 0,
      unrecordedOwnershipRealEstateRegistry:
          json['unrecorded_ownership_real_estate_registry'] != null
          ? (json['unrecorded_ownership_real_estate_registry'] is int
                ? json['unrecorded_ownership_real_estate_registry']
                : int.tryParse(
                        json['unrecorded_ownership_real_estate_registry']
                            .toString(),
                      ) ??
                      0)
          : 0,
      unrecordedOwnershipDocumentationPen:
          json['unrecorded_ownership_documentation_pen'] != null
          ? (json['unrecorded_ownership_documentation_pen'] is int
                ? json['unrecorded_ownership_documentation_pen']
                : int.tryParse(
                        json['unrecorded_ownership_documentation_pen']
                            .toString(),
                      ) ??
                      0)
          : 0,
      jurisdictionViolation: json['jurisdiction_violation'] != null
          ? (json['jurisdiction_violation'] is int
                ? json['jurisdiction_violation']
                : int.tryParse(json['jurisdiction_violation'].toString()) ?? 0)
          : 0,
      hasBlanks:
          json['has_blanks'] == 1 ||
          json['has_blanks'] == true ||
          json['has_blanks'] == '1',
      hasScratchesOrInsertions:
          json['has_scratches_or_insertions'] == 1 ||
          json['has_scratches_or_insertions'] == true ||
          json['has_scratches_or_insertions'] == '1',
      deletedAt: json['deleted_at'] ?? null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'record_book_inspection_id': recordBookInspectionId,
      'constraint_id': constraintId,
      'notes': notes,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'missing_seller_ownership_document': missingSellerOwnershipDocument,
      'missing_annotation_or_cancellation': missingAnnotationOrCancellation,
      'missing_inheritance_ruling': missingInheritanceRuling,
      'missing_power_of_attorney': missingPowerOfAttorney,
      'missing_lease_document': missingLeaseDocument,
      'missing_waqf_document': missingWaqfDocument,
      'missing_state_property_permission': missingStatePropertyPermission,
      'missing_minors_property_permission': missingMinorsPropertyPermission,
      'unrecorded_ownership_real_estate_registry':
          unrecordedOwnershipRealEstateRegistry,
      'unrecorded_ownership_documentation_pen':
          unrecordedOwnershipDocumentationPen,
      'jurisdiction_violation': jurisdictionViolation,
      'has_blanks': hasBlanks,
      'has_scratches_or_insertions': hasScratchesOrInsertions,
      'deleted_at': deletedAt,
    };
  }
}
