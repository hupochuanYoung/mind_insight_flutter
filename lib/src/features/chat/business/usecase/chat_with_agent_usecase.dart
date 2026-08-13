import 'package:dartz/dartz.dart';

import '../../../../core/data/exception/failure.dart';
import '../../../../core/data/usecase/usecase.dart';
import '../../data/model/agent_chat_model.dart';
import '../../data/model/agent_chat_request.dart';
import '../repository/chat_repository.dart';

/// Use case: send a chat message to the AI agent.
class ChatWithAgentUseCase extends UseCase<AgentChatModel, AgentChatRequest> {
  final ChatRepository _repository;

  ChatWithAgentUseCase({required ChatRepository repository})
    : _repository = repository;

  @override
  Future<Either<Failure, AgentChatModel>> call(AgentChatRequest params) {
    return _repository.chatWithAgent(params);
  }
}
