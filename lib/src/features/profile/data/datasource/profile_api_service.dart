import '../../../../core/constant/app_constants.dart';
import '../../../../core/data/dio/dio_client.dart';
import '../../../../core/data/model/api_response.dart';
import '../model/profile_me_response.dart';
import '../model/profile_update_request.dart';

class ProfileApiService {
  final DioClient _dioClient;

  ProfileApiService(this._dioClient);

  /// GET /api/profile
  Future<ApiResponse<ProfileMeResponse>> getProfile() async {
    final response = await _dioClient.get(AppConstants.profileUri);
    return ApiResponse.fromJson(
      response.data as Map<String, dynamic>,
      (json) => ProfileMeResponse.fromJson(json as Map<String, dynamic>),
    );
  }

  /// PUT /api/profile
  Future<ApiResponse<ProfileMeResponse>> updateProfile(
      ProfileUpdateRequest request) async {
    final response = await _dioClient.put(
      AppConstants.profileUri,
      data: request.toJson(),
    );
    return ApiResponse.fromJson(
      response.data as Map<String, dynamic>,
      (json) => ProfileMeResponse.fromJson(json as Map<String, dynamic>),
    );
  }
}
