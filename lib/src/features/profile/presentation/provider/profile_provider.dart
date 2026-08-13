import 'package:flutter/foundation.dart';

import '../../../../core/data/usecase/usecase.dart';
import '../../business/usecase/get_profile_usecase.dart';
import '../../data/model/profile_model.dart';

/// ViewModel for the Profile feature.
class ProfileProvider extends ChangeNotifier {
  final GetProfileUseCase _getProfileUseCase;

  ProfileProvider({required GetProfileUseCase getProfileUseCase})
    : _getProfileUseCase = getProfileUseCase;

  // ---------------------------------------------------------------------------
  // State
  // ---------------------------------------------------------------------------

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  ProfileModel? _profile;
  ProfileModel? get profile => _profile;

  // ---------------------------------------------------------------------------
  // Actions
  // ---------------------------------------------------------------------------

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
