import 'package:intl/intl.dart';

class DateUtils {
  static const String defaultDateFormat = 'dd/MM/yyyy';
  static const String defaultDateTimeFormat = 'dd/MM/yyyy HH:mm';
  static const String defaultTimeFormat = 'HH:mm';

  /// Format a DateTime to a string with the given format
  static String formatDate(DateTime? date,
      {String format = defaultDateFormat}) {
    if (date == null) return '';
    return DateFormat(format).format(date);
  }

  /// Format a DateTime to a date and time string
  static String formatDateTime(DateTime? date) {
    return formatDate(date, format: defaultDateTimeFormat);
  }

  /// Format a DateTime to a time string
  static String formatTime(DateTime? date) {
    return formatDate(date, format: defaultTimeFormat);
  }

  /// Get a relative time string (e.g., "2 hours ago")
  static String getRelativeTime(DateTime? date) {
    if (date == null) return '';

    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays > 7) {
      return formatDate(date);
    } else if (difference.inDays > 0) {
      return '${difference.inDays} day${difference.inDays > 1 ? 's' : ''} ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} hour${difference.inHours > 1 ? 's' : ''} ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} minute${difference.inMinutes > 1 ? 's' : ''} ago';
    } else {
      return 'Just now';
    }
  }

  /// Check if a date is today
  static bool isToday(DateTime? date) {
    if (date == null) return false;
    final now = DateTime.now();
    return date.day == now.day &&
        date.month == now.month &&
        date.year == now.year;
  }

  /// Check if a date is this week
  static bool isThisWeek(DateTime? date) {
    if (date == null) return false;
    final now = DateTime.now();
    final startOfWeek = now.subtract(Duration(days: now.weekday - 1));
    final endOfWeek = startOfWeek.add(const Duration(days: 6));
    return date.isAfter(startOfWeek) && date.isBefore(endOfWeek);
  }

  /// Check if a date is this month
  static bool isThisMonth(DateTime? date) {
    if (date == null) return false;
    final now = DateTime.now();
    return date.month == now.month && date.year == now.year;
  }

  /// Parse a date string to DateTime
  static DateTime? parseDate(String? dateString,
      {String format = defaultDateFormat}) {
    if (dateString == null || dateString.isEmpty) return null;
    try {
      return DateFormat(format).parse(dateString);
    } catch (e) {
      return null;
    }
  }

  /// Get the start of day for a given date
  static DateTime startOfDay(DateTime date) {
    return DateTime(date.year, date.month, date.day);
  }

  /// Get the end of day for a given date
  static DateTime endOfDay(DateTime date) {
    return DateTime(date.year, date.month, date.day, 23, 59, 59, 999);
  }

  /// Get the start of week for a given date
  static DateTime startOfWeek(DateTime date) {
    return date.subtract(Duration(days: date.weekday - 1));
  }

  /// Get the end of week for a given date
  static DateTime endOfWeek(DateTime date) {
    return startOfWeek(date).add(const Duration(days: 6));
  }

  /// Get the start of month for a given date
  static DateTime startOfMonth(DateTime date) {
    return DateTime(date.year, date.month, 1);
  }

  /// Get the end of month for a given date
  static DateTime endOfMonth(DateTime date) {
    return DateTime(date.year, date.month + 1, 1)
        .subtract(const Duration(days: 1));
  }
}
