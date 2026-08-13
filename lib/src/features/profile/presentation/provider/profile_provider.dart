import 'package:flutter/foundation.dart';

import '../../../../core/data/usecase/usecase.dart';
import '../../business/param/profile_update_param.dart';
import '../../business/usecase/get_profile_usecase.dart';
import '../../business/usecase/update_profile_usecase.dart';
import '../../data/model/profile_model.dart';

/// ViewModel for the Profile feature.
class ProfileProvider extends ChangeNotifier {
  final GetProfileUseCase _getProfileUseCase;
  final UpdateProfileUseCase _updateProfileUseCase;

  ProfileProvider({
    required GetProfileUseCase getProfileUseCase,
    required UpdateProfileUseCase updateProfileUseCase,
  }) : _getProfileUseCase = getProfileUseCase,
       _updateProfileUseCase = updateProfileUseCase;

  // ---------------------------------------------------------------------------
  // State
  // ---------------------------------------------------------------------------

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  bool _isUpdating = false;
  bool get isUpdating => _isUpdating;

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

  /// Update the user profile.
  Future<bool> updateProfile(ProfileUpdateParam param) async {
    _isUpdating = true;
    _errorMessage = null;
    _notify();

    final result = await _updateProfileUseCase.call(Params(param));

    bool success = false;
    result.fold(
      (failure) {
        _errorMessage = failure.errorMessage ?? 'Failed to update profile';
      },
      (response) {
        _profile = response;
        success = true;
      },
    );

    _isUpdating = false;
    _notify();
    return success;
  }

  void _notify() {
    notifyListeners();
  }
}
