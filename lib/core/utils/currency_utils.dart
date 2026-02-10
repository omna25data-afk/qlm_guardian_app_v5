import 'package:intl/intl.dart';

/// Currency formatting utilities for Yemeni Rial
class CurrencyUtils {
  CurrencyUtils._();

  static final _numberFormat = NumberFormat('#,##0', 'ar');
  static final _decimalFormat = NumberFormat('#,##0.00', 'ar');

  /// Format amount as Yemeni Rial (e.g., "1,500 ر.ي")
  static String formatYER(double amount) {
    return '${_numberFormat.format(amount)} ر.ي';
  }

  /// Format amount with decimals (e.g., "1,500.50 ر.ي")
  static String formatYERDecimal(double amount) {
    return '${_decimalFormat.format(amount)} ر.ي';
  }

  /// Format amount without currency symbol
  static String formatNumber(double amount) {
    return _numberFormat.format(amount);
  }

  /// Calculate remaining amount
  static double remaining(double total, double paid) {
    return total - paid;
  }

  /// Format remaining with color hint
  /// Returns a record with formatted text and whether it's fully paid
  static ({String text, bool isFullyPaid}) formatRemaining(
    double total,
    double paid,
  ) {
    final rem = remaining(total, paid);
    return (text: formatYER(rem), isFullyPaid: rem <= 0);
  }
}
