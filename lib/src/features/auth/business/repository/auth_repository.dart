import 'package:dartz/dartz.dart';

import '../../../../core/data/exception/failure.dart';
import '../../data/model/login_model.dart';
import '../../data/model/logout_model.dart';
import '../param/login_param.dart';
import '../param/register_param.dart';
import '../param/wechat_login_param.dart';

/// Abstract repository for the Auth feature.
abstract class AuthRepository {
  Future<Either<Failure, LoginModel>> register(RegisterParam param);
  Future<Either<Failure, LoginModel>> login(LoginParam param);
  Future<Either<Failure, LogoutModel>> logout();
  Future<Either<Failure, LoginModel>> wechatLogin(WechatLoginParam param);
}
