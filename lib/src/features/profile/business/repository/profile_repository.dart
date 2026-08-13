import 'package:dartz/dartz.dart';

import '../../../../core/data/exception/failure.dart';
import '../../data/model/profile_model.dart';
import '../param/profile_update_param.dart';

/// Abstract repository for the Profile feature.
abstract class ProfileRepository {
  Future<Either<Failure, ProfileModel>> getProfile();
  Future<Either<Failure, ProfileModel>> updateProfile(ProfileUpdateParam param);
}
