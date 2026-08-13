import 'package:dartz/dartz.dart';

import '../exception/failure.dart';

// ignore_for_file: avoid_types_as_parameter_names

/// Base use case contract — every business-layer use case implements this.
///
/// Returns [Either<Failure, Type>] to handle errors without exceptions.
abstract class UseCase<Type, Params> {
  Future<Either<Failure, Type>> call(Params params);
}

/// Use case that returns a raw [Future<Type>] (no Either wrapping).
abstract class SingleUseCaseAsync<Type, Params> {
  Future<Type> call(Params params);
}

/// Synchronous use case variant.
abstract class SingleUseCase<Type, Params> {
  Type call(Params params);
}

/// Typed parameter wrapper.
class Params<T> {
  final T data;

  Params(this.data);
}

/// Marker for use cases that take no arguments.
abstract class EmptyParams {}

class NoParams extends EmptyParams {}
