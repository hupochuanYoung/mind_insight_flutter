import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

import '../../../../core/constant/app_constants.dart';
import '../../../../core/data/dio/dio_client.dart';
import '../../../../core/data/exception/api_error_handler.dart';
import '../../../../core/data/exception/failure.dart';
import '../../business/param/agent_chat_param.dart';
import '../model/agent_chat_model.dart';

/// Remote data source for Agent chat API.
class AgentRemoteDatasource {
  final DioClient _dioClient;

  AgentRemoteDatasource({required DioClient dioClient})
    : _dioClient = dioClient;

  /// POST /api/agent/chat
  Future<Either<Failure, AgentChatModel>> chat(AgentChatParam param) async {
    try {
      final response = await _dioClient.post(
        AppConstants.agentChatUri,
        data: param.toJson(),
      );

      final body = response.data as Map<String, dynamic>;
      final code = body['code'] as int? ?? -1;

      if (code != 0) {
        return left(
          ServerFailure(
            errorMessage: body['message'] as String? ?? 'Unknown server error',
            errorCode: code.toString(),
          ),
        );
      }

      final model = AgentChatModel.fromJson(
        body['data'] as Map<String, dynamic>,
      );
      return right(model);
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
