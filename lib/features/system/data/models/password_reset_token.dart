class PasswordResetToken {
  final String email;
  final String token;
  final String? createdAt;

  PasswordResetToken({
    required this.email,
    required this.token,
    this.createdAt,
  });

  factory PasswordResetToken.fromJson(Map<String, dynamic> json) {
    return PasswordResetToken(
      email: json['email'] ?? '',
      token: json['token'] ?? '',
      createdAt: json['created_at'] ?? null,
    );
  }

  Map<String, dynamic> toJson() {
    return {'email': email, 'token': token, 'created_at': createdAt};
  }
}
