import 'package:dartz/dartz.dart';

import '../../../../core/data/exception/failure.dart';
import '../../../../core/data/usecase/usecase.dart';
import '../../data/model/login_model.dart';
import '../../data/model/login_request.dart';
import '../repository/profile_repository.dart';

/// Use case: login with username/password.
class LoginUseCase extends UseCase<LoginModel, LoginRequest> {
  final ProfileRepository _repository;

  LoginUseCase({required ProfileRepository repository})
    : _repository = repository;

  @override
  Future<Either<Failure, LoginModel>> call(LoginRequest params) {
    return _repository.login(params);
  }
}
