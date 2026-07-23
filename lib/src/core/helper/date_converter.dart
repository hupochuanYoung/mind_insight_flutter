import 'package:intl/intl.dart';

/// Date/time formatting and conversion utilities.
///
/// Follows the same pattern as the POS DateConverter but trimmed to
/// what MindInsight actually needs (no timezone / business-day logic).
class DateConverter {
  /// e.g. "2 minutes ago", "3 hours ago", "yesterday"
  static String timeAgo(DateTime dateTime) {
    final now = DateTime.now();
    final diff = now.difference(dateTime);

    if (diff.inSeconds < 60) return 'just now';
    if (diff.inMinutes < 60) {
      final m = diff.inMinutes;
      return '$m ${m == 1 ? 'minute' : 'minutes'} ago';
    }
    if (diff.inHours < 24) {
      final h = diff.inHours;
      return '$h ${h == 1 ? 'hour' : 'hours'} ago';
    }
    if (diff.inDays < 7) {
      final d = diff.inDays;
      return '$d ${d == 1 ? 'day' : 'days'} ago';
    }
    return formatDate(dateTime);
  }

  /// "yyyy-MM-dd"
  static String formatDate(DateTime? time) {
    if (time == null) return '';
    return DateFormat('yyyy-MM-dd').format(time);
  }

  /// "HH:mm"
  static String formatTime(DateTime? time) {
    if (time == null) return '';
    return DateFormat('HH:mm').format(time);
  }

  /// "yyyy-MM-dd HH:mm"
  static String formatDateTime(DateTime? time) {
    if (time == null) return '';
    return DateFormat('yyyy-MM-dd HH:mm').format(time);
  }

  /// "dd/MM/yyyy HH:mm"
  static String formatDateTimeSlash(DateTime? time) {
    if (time == null) return '';
    return DateFormat('dd/MM/yyyy HH:mm').format(time);
  }

  /// "HH:mm:ss"
  static String formatTimeWithSeconds(DateTime? time) {
    if (time == null) return '';
    return DateFormat('HH:mm:ss').format(time);
  }

  /// "dd MMM yyyy" e.g. "23 Jul 2026"
  static String formatDateReadable(DateTime? time) {
    if (time == null) return '';
    return DateFormat('dd MMM yyyy').format(time);
  }

  /// Check if two DateTimes represent the same calendar day.
  static bool isSameDay(DateTime? a, DateTime? b) {
    if (a == null || b == null) return false;
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }
}
