import 'package:flutter/material.dart';

/// Centralized color definitions for MindInsight.
///
/// Follows the POS ColorResources pattern — static constants for brand colors,
/// and context-aware getters for dark/light mode adaptations.
class ColorResources {
  const ColorResources._();

  // ---------------------------------------------------------------------------
  // Brand colors
  // ---------------------------------------------------------------------------
  static const Color primary = Color(0xFF7C6FCB);
  static const Color primarySoft = Color(0xFFF0ECFF);
  static const Color ink = Color(0xFF211D33);
  static const Color muted = Color(0xFF7A748C);
  static const Color surface = Color(0xFFFFFBF4);
  static const Color card = Colors.white;
  static const Color border = Color(0xFFECE7DF);

  // Accent colors
  static const Color gold = Color(0xFFFFC65A);
  static const Color teal = Color(0xFF2F9C95);
  static const Color pink = Color(0xFFE86F9D);
  static const Color amber = Color(0xFFFFB13B);

  // Status colors
  static const Color success = Color(0xFF2F9C95);
  static const Color warning = Color(0xFFFFB13B);
  static const Color error = Color(0xFFE5484D);
  static const Color info = Color(0xFF7C6FCB);

  // ---------------------------------------------------------------------------
  // Context-aware helpers
  // ---------------------------------------------------------------------------

  /// Error color set: [iconColor, bgColor, borderColor]
  static List<Color> getErrorColor(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return [
      isDark ? Colors.red.shade400 : Colors.red.shade600,
      isDark ? Colors.red.shade900.withValues(alpha: 0.15) : Colors.red.shade50,
      isDark ? Colors.red.shade400 : Colors.red,
    ];
  }

  /// Warning color set: [iconColor, bgColor, borderColor]
  static List<Color> getWarningColor(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return [
      isDark ? Colors.orange.shade300 : Colors.orange.shade700,
      isDark ? Colors.orange.shade900.withValues(alpha: 0.15) : Colors.orange.shade50,
      isDark ? Colors.orange.shade400 : Colors.orange,
    ];
  }

  /// Success color set: [iconColor, bgColor, borderColor]
  static List<Color> getSuccessColor(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return [
      isDark ? const Color(0xFF4FC3B8) : teal,
      isDark ? teal.withValues(alpha: 0.15) : const Color(0xFFE0F5F3),
      isDark ? const Color(0xFF4FC3B8) : teal,
    ];
  }

  /// Get a background color that adapts to current brightness.
  static Color getBackgroundColor(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark ? const Color(0xFF1A1525) : surface;
  }

  /// Get hint text color.
  static Color getHintColor(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark ? const Color(0xFFCAC4D0) : muted;
  }

  /// Get divider color.
  static Color getDividerColor(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark ? const Color(0xFF3D3750) : border;
  }

  /// Generate a color from a string initial (for avatars, tags, etc.)
  static Color getColorFromInitial(String input) {
    if (input.trim().isEmpty) return Colors.grey.shade300;
    final initial = input.trim().toUpperCase()[0];
    final code = initial.codeUnitAt(0);
    final index = code >= 65 && code <= 90 ? (code - 65) : (code % 26);
    final hue = index * (360 / 26);
    final hsl = HSLColor.fromAHSL(1.0, hue, 0.55, 0.75);
    return hsl.toColor();
  }
}
