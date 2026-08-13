import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

import '../../../../core/constant/app_constants.dart';
import '../../../../core/data/dio/dio_client.dart';
import '../../../../core/data/exception/api_error_handler.dart';
import '../../../../core/data/exception/failure.dart';
import '../model/profile_model.dart';
import '../model/profile_update_request.dart';

/// Remote data source for Profile API.
class ProfileRemoteDatasource {
  final DioClient _dioClient;

  ProfileRemoteDatasource({required DioClient dioClient})
    : _dioClient = dioClient;

  /// GET /api/profile
  Future<Either<Failure, ProfileModel>> getProfile() async {
    try {
      final response = await _dioClient.get(AppConstants.profileUri);
      final body = response.data as Map<String, dynamic>;
      final code = body['code'] as int? ?? -1;
      if (code != 0) {
        return left(
          ServerFailure(
            errorMessage: body['message'] as String? ?? 'Unknown error',
            errorCode: code.toString(),
          ),
        );
      }
      return right(ProfileModel.fromJson(body['data'] as Map<String, dynamic>));
    } on DioException catch (e) {
      return left(
        ConnectionFailure(errorMessage: ApiErrorHandler.getMessage(e)),
      );
    } catch (e) {
      return left(
        ServerFailure(errorMessage: e.toString(), errorCode: 'UNKNOWN'),
      );
    }
  }

  /// PUT /api/profile
  Future<Either<Failure, ProfileModel>> updateProfile(
    ProfileUpdateRequest request,
  ) async {
    try {
      final response = await _dioClient.put(
        AppConstants.profileUri,
        data: request.toJson(),
      );
      final body = response.data as Map<String, dynamic>;
      final code = body['code'] as int? ?? -1;
      if (code != 0) {
        return left(
          ServerFailure(
            errorMessage: body['message'] as String? ?? 'Unknown error',
            errorCode: code.toString(),
          ),
        );
      }
      return right(ProfileModel.fromJson(body['data'] as Map<String, dynamic>));
    } on DioException catch (e) {
      return left(
        ConnectionFailure(errorMessage: ApiErrorHandler.getMessage(e)),
      );
    } catch (e) {
      return left(
        ServerFailure(errorMessage: e.toString(), errorCode: 'UNKNOWN'),
      );
    }
  }
}
