class DocumentationEmployee {
  final int id;
  final int userId;
  final String employeeNumber;
  final String department;
  final String position;
  final String hireDate;
  final double salary;
  final String status;
  final int? performanceRating;
  final String? notes;
  final String? createdAt;
  final String? updatedAt;
  final String? deletedAt;

  DocumentationEmployee({
    required this.id,
    required this.userId,
    required this.employeeNumber,
    required this.department,
    required this.position,
    required this.hireDate,
    required this.salary,
    required this.status,
    this.performanceRating,
    this.notes,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
  });

  factory DocumentationEmployee.fromJson(Map<String, dynamic> json) {
    return DocumentationEmployee(
      id: json['id'] != null ? (json['id'] is int ? json['id'] : int.tryParse(json['id'].toString()) ?? 0) : 0,
      userId: json['user_id'] != null ? (json['user_id'] is int ? json['user_id'] : int.tryParse(json['user_id'].toString()) ?? 0) : 0,
      employeeNumber: json['employee_number'] ?? '',
      department: json['department'] ?? '',
      position: json['position'] ?? '',
      hireDate: json['hire_date'] ?? '',
      salary: json['salary'] != null ? (json['salary'] is num ? json['salary'].toDouble() : double.tryParse(json['salary'].toString()) ?? 0.0) : 0.0,
      status: json['status'] ?? '',
      performanceRating: json['performance_rating'] != null ? (json['performance_rating'] is int ? json['performance_rating'] : int.tryParse(json['performance_rating'].toString()) ?? null) : null,
      notes: json['notes'] ?? null,
      createdAt: json['created_at'] ?? null,
      updatedAt: json['updated_at'] ?? null,
      deletedAt: json['deleted_at'] ?? null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'employee_number': employeeNumber,
      'department': department,
      'position': position,
      'hire_date': hireDate,
      'salary': salary,
      'status': status,
      'performance_rating': performanceRating,
      'notes': notes,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'deleted_at': deletedAt,
    };
  }
}
