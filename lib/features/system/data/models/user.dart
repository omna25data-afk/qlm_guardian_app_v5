class User {
  final int id;
  final String name;
  final String? email;
  final String? phoneNumber;
  final String? emailVerifiedAt;
  final String password;
  final String? rememberToken;
  final String? createdAt;
  final String? updatedAt;
  final String? deletedAt;
  final int? legitimateGuardianId;
  final int? documentationEmployeeId;
  final String? unit;

  User({
    required this.id,
    required this.name,
    this.email,
    this.phoneNumber,
    this.emailVerifiedAt,
    required this.password,
    this.rememberToken,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
    this.legitimateGuardianId,
    this.documentationEmployeeId,
    this.unit,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] != null ? (json['id'] is int ? json['id'] : int.tryParse(json['id'].toString()) ?? 0) : 0,
      name: json['name'] ?? '',
      email: json['email'] ?? null,
      phoneNumber: json['phone_number'] ?? null,
      emailVerifiedAt: json['email_verified_at'] ?? null,
      password: json['password'] ?? '',
      rememberToken: json['remember_token'] ?? null,
      createdAt: json['created_at'] ?? null,
      updatedAt: json['updated_at'] ?? null,
      deletedAt: json['deleted_at'] ?? null,
      legitimateGuardianId: json['legitimate_guardian_id'] != null ? (json['legitimate_guardian_id'] is int ? json['legitimate_guardian_id'] : int.tryParse(json['legitimate_guardian_id'].toString()) ?? null) : null,
      documentationEmployeeId: json['documentation_employee_id'] != null ? (json['documentation_employee_id'] is int ? json['documentation_employee_id'] : int.tryParse(json['documentation_employee_id'].toString()) ?? null) : null,
      unit: json['unit'] ?? null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone_number': phoneNumber,
      'email_verified_at': emailVerifiedAt,
      'password': password,
      'remember_token': rememberToken,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'deleted_at': deletedAt,
      'legitimate_guardian_id': legitimateGuardianId,
      'documentation_employee_id': documentationEmployeeId,
      'unit': unit,
    };
  }
}
