import 'package:dartz/dartz.dart';

import '../../../../core/data/exception/failure.dart';
import '../../../../core/data/usecase/usecase.dart';
import '../../data/model/login_model.dart';
import '../param/login_param.dart';
import '../repository/auth_repository.dart';

/// Use case: login with username/password.
class LoginUseCase extends UseCase<LoginModel, LoginParam> {
  final AuthRepository _repository;

  LoginUseCase({required AuthRepository repository})
      : _repository = repository;

  @override
  Future<Either<Failure, LoginModel>> call(LoginParam params) {
    return _repository.login(params);
  }
}
