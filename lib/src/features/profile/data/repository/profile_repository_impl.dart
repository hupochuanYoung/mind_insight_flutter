import 'package:dartz/dartz.dart';

import '../../../../core/data/exception/failure.dart';
import '../../business/param/profile_update_param.dart';
import '../../business/repository/profile_repository.dart';
import '../datasource/profile_remote_datasource.dart';
import '../model/profile_model.dart';

/// Concrete [ProfileRepository] implementation.
class ProfileRepositoryImpl implements ProfileRepository {
  final ProfileRemoteDatasource _profileRemote;

  ProfileRepositoryImpl({required ProfileRemoteDatasource profileRemote})
    : _profileRemote = profileRemote;

  @override
  Future<Either<Failure, ProfileModel>> getProfile() =>
      _profileRemote.getProfile();

  @override
  Future<Either<Failure, ProfileModel>> updateProfile(
    ProfileUpdateParam param,
  ) => _profileRemote.updateProfile(param);
}
