import '../../../../core/constant/app_constants.dart';
import '../../../../core/data/dio/dio_client.dart';
import '../../../../core/data/model/api_response.dart';
import '../model/conversation_event_vo.dart';
import '../model/conversation_message_vo.dart';
import '../model/conversation_reply_vo.dart';
import '../model/conversation_vo.dart';
import '../model/create_conversation_request.dart';
import '../model/create_message_request.dart';
import '../model/update_conversation_request.dart';

class ConversationApiService {
  final DioClient _dioClient;

  ConversationApiService(this._dioClient);

  /// POST /api/conversations
  Future<ApiResponse<ConversationVO>> createConversation(
      CreateConversationRequest request) async {
    final response = await _dioClient.post(
      AppConstants.conversationsUri,
      data: request.toJson(),
    );
    return ApiResponse.fromJson(
      response.data as Map<String, dynamic>,
      (json) => ConversationVO.fromJson(json as Map<String, dynamic>),
    );
  }

  /// GET /api/conversations
  Future<ApiResponse<List<ConversationVO>>> listConversations({
    int pageNumber = 1,
    int pageSize = 20,
  }) async {
    final response = await _dioClient.get(
      AppConstants.conversationsUri,
      queryParameters: {
        'pageNumber': pageNumber,
        'pageSize': pageSize,
      },
    );
    return ApiResponse.fromJson(
      response.data as Map<String, dynamic>,
      (json) => (json as List<dynamic>)
          .map((e) => ConversationVO.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  /// GET /api/conversations/{id}
  Future<ApiResponse<ConversationVO>> getConversation(int id) async {
    final response = await _dioClient.get(
      AppConstants.conversationUri(id),
    );
    return ApiResponse.fromJson(
      response.data as Map<String, dynamic>,
      (json) => ConversationVO.fromJson(json as Map<String, dynamic>),
    );
  }

  /// PATCH /api/conversations/{id}
  Future<ApiResponse<ConversationVO>> updateConversation(
      int id, UpdateConversationRequest request) async {
    final response = await _dioClient.put(
      AppConstants.conversationUri(id),
      data: request.toJson(),
    );
    return ApiResponse.fromJson(
      response.data as Map<String, dynamic>,
      (json) => ConversationVO.fromJson(json as Map<String, dynamic>),
    );
  }

  /// DELETE /api/conversations/{id}
  Future<ApiResponse<void>> deleteConversation(int id) async {
    final response = await _dioClient.delete(
      AppConstants.conversationUri(id),
    );
    return ApiResponse.fromJsonNoData(response.data as Map<String, dynamic>);
  }

  /// POST /api/conversations/{id}/respond
  Future<ApiResponse<ConversationReplyVO>> respond(
      int id, CreateMessageRequest request) async {
    final response = await _dioClient.post(
      AppConstants.conversationRespondUri(id),
      data: request.toJson(),
    );
    return ApiResponse.fromJson(
      response.data as Map<String, dynamic>,
      (json) => ConversationReplyVO.fromJson(json as Map<String, dynamic>),
    );
  }

  /// GET /api/conversations/{id}/messages
  Future<ApiResponse<List<ConversationMessageVO>>> listMessages(
    int id, {
    int pageNumber = 1,
    int pageSize = 20,
  }) async {
    final response = await _dioClient.get(
      AppConstants.conversationMessagesUri(id),
      queryParameters: {
        'pageNumber': pageNumber,
        'pageSize': pageSize,
      },
    );
    return ApiResponse.fromJson(
      response.data as Map<String, dynamic>,
      (json) => (json as List<dynamic>)
          .map((e) =>
              ConversationMessageVO.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  /// GET /api/conversations/{id}/events
  Future<ApiResponse<List<ConversationEventVO>>> listEvents(int id) async {
    final response = await _dioClient.get(
      AppConstants.conversationEventsUri(id),
    );
    return ApiResponse.fromJson(
      response.data as Map<String, dynamic>,
      (json) => (json as List<dynamic>)
          .map((e) =>
              ConversationEventVO.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}
