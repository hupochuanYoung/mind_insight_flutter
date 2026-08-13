import 'package:dartz/dartz.dart';

import '../../../../core/data/exception/failure.dart';
import '../../business/param/login_param.dart';
import '../../business/param/register_param.dart';
import '../../business/param/wechat_login_param.dart';
import '../../business/repository/auth_repository.dart';
import '../datasource/auth_remote_datasource.dart';
import '../model/login_model.dart';
import '../model/logout_model.dart';

/// Concrete [AuthRepository] implementation.
class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDatasource _authRemote;

  AuthRepositoryImpl({required AuthRemoteDatasource authRemote})
      : _authRemote = authRemote;

  @override
  Future<Either<Failure, LoginModel>> register(RegisterParam param) =>
      _authRemote.register(param);

  @override
  Future<Either<Failure, LoginModel>> login(LoginParam param) =>
      _authRemote.login(param);

  @override
  Future<Either<Failure, LogoutModel>> logout() => _authRemote.logout();

  @override
  Future<Either<Failure, LoginModel>> wechatLogin(WechatLoginParam param) =>
      _authRemote.wechatLogin(param);
}
