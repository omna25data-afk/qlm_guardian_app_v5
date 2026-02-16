class GuardianSalesRegisterEvaluation {
  final int id;
  final int guardianId;
  final int evaluationPeriodId;
  final int totalSalesRecordBooks;
  final int totalSalesDocuments;
  final int freeSalesTotal;
  final int freeSalesFulfilled;
  final int freeSalesUnfulfilled;
  final double? freeSalesRatio;
  final int waqfSalesTotal;
  final int waqfSalesWithPermission;
  final int waqfSalesWithoutPermission;
  final double? waqfSalesRatio;
  final int statePropertySalesTotal;
  final int statePropertyWithPermission;
  final int statePropertyWithoutPermission;
  final double? statePropertySalesRatio;
  final int minorsPropertySalesTotal;
  final int minorsWithPermission;
  final int minorsWithoutPermission;
  final double? minorsPropertySalesRatio;
  final int titleMarkingExists;
  final double? titleMarkingScore;
  final int blanksExists;
  final double? blanksScore;
  final int ownershipDocsComplete;
  final double? ownershipDocsScore;
  final int scratchesOrErasuresExists;
  final double? scratchesOrErasuresScore;
  final String? territorialJurisdictionStatus;
  final double? territorialJurisdictionScore;
  final double? qualityTotalScore;
  final double? qualityAverageScore;
  final double? overallSalesEvaluationScore;
  final String? createdAt;
  final String? updatedAt;

  GuardianSalesRegisterEvaluation({
    required this.id,
    required this.guardianId,
    required this.evaluationPeriodId,
    required this.totalSalesRecordBooks,
    required this.totalSalesDocuments,
    required this.freeSalesTotal,
    required this.freeSalesFulfilled,
    required this.freeSalesUnfulfilled,
    this.freeSalesRatio,
    required this.waqfSalesTotal,
    required this.waqfSalesWithPermission,
    required this.waqfSalesWithoutPermission,
    this.waqfSalesRatio,
    required this.statePropertySalesTotal,
    required this.statePropertyWithPermission,
    required this.statePropertyWithoutPermission,
    this.statePropertySalesRatio,
    required this.minorsPropertySalesTotal,
    required this.minorsWithPermission,
    required this.minorsWithoutPermission,
    this.minorsPropertySalesRatio,
    required this.titleMarkingExists,
    this.titleMarkingScore,
    required this.blanksExists,
    this.blanksScore,
    required this.ownershipDocsComplete,
    this.ownershipDocsScore,
    required this.scratchesOrErasuresExists,
    this.scratchesOrErasuresScore,
    this.territorialJurisdictionStatus,
    this.territorialJurisdictionScore,
    this.qualityTotalScore,
    this.qualityAverageScore,
    this.overallSalesEvaluationScore,
    this.createdAt,
    this.updatedAt,
  });

  factory GuardianSalesRegisterEvaluation.fromJson(Map<String, dynamic> json) {
    return GuardianSalesRegisterEvaluation(
      id: json['id'] != null ? (json['id'] is int ? json['id'] : int.tryParse(json['id'].toString()) ?? 0) : 0,
      guardianId: json['guardian_id'] != null ? (json['guardian_id'] is int ? json['guardian_id'] : int.tryParse(json['guardian_id'].toString()) ?? 0) : 0,
      evaluationPeriodId: json['evaluation_period_id'] != null ? (json['evaluation_period_id'] is int ? json['evaluation_period_id'] : int.tryParse(json['evaluation_period_id'].toString()) ?? 0) : 0,
      totalSalesRecordBooks: json['total_sales_record_books'] != null ? (json['total_sales_record_books'] is int ? json['total_sales_record_books'] : int.tryParse(json['total_sales_record_books'].toString()) ?? 0) : 0,
      totalSalesDocuments: json['total_sales_documents'] != null ? (json['total_sales_documents'] is int ? json['total_sales_documents'] : int.tryParse(json['total_sales_documents'].toString()) ?? 0) : 0,
      freeSalesTotal: json['free_sales_total'] != null ? (json['free_sales_total'] is int ? json['free_sales_total'] : int.tryParse(json['free_sales_total'].toString()) ?? 0) : 0,
      freeSalesFulfilled: json['free_sales_fulfilled'] != null ? (json['free_sales_fulfilled'] is int ? json['free_sales_fulfilled'] : int.tryParse(json['free_sales_fulfilled'].toString()) ?? 0) : 0,
      freeSalesUnfulfilled: json['free_sales_unfulfilled'] != null ? (json['free_sales_unfulfilled'] is int ? json['free_sales_unfulfilled'] : int.tryParse(json['free_sales_unfulfilled'].toString()) ?? 0) : 0,
      freeSalesRatio: json['free_sales_ratio'] != null ? (json['free_sales_ratio'] is num ? json['free_sales_ratio'].toDouble() : double.tryParse(json['free_sales_ratio'].toString()) ?? null) : null,
      waqfSalesTotal: json['waqf_sales_total'] != null ? (json['waqf_sales_total'] is int ? json['waqf_sales_total'] : int.tryParse(json['waqf_sales_total'].toString()) ?? 0) : 0,
      waqfSalesWithPermission: json['waqf_sales_with_permission'] != null ? (json['waqf_sales_with_permission'] is int ? json['waqf_sales_with_permission'] : int.tryParse(json['waqf_sales_with_permission'].toString()) ?? 0) : 0,
      waqfSalesWithoutPermission: json['waqf_sales_without_permission'] != null ? (json['waqf_sales_without_permission'] is int ? json['waqf_sales_without_permission'] : int.tryParse(json['waqf_sales_without_permission'].toString()) ?? 0) : 0,
      waqfSalesRatio: json['waqf_sales_ratio'] != null ? (json['waqf_sales_ratio'] is num ? json['waqf_sales_ratio'].toDouble() : double.tryParse(json['waqf_sales_ratio'].toString()) ?? null) : null,
      statePropertySalesTotal: json['state_property_sales_total'] != null ? (json['state_property_sales_total'] is int ? json['state_property_sales_total'] : int.tryParse(json['state_property_sales_total'].toString()) ?? 0) : 0,
      statePropertyWithPermission: json['state_property_with_permission'] != null ? (json['state_property_with_permission'] is int ? json['state_property_with_permission'] : int.tryParse(json['state_property_with_permission'].toString()) ?? 0) : 0,
      statePropertyWithoutPermission: json['state_property_without_permission'] != null ? (json['state_property_without_permission'] is int ? json['state_property_without_permission'] : int.tryParse(json['state_property_without_permission'].toString()) ?? 0) : 0,
      statePropertySalesRatio: json['state_property_sales_ratio'] != null ? (json['state_property_sales_ratio'] is num ? json['state_property_sales_ratio'].toDouble() : double.tryParse(json['state_property_sales_ratio'].toString()) ?? null) : null,
      minorsPropertySalesTotal: json['minors_property_sales_total'] != null ? (json['minors_property_sales_total'] is int ? json['minors_property_sales_total'] : int.tryParse(json['minors_property_sales_total'].toString()) ?? 0) : 0,
      minorsWithPermission: json['minors_with_permission'] != null ? (json['minors_with_permission'] is int ? json['minors_with_permission'] : int.tryParse(json['minors_with_permission'].toString()) ?? 0) : 0,
      minorsWithoutPermission: json['minors_without_permission'] != null ? (json['minors_without_permission'] is int ? json['minors_without_permission'] : int.tryParse(json['minors_without_permission'].toString()) ?? 0) : 0,
      minorsPropertySalesRatio: json['minors_property_sales_ratio'] != null ? (json['minors_property_sales_ratio'] is num ? json['minors_property_sales_ratio'].toDouble() : double.tryParse(json['minors_property_sales_ratio'].toString()) ?? null) : null,
      titleMarkingExists: json['title_marking_exists'] != null ? (json['title_marking_exists'] is int ? json['title_marking_exists'] : int.tryParse(json['title_marking_exists'].toString()) ?? 0) : 0,
      titleMarkingScore: json['title_marking_score'] != null ? (json['title_marking_score'] is num ? json['title_marking_score'].toDouble() : double.tryParse(json['title_marking_score'].toString()) ?? null) : null,
      blanksExists: json['blanks_exists'] != null ? (json['blanks_exists'] is int ? json['blanks_exists'] : int.tryParse(json['blanks_exists'].toString()) ?? 0) : 0,
      blanksScore: json['blanks_score'] != null ? (json['blanks_score'] is num ? json['blanks_score'].toDouble() : double.tryParse(json['blanks_score'].toString()) ?? null) : null,
      ownershipDocsComplete: json['ownership_docs_complete'] != null ? (json['ownership_docs_complete'] is int ? json['ownership_docs_complete'] : int.tryParse(json['ownership_docs_complete'].toString()) ?? 0) : 0,
      ownershipDocsScore: json['ownership_docs_score'] != null ? (json['ownership_docs_score'] is num ? json['ownership_docs_score'].toDouble() : double.tryParse(json['ownership_docs_score'].toString()) ?? null) : null,
      scratchesOrErasuresExists: json['scratches_or_erasures_exists'] != null ? (json['scratches_or_erasures_exists'] is int ? json['scratches_or_erasures_exists'] : int.tryParse(json['scratches_or_erasures_exists'].toString()) ?? 0) : 0,
      scratchesOrErasuresScore: json['scratches_or_erasures_score'] != null ? (json['scratches_or_erasures_score'] is num ? json['scratches_or_erasures_score'].toDouble() : double.tryParse(json['scratches_or_erasures_score'].toString()) ?? null) : null,
      territorialJurisdictionStatus: json['territorial_jurisdiction_status'] ?? null,
      territorialJurisdictionScore: json['territorial_jurisdiction_score'] != null ? (json['territorial_jurisdiction_score'] is num ? json['territorial_jurisdiction_score'].toDouble() : double.tryParse(json['territorial_jurisdiction_score'].toString()) ?? null) : null,
      qualityTotalScore: json['quality_total_score'] != null ? (json['quality_total_score'] is num ? json['quality_total_score'].toDouble() : double.tryParse(json['quality_total_score'].toString()) ?? null) : null,
      qualityAverageScore: json['quality_average_score'] != null ? (json['quality_average_score'] is num ? json['quality_average_score'].toDouble() : double.tryParse(json['quality_average_score'].toString()) ?? null) : null,
      overallSalesEvaluationScore: json['overall_sales_evaluation_score'] != null ? (json['overall_sales_evaluation_score'] is num ? json['overall_sales_evaluation_score'].toDouble() : double.tryParse(json['overall_sales_evaluation_score'].toString()) ?? null) : null,
      createdAt: json['created_at'] ?? null,
      updatedAt: json['updated_at'] ?? null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'guardian_id': guardianId,
      'evaluation_period_id': evaluationPeriodId,
      'total_sales_record_books': totalSalesRecordBooks,
      'total_sales_documents': totalSalesDocuments,
      'free_sales_total': freeSalesTotal,
      'free_sales_fulfilled': freeSalesFulfilled,
      'free_sales_unfulfilled': freeSalesUnfulfilled,
      'free_sales_ratio': freeSalesRatio,
      'waqf_sales_total': waqfSalesTotal,
      'waqf_sales_with_permission': waqfSalesWithPermission,
      'waqf_sales_without_permission': waqfSalesWithoutPermission,
      'waqf_sales_ratio': waqfSalesRatio,
      'state_property_sales_total': statePropertySalesTotal,
      'state_property_with_permission': statePropertyWithPermission,
      'state_property_without_permission': statePropertyWithoutPermission,
      'state_property_sales_ratio': statePropertySalesRatio,
      'minors_property_sales_total': minorsPropertySalesTotal,
      'minors_with_permission': minorsWithPermission,
      'minors_without_permission': minorsWithoutPermission,
      'minors_property_sales_ratio': minorsPropertySalesRatio,
      'title_marking_exists': titleMarkingExists,
      'title_marking_score': titleMarkingScore,
      'blanks_exists': blanksExists,
      'blanks_score': blanksScore,
      'ownership_docs_complete': ownershipDocsComplete,
      'ownership_docs_score': ownershipDocsScore,
      'scratches_or_erasures_exists': scratchesOrErasuresExists,
      'scratches_or_erasures_score': scratchesOrErasuresScore,
      'territorial_jurisdiction_status': territorialJurisdictionStatus,
      'territorial_jurisdiction_score': territorialJurisdictionScore,
      'quality_total_score': qualityTotalScore,
      'quality_average_score': qualityAverageScore,
      'overall_sales_evaluation_score': overallSalesEvaluationScore,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }
}
