import 'package:flutter/material.dart';

/// Lightweight toast / snackbar helper following the POS ToastHelper pattern.
///
/// Uses the nearest [ScaffoldMessenger] — no third-party overlay needed.
class ToastHelper {
  static final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();

  /// Show an informational snackbar.
  static void showToast(String message, {Duration duration = const Duration(seconds: 2)}) {
    scaffoldMessengerKey.currentState?.showSnackBar(
      SnackBar(content: Text(message), duration: duration, behavior: SnackBarBehavior.floating),
    );
  }

  /// Show an error-styled snackbar.
  static void showErrorToast(String message, {Duration duration = const Duration(seconds: 3)}) {
    scaffoldMessengerKey.currentState?.showSnackBar(
      SnackBar(
        content: Text(message, style: const TextStyle(color: Colors.white)),
        backgroundColor: Colors.redAccent,
        duration: duration,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  /// Show a success-styled snackbar.
  static void showSuccessToast(String message, {Duration duration = const Duration(seconds: 2)}) {
    scaffoldMessengerKey.currentState?.showSnackBar(
      SnackBar(
        content: Text(message, style: const TextStyle(color: Colors.white)),
        backgroundColor: const Color(0xFF2F9C95),
        duration: duration,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  /// Show a loading overlay dialog — call [closeLoading] to dismiss.
  static void showLoading({String? msg, required BuildContext context}) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => PopScope(
        canPop: false,
        child: Center(
          child: Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const CircularProgressIndicator(),
                  if (msg != null) ...[const SizedBox(height: 16), Text(msg)],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// Close the loading dialog opened by [showLoading].
  static void closeLoading(BuildContext context) {
    Navigator.of(context, rootNavigator: true).pop();
  }
}
