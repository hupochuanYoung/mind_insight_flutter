import 'package:flutter/foundation.dart';

import '../../../../core/data/usecase/usecase.dart';
import '../../business/usecase/get_profile_usecase.dart';
import '../../business/usecase/login_usecase.dart';
import '../../business/usecase/logout_usecase.dart';
import '../../data/model/login_model.dart';
import '../../data/model/login_request.dart';
import '../../data/model/profile_model.dart';

/// ViewModel for the Profile (Me) feature.
class ProfileProvider extends ChangeNotifier {
  final LoginUseCase _loginUseCase;
  final LogoutUseCase _logoutUseCase;
  final GetProfileUseCase _getProfileUseCase;

  ProfileProvider({
    required LoginUseCase loginUseCase,
    required LogoutUseCase logoutUseCase,
    required GetProfileUseCase getProfileUseCase,
  }) : _loginUseCase = loginUseCase,
       _logoutUseCase = logoutUseCase,
       _getProfileUseCase = getProfileUseCase;

  // ---------------------------------------------------------------------------
  // State
  // ---------------------------------------------------------------------------

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  ProfileModel? _profile;
  ProfileModel? get profile => _profile;

  LoginModel? _loginResponse;
  LoginModel? get loginResponse => _loginResponse;

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
      LoginRequest(username: username, password: password),
    );

    result.fold(
      (failure) {
        _errorMessage = failure.errorMessage ?? 'Login failed';
      },
      (response) {
        _loginResponse = response;
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
        _loginResponse = null;
        _profile = null;
      },
    );

    _isLoading = false;
    _notify();
  }

  /// Fetch current user profile.
  Future<void> fetchProfile() async {
    _isLoading = true;
    _errorMessage = null;
    _notify();

    final result = await _getProfileUseCase.call(NoParams());

    result.fold(
      (failure) {
        _errorMessage = failure.errorMessage ?? 'Failed to load profile';
      },
      (response) {
        _profile = response;
      },
    );

    _isLoading = false;
    _notify();
  }

  void _notify() {
    notifyListeners();
  }
}
