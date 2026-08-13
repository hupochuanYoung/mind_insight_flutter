import '../../../../core/constant/app_constants.dart';
import '../../../../core/data/dio/dio_client.dart';
import '../../../../core/data/model/api_response.dart';
import '../model/agent_chat_request.dart';
import '../model/agent_chat_response_vo.dart';

class AgentApiService {
  final DioClient _dioClient;

  AgentApiService(this._dioClient);

  /// POST /api/agent/chat
  Future<ApiResponse<AgentChatResponseVO>> chat(
      AgentChatRequest request) async {
    final response = await _dioClient.post(
      AppConstants.agentChatUri,
      data: request.toJson(),
    );
    return ApiResponse.fromJson(
      response.data as Map<String, dynamic>,
      (json) => AgentChatResponseVO.fromJson(json as Map<String, dynamic>),
    );
  }
}
