import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import 'logging_interceptor.dart';

/// Dio HTTP client for communicating with the MindInsight Agent API.
///
/// Modelled after the POS project's DioClient but simplified for agent chat.
class DioClient {
  final String baseUrl;
  final LoggingInterceptor loggingInterceptor;

  late Dio dio;

  DioClient(this.baseUrl, {required this.loggingInterceptor, Dio? dioC}) {
    dio = dioC ?? Dio();
    dio
      ..options.baseUrl = baseUrl
      ..options.connectTimeout = const Duration(seconds: 30)
      ..options.receiveTimeout = const Duration(seconds: 60)
      ..options.headers = {'Content-Type': 'application/json; charset=UTF-8'};
    dio.interceptors.add(loggingInterceptor);
  }

  Future<Response> get(
    String uri, {
    Map<String, dynamic>? queryParameters,
    CancelToken? cancelToken,
    Options? options,
  }) async {
    try {
      debugPrint('apiCall get ==> url=> $uri \n params---> $queryParameters');
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
      throw const FormatException("Unable to process the data");
    } catch (e) {
      rethrow;
    }
  }

  Future<Response> post(
    String uri, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    CancelToken? cancelToken,
    Options? options,
  }) async {
    try {
      debugPrint('apiCall post ==> url=> $uri \n data---> $data');
      final response = await dio.post(
        uri,
        data: data,
        queryParameters: queryParameters,
        cancelToken: cancelToken,
        options: options,
      );
      return response;
    } on FormatException catch (_) {
      throw const FormatException("Unable to process the data");
    } catch (e) {
      rethrow;
    }
  }
}
