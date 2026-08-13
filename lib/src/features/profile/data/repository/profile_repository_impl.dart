import 'package:dartz/dartz.dart';

import '../../../../core/data/exception/failure.dart';
import '../../business/repository/profile_repository.dart';
import '../datasource/auth_remote_datasource.dart';
import '../datasource/profile_remote_datasource.dart';
import '../model/login_model.dart';
import '../model/login_request.dart';
import '../model/logout_model.dart';
import '../model/profile_model.dart';
import '../model/profile_update_request.dart';
import '../model/register_request.dart';
import '../model/wechat_login_request.dart';

/// Concrete [ProfileRepository] implementation.
class ProfileRepositoryImpl implements ProfileRepository {
  final AuthRemoteDatasource _authRemote;
  final ProfileRemoteDatasource _profileRemote;

  ProfileRepositoryImpl({
    required AuthRemoteDatasource authRemote,
    required ProfileRemoteDatasource profileRemote,
  }) : _authRemote = authRemote,
       _profileRemote = profileRemote;

  // ---------------------------------------------------------------------------
  // Auth
  // ---------------------------------------------------------------------------

  @override
  Future<Either<Failure, LoginModel>> register(RegisterRequest request) =>
      _authRemote.register(request);

  @override
  Future<Either<Failure, LoginModel>> login(LoginRequest request) =>
      _authRemote.login(request);

  @override
  Future<Either<Failure, LogoutModel>> logout() => _authRemote.logout();

  @override
  Future<Either<Failure, LoginModel>> wechatLogin(WechatLoginRequest request) =>
      _authRemote.wechatLogin(request);

  // ---------------------------------------------------------------------------
  // Profile
  // ---------------------------------------------------------------------------

  @override
  Future<Either<Failure, ProfileModel>> getProfile() =>
      _profileRemote.getProfile();

  @override
  Future<Either<Failure, ProfileModel>> updateProfile(
    ProfileUpdateRequest request,
  ) => _profileRemote.updateProfile(request);
}
