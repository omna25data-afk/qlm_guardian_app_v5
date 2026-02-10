/// Form field validators for Arabic/Yemeni input
class Validators {
  Validators._();

  /// Required field
  static String? required(String? value, [String fieldName = 'هذا الحقل']) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName مطلوب';
    }
    return null;
  }

  /// Validate phone number (Yemeni format: 7XXXXXXXX)
  static String? phone(String? value) {
    if (value == null || value.isEmpty) return 'رقم الهاتف مطلوب';
    final cleaned = value.replaceAll(RegExp(r'[\s\-\+]'), '');
    // Yemen: 9 digits starting with 7
    if (!RegExp(r'^(967)?7\d{8}$').hasMatch(cleaned)) {
      return 'رقم الهاتف غير صالح';
    }
    return null;
  }

  /// Validate email
  static String? email(String? value) {
    if (value == null || value.isEmpty) return 'البريد الإلكتروني مطلوب';
    if (!RegExp(r'^[\w\.\-]+@[\w\.\-]+\.\w+$').hasMatch(value)) {
      return 'البريد الإلكتروني غير صالح';
    }
    return null;
  }

  /// Validate amount (positive number)
  static String? amount(String? value) {
    if (value == null || value.isEmpty) return null; // Optional
    final amount = double.tryParse(value);
    if (amount == null || amount < 0) {
      return 'المبلغ غير صالح';
    }
    return null;
  }

  /// Validate minimum length
  static String? minLength(
    String? value,
    int min, [
    String fieldName = 'هذا الحقل',
  ]) {
    if (value == null || value.length < min) {
      return '$fieldName يجب أن يكون $min أحرف على الأقل';
    }
    return null;
  }

  /// Validate national ID (Yemeni: numeric, typically 8-10 digits)
  static String? nationalId(String? value) {
    if (value == null || value.isEmpty) return null; // Optional
    if (!RegExp(r'^\d{8,10}$').hasMatch(value)) {
      return 'رقم الهوية غير صالح';
    }
    return null;
  }

  /// Validate password
  static String? password(String? value) {
    if (value == null || value.isEmpty) return 'كلمة المرور مطلوبة';
    if (value.length < 6) {
      return 'كلمة المرور يجب أن تكون 6 أحرف على الأقل';
    }
    return null;
  }

  /// Combine multiple validators
  static String? Function(String?) combine(
    List<String? Function(String?)> validators,
  ) {
    return (String? value) {
      for (final validator in validators) {
        final result = validator(value);
        if (result != null) return result;
      }
      return null;
    };
  }
}
