/// General-purpose utility functions for MindInsight.
class GeneralHelper {
  /// Truncate [name] to [maxLength] characters, optionally appending ellipsis.
  static String truncateName(String name, {int maxLength = 20, bool ellipsis = true}) {
    if (name.length <= maxLength) return name;
    return ellipsis ? '${name.substring(0, maxLength)}...' : name.substring(0, maxLength);
  }

  /// Return `true` if [value] can be parsed as an integer.
  static bool isIntNumeric(String value) {
    return int.tryParse(value.trim()) != null;
  }

  /// Return `true` if [value] can be parsed as a double.
  static bool isNumeric(String value) {
    return double.tryParse(value.trim()) != null;
  }

  /// Capitalize the first letter of [text].
  static String capitalize(String text) {
    if (text.isEmpty) return text;
    return text[0].toUpperCase() + text.substring(1);
  }

  /// Generate a simple greeting based on the hour of day.
  static String greetingByTime() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good morning';
    if (hour < 17) return 'Good afternoon';
    return 'Good evening';
  }
}
