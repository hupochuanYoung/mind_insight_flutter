import 'package:dartz/dartz.dart';

import '../../../../core/data/dio/dio_client.dart';
import '../../../../core/data/exception/failure.dart';
import '../../business/param/login_param.dart';
import '../../business/param/register_param.dart';
import '../../business/param/wechat_login_param.dart';
import '../../business/repository/auth_repository.dart';
import '../datasource/auth_local_datasource.dart';
import '../datasource/auth_remote_datasource.dart';
import '../model/login_model.dart';
import '../model/logout_model.dart';

/// Concrete [AuthRepository] implementation.
///
/// On successful login/register, persists the token locally and updates
/// the DioClient header so all subsequent requests are authenticated.
class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDatasource _authRemote;
  final AuthLocalDatasource _authLocal;
  final DioClient _dioClient;

  AuthRepositoryImpl({
    required AuthRemoteDatasource authRemote,
    required AuthLocalDatasource authLocal,
    required DioClient dioClient,
  }) : _authRemote = authRemote,
       _authLocal = authLocal,
       _dioClient = dioClient;

  @override
  Future<Either<Failure, LoginModel>> register(RegisterParam param) async {
    final result = await _authRemote.register(param);
    result.fold((_) {}, (login) => _cacheToken(login));
    return result;
  }

  @override
  Future<Either<Failure, LoginModel>> login(LoginParam param) async {
    final result = await _authRemote.login(param);
    result.fold((_) {}, (login) => _cacheToken(login));
    return result;
  }

  @override
  Future<Either<Failure, LogoutModel>> logout() async {
    final result = await _authRemote.logout();
    result.fold((_) {}, (_) async {
      await _authLocal.clear();
      _dioClient.updateToken('');
    });
    return result;
  }

  @override
  Future<Either<Failure, LoginModel>> wechatLogin(
    WechatLoginParam param,
  ) async {
    final result = await _authRemote.wechatLogin(param);
    result.fold((_) {}, (login) => _cacheToken(login));
    return result;
  }

  /// Persist token locally and update the DioClient Authorization header.
  void _cacheToken(LoginModel login) {
    _authLocal.saveToken(login.accessToken);
    _authLocal.saveUserId(login.userId);
    _dioClient.updateToken(login.accessToken);
  }
}
