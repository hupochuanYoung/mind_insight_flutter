import 'package:dartz/dartz.dart';

import '../../../../core/data/exception/failure.dart';
import '../../../../core/data/usecase/usecase.dart';
import '../../data/model/profile_model.dart';
import '../repository/profile_repository.dart';

/// Use case: fetch current user profile.
class GetProfileUseCase extends UseCase<ProfileModel, NoParams> {
  final ProfileRepository _repository;

  GetProfileUseCase({required ProfileRepository repository})
    : _repository = repository;

  @override
  Future<Either<Failure, ProfileModel>> call(NoParams params) {
    return _repository.getProfile();
  }
}
