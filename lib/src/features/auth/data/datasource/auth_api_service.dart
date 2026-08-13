import '../../../../core/constant/app_constants.dart';
import '../../../../core/data/dio/dio_client.dart';
import '../../../../core/data/model/api_response.dart';
import '../model/login_request.dart';
import '../model/login_response.dart';
import '../model/logout_response.dart';
import '../model/register_request.dart';
import '../model/wechat_login_request.dart';

class AuthApiService {
  final DioClient _dioClient;

  AuthApiService(this._dioClient);

  /// POST /api/auth/register
  Future<ApiResponse<LoginResponse>> register(RegisterRequest request) async {
    final response = await _dioClient.post(
      AppConstants.registerUri,
      data: request.toJson(),
    );
    return ApiResponse.fromJson(
      response.data as Map<String, dynamic>,
      (json) => LoginResponse.fromJson(json as Map<String, dynamic>),
    );
  }

  /// POST /api/auth/login
  Future<ApiResponse<LoginResponse>> login(LoginRequest request) async {
    final response = await _dioClient.post(
      AppConstants.loginUri,
      data: request.toJson(),
    );
    return ApiResponse.fromJson(
      response.data as Map<String, dynamic>,
      (json) => LoginResponse.fromJson(json as Map<String, dynamic>),
    );
  }

  /// POST /api/auth/logout
  Future<ApiResponse<LogoutResponse>> logout() async {
    final response = await _dioClient.post(AppConstants.logoutUri);
    return ApiResponse.fromJson(
      response.data as Map<String, dynamic>,
      (json) => LogoutResponse.fromJson(json as Map<String, dynamic>),
    );
  }

  /// POST /api/auth/wechat/login
  Future<ApiResponse<LoginResponse>> wechatLogin(
      WechatLoginRequest request) async {
    final response = await _dioClient.post(
      AppConstants.wechatLoginUri,
      data: request.toJson(),
    );
    return ApiResponse.fromJson(
      response.data as Map<String, dynamic>,
      (json) => LoginResponse.fromJson(json as Map<String, dynamic>),
    );
  }
}
