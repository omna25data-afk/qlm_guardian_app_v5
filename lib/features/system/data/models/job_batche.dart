class JobBatche {
  final String id;
  final String name;
  final int totalJobs;
  final int pendingJobs;
  final int failedJobs;
  final String failedJobIds;
  final String? options;
  final int? cancelledAt;
  final int createdAt;
  final int? finishedAt;

  JobBatche({
    required this.id,
    required this.name,
    required this.totalJobs,
    required this.pendingJobs,
    required this.failedJobs,
    required this.failedJobIds,
    this.options,
    this.cancelledAt,
    required this.createdAt,
    this.finishedAt,
  });

  factory JobBatche.fromJson(Map<String, dynamic> json) {
    return JobBatche(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      totalJobs: json['total_jobs'] != null ? (json['total_jobs'] is int ? json['total_jobs'] : int.tryParse(json['total_jobs'].toString()) ?? 0) : 0,
      pendingJobs: json['pending_jobs'] != null ? (json['pending_jobs'] is int ? json['pending_jobs'] : int.tryParse(json['pending_jobs'].toString()) ?? 0) : 0,
      failedJobs: json['failed_jobs'] != null ? (json['failed_jobs'] is int ? json['failed_jobs'] : int.tryParse(json['failed_jobs'].toString()) ?? 0) : 0,
      failedJobIds: json['failed_job_ids'] ?? '',
      options: json['options'] ?? null,
      cancelledAt: json['cancelled_at'] != null ? (json['cancelled_at'] is int ? json['cancelled_at'] : int.tryParse(json['cancelled_at'].toString()) ?? null) : null,
      createdAt: json['created_at'] != null ? (json['created_at'] is int ? json['created_at'] : int.tryParse(json['created_at'].toString()) ?? 0) : 0,
      finishedAt: json['finished_at'] != null ? (json['finished_at'] is int ? json['finished_at'] : int.tryParse(json['finished_at'].toString()) ?? null) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'total_jobs': totalJobs,
      'pending_jobs': pendingJobs,
      'failed_jobs': failedJobs,
      'failed_job_ids': failedJobIds,
      'options': options,
      'cancelled_at': cancelledAt,
      'created_at': createdAt,
      'finished_at': finishedAt,
    };
  }
}
