import 'package:dartz/dartz.dart';

import '../../../../core/data/exception/failure.dart';
import '../../../../core/data/usecase/usecase.dart';
import '../../data/model/logout_model.dart';
import '../repository/profile_repository.dart';

/// Use case: logout current user.
class LogoutUseCase extends UseCase<LogoutModel, NoParams> {
  final ProfileRepository _repository;

  LogoutUseCase({required ProfileRepository repository})
    : _repository = repository;

  @override
  Future<Either<Failure, LogoutModel>> call(NoParams params) {
    return _repository.logout();
  }
}
