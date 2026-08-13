import 'package:flutter/foundation.dart';

import '../../../../core/data/usecase/usecase.dart';
import '../../business/param/login_param.dart';
import '../../business/param/register_param.dart';
import '../../business/usecase/login_usecase.dart';
import '../../business/usecase/logout_usecase.dart';
import '../../business/usecase/register_usecase.dart';
import '../../data/model/login_model.dart';

/// ViewModel for the Auth feature.
class AuthProvider extends ChangeNotifier {
  final LoginUseCase _loginUseCase;
  final LogoutUseCase _logoutUseCase;
  final RegisterUseCase _registerUseCase;

  AuthProvider({
    required LoginUseCase loginUseCase,
    required LogoutUseCase logoutUseCase,
    required RegisterUseCase registerUseCase,
  })  : _loginUseCase = loginUseCase,
        _logoutUseCase = logoutUseCase,
        _registerUseCase = registerUseCase;

  // ---------------------------------------------------------------------------
  // State
  // ---------------------------------------------------------------------------

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  LoginModel? _loginModel;
  LoginModel? get loginModel => _loginModel;

  bool _isLoggedIn = false;
  bool get isLoggedIn => _isLoggedIn;

  // ---------------------------------------------------------------------------
  // Actions
  // ---------------------------------------------------------------------------

  /// Login with username and password.
  Future<void> login({
    required String username,
    required String password,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    _notify();

    final result = await _loginUseCase.call(
      LoginParam(username: username, password: password),
    );

    result.fold(
      (failure) {
        _errorMessage = failure.errorMessage ?? 'Login failed';
      },
      (response) {
        _loginModel = response;
        _isLoggedIn = true;
      },
    );

    _isLoading = false;
    _notify();
  }

  /// Register a new account.
  Future<void> register({
    required String username,
    required String password,
    String? nickname,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    _notify();

    final result = await _registerUseCase.call(
      RegisterParam(username: username, password: password, nickname: nickname),
    );

    result.fold(
      (failure) {
        _errorMessage = failure.errorMessage ?? 'Registration failed';
      },
      (response) {
        _loginModel = response;
        _isLoggedIn = true;
      },
    );

    _isLoading = false;
    _notify();
  }

  /// Logout.
  Future<void> logout() async {
    _isLoading = true;
    _errorMessage = null;
    _notify();

    final result = await _logoutUseCase.call(NoParams());

    result.fold(
      (failure) {
        _errorMessage = failure.errorMessage ?? 'Logout failed';
      },
      (_) {
        _isLoggedIn = false;
        _loginModel = null;
      },
    );

    _isLoading = false;
    _notify();
  }

  void _notify() {
    notifyListeners();
  }
}
