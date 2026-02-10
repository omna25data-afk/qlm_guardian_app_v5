/// Date utilities for Hijri/Gregorian conversion and formatting
class AppDateUtils {
  AppDateUtils._();

  /// Format Gregorian date to Arabic string
  static String formatGregorian(DateTime? date) {
    if (date == null) return '-';
    return '${date.year}/${date.month.toString().padLeft(2, '0')}/${date.day.toString().padLeft(2, '0')}';
  }

  /// Format Hijri date string (e.g., "1446/05/12")
  static String formatHijri(String? hijriDate, int? hijriYear) {
    if (hijriDate != null && hijriDate.isNotEmpty) return hijriDate;
    if (hijriYear != null) return '$hijriYear هـ';
    return '-';
  }

  /// Get current Hijri year (approximate)
  /// For production, use hijri_calendar package for accuracy
  static int approximateHijriYear() {
    final now = DateTime.now();
    // Approximate: Gregorian year - 579 (rough conversion)
    return now.year - 579;
  }

  /// Format DateTime to "منذ X" (time ago) in Arabic
  static String timeAgo(DateTime? dateTime) {
    if (dateTime == null) return '-';
    final diff = DateTime.now().difference(dateTime);

    if (diff.inDays > 365) {
      final years = (diff.inDays / 365).floor();
      return 'منذ $years ${years == 1 ? 'سنة' : 'سنوات'}';
    } else if (diff.inDays > 30) {
      final months = (diff.inDays / 30).floor();
      return 'منذ $months ${months == 1 ? 'شهر' : 'أشهر'}';
    } else if (diff.inDays > 0) {
      return 'منذ ${diff.inDays} ${diff.inDays == 1 ? 'يوم' : 'أيام'}';
    } else if (diff.inHours > 0) {
      return 'منذ ${diff.inHours} ${diff.inHours == 1 ? 'ساعة' : 'ساعات'}';
    } else if (diff.inMinutes > 0) {
      return 'منذ ${diff.inMinutes} ${diff.inMinutes == 1 ? 'دقيقة' : 'دقائق'}';
    } else {
      return 'الآن';
    }
  }

  /// Parse a date string from API (ISO 8601)
  static DateTime? parseApiDate(String? dateString) {
    if (dateString == null || dateString.isEmpty) return null;
    try {
      return DateTime.parse(dateString);
    } catch (_) {
      return null;
    }
  }
}
