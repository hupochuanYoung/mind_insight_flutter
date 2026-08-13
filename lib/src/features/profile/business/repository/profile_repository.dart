import 'package:dartz/dartz.dart';

import '../../../../core/data/exception/failure.dart';
import '../../data/model/login_model.dart';
import '../../data/model/login_request.dart';
import '../../data/model/logout_model.dart';
import '../../data/model/profile_model.dart';
import '../../data/model/profile_update_request.dart';
import '../../data/model/register_request.dart';
import '../../data/model/wechat_login_request.dart';

/// Abstract repository for the Profile (Me) feature.
///
/// Combines auth and profile operations.
abstract class ProfileRepository {
  // ---------------------------------------------------------------------------
  // Auth
  // ---------------------------------------------------------------------------

  Future<Either<Failure, LoginModel>> register(RegisterRequest request);
  Future<Either<Failure, LoginModel>> login(LoginRequest request);
  Future<Either<Failure, LogoutModel>> logout();
  Future<Either<Failure, LoginModel>> wechatLogin(WechatLoginRequest request);

  // ---------------------------------------------------------------------------
  // Profile
  // ---------------------------------------------------------------------------

  Future<Either<Failure, ProfileModel>> getProfile();
  Future<Either<Failure, ProfileModel>> updateProfile(
    ProfileUpdateRequest request,
  );
}
