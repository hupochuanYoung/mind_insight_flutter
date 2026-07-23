/// Base failure class for structured error handling.
///
/// Following the POS pattern — domain layers return typed [Failure] subclasses
/// instead of throwing raw exceptions.
abstract class Failure {
  final String? errorMessage;
  final String? errorCode;

  const Failure({this.errorMessage, this.errorCode});
}

/// Remote server returned an error response (4xx / 5xx).
class ServerFailure extends Failure {
  ServerFailure({required super.errorMessage, super.errorCode});
}

/// Network connectivity issue — no internet, DNS failure, timeout, etc.
class ConnectionFailure extends Failure {
  ConnectionFailure({required super.errorMessage});
}

/// Local database operation failed.
class DatabaseFailure extends Failure {
  DatabaseFailure({required super.errorMessage});
}

/// Input validation failed (client-side checks).
class ValidationFailure extends Failure {
  ValidationFailure({required super.errorMessage, super.errorCode});
}
