import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

/// Logging interceptor — prints request/response details in debug mode.
class LoggingInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    debugPrint('┌──────────────────────────────────────────');
    debugPrint('│ [${options.method}] ${options.baseUrl}${options.path}');
    debugPrint('│ Headers: ${options.headers}');
    if (options.data != null) {
      debugPrint('│ Body: ${options.data}');
    }
    debugPrint('└──────────────────────────────────────────');
    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    debugPrint('┌──────────────────────────────────────────');
    debugPrint('│ [${response.statusCode}] ${response.requestOptions.path}');
    debugPrint('│ Data: ${response.data}');
    debugPrint('└──────────────────────────────────────────');
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    debugPrint('┌──────────────────────────────────────────');
    debugPrint('│ [ERROR] ${err.requestOptions.path}');
    debugPrint('│ ${err.message}');
    if (err.response != null) {
      debugPrint('│ Status: ${err.response?.statusCode}');
      debugPrint('│ Data: ${err.response?.data}');
    }
    debugPrint('└──────────────────────────────────────────');
    handler.next(err);
  }
}
