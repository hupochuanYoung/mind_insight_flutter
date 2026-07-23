import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'logging_interceptor.dart';

/// Simple configuration for API loading behavior.
class LoadingConfig {
  final bool showLoading;
  final String? loadingMessage;

  const LoadingConfig({this.showLoading = true, this.loadingMessage});

  /// Show loading with default message.
  static const LoadingConfig show = LoadingConfig(showLoading: true);

  /// No loading indicator.
  static const LoadingConfig hide = LoadingConfig(showLoading: false);

  /// Show loading with custom message.
  static LoadingConfig withMessage(String message) =>
      LoadingConfig(showLoading: true, loadingMessage: message);
}

/// Dio HTTP client for communicating with the MindInsight Agent API.
///
/// Modelled after the POS DioClient — supports GET, POST, PUT, DELETE with
/// optional [LoadingConfig] for each call.
class DioClient {
  final String baseUrl;
  final LoggingInterceptor loggingInterceptor;

  late Dio dio;
  String? token;

  DioClient(this.baseUrl, {required this.loggingInterceptor, Dio? dioC}) {
    dio = dioC ?? Dio();
    _applyDefaults();
  }

  void _applyDefaults() {
    dio
      ..options.baseUrl = baseUrl
      ..options.connectTimeout = const Duration(seconds: 30)
      ..options.receiveTimeout = const Duration(seconds: 60)
      ..options.headers = {'Content-Type': 'application/json; charset=UTF-8'};
    dio.interceptors.add(loggingInterceptor);
  }

  /// Update the Authorization header (e.g. after login).
  void updateToken(String newToken) {
    token = newToken;
    dio.options.headers['Authorization'] = 'Bearer $newToken';
  }

  // ---------------------------------------------------------------------------
  // GET
  // ---------------------------------------------------------------------------
  Future<Response> get(
    String uri, {
    Map<String, dynamic>? queryParameters,
    CancelToken? cancelToken,
    Options? options,
  }) async {
    try {
      debugPrint('apiCall GET ==> $uri | params: $queryParameters');
      final response = await dio.get(
        uri,
        queryParameters: queryParameters,
        cancelToken: cancelToken,
        options: options,
      );
      return response;
    } on SocketException catch (e) {
      throw SocketException(e.toString());
    } on FormatException catch (_) {
      throw const FormatException('Unable to process the data');
    } catch (e) {
      rethrow;
    }
  }

  // ---------------------------------------------------------------------------
  // POST
  // ---------------------------------------------------------------------------
  Future<Response> post(
    String uri, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
    Options? options,
  }) async {
    try {
      debugPrint('apiCall POST ==> $uri | data: $data');
      final response = await dio.post(
        uri,
        data: data,
        queryParameters: queryParameters,
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
        options: options,
      );
      return response;
    } on FormatException catch (_) {
      throw const FormatException('Unable to process the data');
    } catch (e) {
      rethrow;
    }
  }

  // ---------------------------------------------------------------------------
  // PUT
  // ---------------------------------------------------------------------------
  Future<Response> put(
    String uri, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
    Options? options,
  }) async {
    try {
      debugPrint('apiCall PUT ==> $uri | data: $data');
      final response = await dio.put(
        uri,
        data: data,
        queryParameters: queryParameters,
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
        options: options,
      );
      return response;
    } on FormatException catch (_) {
      throw const FormatException('Unable to process the data');
    } catch (e) {
      rethrow;
    }
  }

  // ---------------------------------------------------------------------------
  // DELETE
  // ---------------------------------------------------------------------------
  Future<Response> delete(
    String uri, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    CancelToken? cancelToken,
    Options? options,
  }) async {
    try {
      debugPrint('apiCall DELETE ==> $uri | params: $queryParameters');
      final response = await dio.delete(
        uri,
        data: data,
        queryParameters: queryParameters,
        cancelToken: cancelToken,
        options: options,
      );
      return response;
    } on FormatException catch (_) {
      throw const FormatException('Unable to process the data');
    } catch (e) {
      rethrow;
    }
  }
}
