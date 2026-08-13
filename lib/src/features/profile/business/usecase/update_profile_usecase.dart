import 'package:dartz/dartz.dart';

import '../../../../core/data/exception/failure.dart';
import '../../../../core/data/usecase/usecase.dart';
import '../../data/model/profile_model.dart';
import '../param/profile_update_param.dart';
import '../repository/profile_repository.dart';

/// Use case: update user profile.
class UpdateProfileUseCase extends UseCase<ProfileModel, Params<ProfileUpdateParam>> {
  final ProfileRepository _repository;

  UpdateProfileUseCase({required ProfileRepository repository})
    : _repository = repository;

  @override
  Future<Either<Failure, ProfileModel>> call(Params<ProfileUpdateParam> params) {
    return _repository.updateProfile(params.data);
  }
}
