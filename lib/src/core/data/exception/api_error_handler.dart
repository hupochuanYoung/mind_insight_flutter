import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

/// Extracts a human-readable error message from Dio exceptions.
///
/// Follows the POS ApiErrorHandler pattern — maps [DioExceptionType] to
/// user-friendly strings for display via toast or UI.
class ApiErrorHandler {
  /// Parse a [DioException] (or generic error) into a displayable string.
  static String getMessage(dynamic error) {
    String errorDescription = '';

    if (error is DioException) {
      switch (error.type) {
        case DioExceptionType.cancel:
          errorDescription = 'Request was cancelled';
          break;
        case DioExceptionType.connectionTimeout:
          errorDescription = 'Connection timed out — please check your network';
          break;
        case DioExceptionType.sendTimeout:
          errorDescription = 'Send timeout — the server is not responding';
          break;
        case DioExceptionType.receiveTimeout:
          errorDescription = 'Receive timeout — try again later';
          break;
        case DioExceptionType.badResponse:
          errorDescription = _handleBadResponse(error);
          break;
        case DioExceptionType.connectionError:
          errorDescription =
              'Unable to connect — check your internet connection';
          break;
        case DioExceptionType.badCertificate:
          errorDescription = 'Certificate verification failed';
          break;
        case DioExceptionType.unknown:
          errorDescription = 'An unexpected error occurred';
          break;
        case DioExceptionType.transformTimeout:
          errorDescription = 'Data transform timed out';
          break;
      }
    } else if (error is Exception) {
      errorDescription = error.toString();
    } else {
      errorDescription = 'An unexpected error occurred';
    }

    if (kDebugMode) {
      debugPrint('[ApiErrorHandler] $errorDescription');
    }

    return errorDescription;
  }

  /// Handle HTTP error status codes.
  static String _handleBadResponse(DioException error) {
    final statusCode = error.response?.statusCode ?? 0;
    final data = error.response?.data;

    // Try to extract a message field from the response body.
    if (data is Map<String, dynamic>) {
      final msg = data['message'] ?? data['error'] ?? data['detail'];
      if (msg != null && msg.toString().isNotEmpty) {
        return msg.toString();
      }
    }

    // Fall back to generic status-code messages.
    switch (statusCode) {
      case 400:
        return 'Bad request';
      case 401:
        return 'Unauthorized — please log in again';
      case 403:
        return 'Forbidden — you do not have permission';
      case 404:
        return 'Resource not found';
      case 422:
        return 'Validation error';
      case 500:
        return 'Internal server error';
      case 502:
        return 'Bad gateway';
      case 503:
        return 'Service unavailable — try again later';
      default:
        return 'Request failed with status $statusCode';
    }
  }
}
