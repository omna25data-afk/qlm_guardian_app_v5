class ArabicPluralization {
  /// Format counting for "سجل" (Record)
  /// Rules:
  /// 0 -> 0 سجل
  /// 1 -> سجل واحد
  /// 2 -> سجلان
  /// 3-10 -> X سجلات
  /// 11-99 -> X سجلاً
  /// 100+ -> X سجل (or depending on last two digits)
  static String formatRecords(int count, {bool includeZero = true}) {
    if (count == 0) return includeZero ? '0 سجل' : 'لا توجد سجلات';
    if (count == 1) return 'سجل واحد';
    if (count == 2) return 'سجلان';

    int lastTwoDigits = count % 100;

    if (lastTwoDigits >= 3 && lastTwoDigits <= 10) {
      return '$count سجلات';
    } else if (lastTwoDigits >= 11 && lastTwoDigits <= 99) {
      return '$count سجلاً';
    } else {
      return '$count سجل';
    }
  }

  /// Format counting for "قيد" (Entry)
  static String formatEntries(int count, {bool includeZero = true}) {
    if (count == 0) return includeZero ? '0 قيد' : 'لا توجد قيود';
    if (count == 1) return 'قيد واحد';
    if (count == 2) return 'قيدان';

    int lastTwoDigits = count % 100;

    if (lastTwoDigits >= 3 && lastTwoDigits <= 10) {
      return '$count قيود';
    } else if (lastTwoDigits >= 11 && lastTwoDigits <= 99) {
      return '$count قيداً';
    } else {
      return '$count قيد';
    }
  }
}
