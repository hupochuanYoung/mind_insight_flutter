import 'package:dartz/dartz.dart';

import '../../../../core/data/exception/failure.dart';
import '../../business/param/profile_update_param.dart';
import '../../business/repository/profile_repository.dart';
import '../datasource/profile_local_datasource.dart';
import '../datasource/profile_remote_datasource.dart';
import '../model/profile_model.dart';

/// Concrete [ProfileRepository] implementation.
///
/// Fetches from remote and caches locally. Returns cached data as fallback
/// if remote fails.
class ProfileRepositoryImpl implements ProfileRepository {
  final ProfileRemoteDatasource _profileRemote;
  final ProfileLocalDatasource _profileLocal;

  ProfileRepositoryImpl({
    required ProfileRemoteDatasource profileRemote,
    required ProfileLocalDatasource profileLocal,
  }) : _profileRemote = profileRemote,
       _profileLocal = profileLocal;

  @override
  Future<Either<Failure, ProfileModel>> getProfile() async {
    final result = await _profileRemote.getProfile();

    return result.fold(
      (failure) {
        // Fallback to cached profile if remote fails.
        final cached = _profileLocal.getProfile();
        if (cached != null) {
          return right(cached);
        }
        return left(failure);
      },
      (profile) {
        // Cache the fresh profile.
        _profileLocal.saveProfile(profile);
        return right(profile);
      },
    );
  }

  @override
  Future<Either<Failure, ProfileModel>> updateProfile(
    ProfileUpdateParam param,
  ) async {
    final result = await _profileRemote.updateProfile(param);

    result.fold((_) {}, (profile) {
      // Update the cache with the new profile.
      _profileLocal.saveProfile(profile);
    });

    return result;
  }
}
