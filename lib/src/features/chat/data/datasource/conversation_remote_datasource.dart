import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

import '../../../../core/constant/app_constants.dart';
import '../../../../core/data/dio/dio_client.dart';
import '../../../../core/data/exception/api_error_handler.dart';
import '../../../../core/data/exception/failure.dart';
import '../../business/param/create_conversation_param.dart';
import '../../business/param/create_message_param.dart';
import '../../business/param/update_conversation_param.dart';
import '../model/conversation_message_list_model.dart';
import '../model/conversation_model.dart';
import '../model/conversation_reply_model.dart';

/// Remote data source for Conversation API.
class ConversationRemoteDatasource {
  final DioClient _dioClient;

  ConversationRemoteDatasource({required DioClient dioClient})
    : _dioClient = dioClient;

  /// POST /api/conversations
  Future<Either<Failure, ConversationModel>> createConversation(
    CreateConversationParam param,
  ) async {
    try {
      final response = await _dioClient.post(
        AppConstants.conversationsUri,
        data: param.toJson(),
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
      return right(
        ConversationModel.fromJson(body['data'] as Map<String, dynamic>),
      );
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

  /// GET /api/conversations
  Future<Either<Failure, List<ConversationModel>>> listConversations({
    int pageNumber = 1,
    int pageSize = 20,
  }) async {
    try {
      final response = await _dioClient.get(
        AppConstants.conversationsUri,
        queryParameters: {'pageNumber': pageNumber, 'pageSize': pageSize},
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
      final list = (body['data']['list'] as List<dynamic>)
          .map((e) => ConversationModel.fromJson(e as Map<String, dynamic>))
          .toList();
      return right(list);
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

  /// GET /api/conversations/{id}
  Future<Either<Failure, ConversationModel>> getConversation(int id) async {
    try {
      final response = await _dioClient.get(AppConstants.conversationUri(id));
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
      return right(
        ConversationModel.fromJson(body['data'] as Map<String, dynamic>),
      );
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

  /// PATCH /api/conversations/{id}
  Future<Either<Failure, ConversationModel>> updateConversation(
    int id,
    UpdateConversationParam param,
  ) async {
    try {
      final response = await _dioClient.patch(
        AppConstants.conversationUri(id),
        data: param.toJson(),
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
      return right(
        ConversationModel.fromJson(body['data'] as Map<String, dynamic>),
      );
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

  /// DELETE /api/conversations/{id}
  Future<Either<Failure, void>> deleteConversation(int id) async {
    try {
      final response = await _dioClient.delete(
        AppConstants.conversationUri(id),
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
      return right(null);
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

  /// POST /api/conversations/{id}/respond
  Future<Either<Failure, ConversationReplyModel>> respond(
    int id,
    CreateMessageParam param,
  ) async {
    try {
      final response = await _dioClient.post(
        AppConstants.conversationRespondUri(id),
        data: param.toJson(),
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
      return right(
        ConversationReplyModel.fromJson(body['data'] as Map<String, dynamic>),
      );
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

  /// GET /api/conversations/{id}/messages
  Future<Either<Failure, ConversationMessageListModel>> listMessages(
    int id, {
    int pageSize = 50,
    String? recordId,
  }) async {
    try {
      final queryParams = <String, dynamic>{'pageSize': pageSize};
      if (recordId != null && recordId.isNotEmpty) {
        queryParams['recordId'] = recordId;
      }
      final response = await _dioClient.get(
        AppConstants.conversationMessagesUri(id),
        queryParameters: queryParams,
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
      return right(
        ConversationMessageListModel.fromJson(
          body['data'] as Map<String, dynamic>,
        ),
      );
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
