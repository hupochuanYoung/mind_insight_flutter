import 'package:dartz/dartz.dart';

import '../../../../core/data/exception/failure.dart';
import '../../../../core/data/usecase/usecase.dart';
import '../../data/model/login_model.dart';
import '../param/register_param.dart';
import '../repository/auth_repository.dart';

/// Use case: register a new account.
class RegisterUseCase extends UseCase<LoginModel, RegisterParam> {
  final AuthRepository _repository;

  RegisterUseCase({required AuthRepository repository})
      : _repository = repository;

  @override
  Future<Either<Failure, LoginModel>> call(RegisterParam params) {
    return _repository.register(params);
  }
}
