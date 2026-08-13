import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

import '../../../../core/constant/app_constants.dart';
import '../../../../core/data/dio/dio_client.dart';
import '../../../../core/data/exception/api_error_handler.dart';
import '../../../../core/data/exception/failure.dart';
import '../../business/param/login_param.dart';
import '../../business/param/register_param.dart';
import '../../business/param/wechat_login_param.dart';
import '../model/login_model.dart';
import '../model/logout_model.dart';

/// Remote data source for Auth API.
class AuthRemoteDatasource {
  final DioClient _dioClient;

  AuthRemoteDatasource({required DioClient dioClient})
      : _dioClient = dioClient;

  /// POST /api/auth/register
  Future<Either<Failure, LoginModel>> register(RegisterParam param) async {
    try {
      final response = await _dioClient.post(
        AppConstants.registerUri,
        data: param.toJson(),
      );
      final body = response.data as Map<String, dynamic>;
      final code = body['code'] as int? ?? -1;
      if (code != 0) {
        return left(ServerFailure(
          errorMessage: body['message'] as String? ?? 'Unknown error',
          errorCode: code.toString(),
        ));
      }
      return right(
          LoginModel.fromJson(body['data'] as Map<String, dynamic>));
    } on DioException catch (e) {
      return left(ConnectionFailure(errorMessage: ApiErrorHandler.getMessage(e)));
    } catch (e) {
      return left(ServerFailure(errorMessage: e.toString(), errorCode: 'UNKNOWN'));
    }
  }

  /// POST /api/auth/login
  Future<Either<Failure, LoginModel>> login(LoginParam param) async {
    try {
      final response = await _dioClient.post(
        AppConstants.loginUri,
        data: param.toJson(),
      );
      final body = response.data as Map<String, dynamic>;
      final code = body['code'] as int? ?? -1;
      if (code != 0) {
        return left(ServerFailure(
          errorMessage: body['message'] as String? ?? 'Unknown error',
          errorCode: code.toString(),
        ));
      }
      return right(
          LoginModel.fromJson(body['data'] as Map<String, dynamic>));
    } on DioException catch (e) {
      return left(ConnectionFailure(errorMessage: ApiErrorHandler.getMessage(e)));
    } catch (e) {
      return left(ServerFailure(errorMessage: e.toString(), errorCode: 'UNKNOWN'));
    }
  }

  /// POST /api/auth/logout
  Future<Either<Failure, LogoutModel>> logout() async {
    try {
      final response = await _dioClient.post(AppConstants.logoutUri);
      final body = response.data as Map<String, dynamic>;
      final code = body['code'] as int? ?? -1;
      if (code != 0) {
        return left(ServerFailure(
          errorMessage: body['message'] as String? ?? 'Unknown error',
          errorCode: code.toString(),
        ));
      }
      return right(
          LogoutModel.fromJson(body['data'] as Map<String, dynamic>));
    } on DioException catch (e) {
      return left(ConnectionFailure(errorMessage: ApiErrorHandler.getMessage(e)));
    } catch (e) {
      return left(ServerFailure(errorMessage: e.toString(), errorCode: 'UNKNOWN'));
    }
  }

  /// POST /api/auth/wechat/login
  Future<Either<Failure, LoginModel>> wechatLogin(
      WechatLoginParam param) async {
    try {
      final response = await _dioClient.post(
        AppConstants.wechatLoginUri,
        data: param.toJson(),
      );
      final body = response.data as Map<String, dynamic>;
      final code = body['code'] as int? ?? -1;
      if (code != 0) {
        return left(ServerFailure(
          errorMessage: body['message'] as String? ?? 'Unknown error',
          errorCode: code.toString(),
        ));
      }
      return right(
          LoginModel.fromJson(body['data'] as Map<String, dynamic>));
    } on DioException catch (e) {
      return left(ConnectionFailure(errorMessage: ApiErrorHandler.getMessage(e)));
    } catch (e) {
      return left(ServerFailure(errorMessage: e.toString(), errorCode: 'UNKNOWN'));
    }
  }
}
