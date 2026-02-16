class Record {
  final int id;
  final String name;
  final String? description;
  final String recordType;
  final String status;
  final String priority;
  final int? assignedTo;
  final int createdBy;
  final String? notes;
  final String? attachments;
  final String? recordDate;
  final String? expiryDate;
  final bool isActive;
  final String? createdAt;
  final String? updatedAt;
  final String? deletedAt;

  Record({
    required this.id,
    required this.name,
    this.description,
    required this.recordType,
    required this.status,
    required this.priority,
    this.assignedTo,
    required this.createdBy,
    this.notes,
    this.attachments,
    this.recordDate,
    this.expiryDate,
    required this.isActive,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
  });

  factory Record.fromJson(Map<String, dynamic> json) {
    return Record(
      id: json['id'] != null ? (json['id'] is int ? json['id'] : int.tryParse(json['id'].toString()) ?? 0) : 0,
      name: json['name'] ?? '',
      description: json['description'] ?? null,
      recordType: json['record_type'] ?? '',
      status: json['status'] ?? '',
      priority: json['priority'] ?? '',
      assignedTo: json['assigned_to'] != null ? (json['assigned_to'] is int ? json['assigned_to'] : int.tryParse(json['assigned_to'].toString()) ?? null) : null,
      createdBy: json['created_by'] != null ? (json['created_by'] is int ? json['created_by'] : int.tryParse(json['created_by'].toString()) ?? 0) : 0,
      notes: json['notes'] ?? null,
      attachments: json['attachments'] ?? null,
      recordDate: json['record_date'] ?? null,
      expiryDate: json['expiry_date'] ?? null,
      isActive: json['is_active'] == 1 || json['is_active'] == true || json['is_active'] == '1',
      createdAt: json['created_at'] ?? null,
      updatedAt: json['updated_at'] ?? null,
      deletedAt: json['deleted_at'] ?? null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'record_type': recordType,
      'status': status,
      'priority': priority,
      'assigned_to': assignedTo,
      'created_by': createdBy,
      'notes': notes,
      'attachments': attachments,
      'record_date': recordDate,
      'expiry_date': expiryDate,
      'is_active': isActive,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'deleted_at': deletedAt,
    };
  }
}
