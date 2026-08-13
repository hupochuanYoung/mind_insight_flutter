import 'package:dartz/dartz.dart';

import '../../../../core/data/exception/failure.dart';
import '../../business/repository/chat_repository.dart';
import '../datasource/agent_remote_datasource.dart';
import '../datasource/conversation_remote_datasource.dart';
import '../datasource/tarot_remote_datasource.dart';
import '../model/agent_chat_model.dart';
import '../model/agent_chat_request.dart';
import '../model/conversation_event_model.dart';
import '../model/conversation_message_model.dart';
import '../model/conversation_model.dart';
import '../model/conversation_reply_model.dart';
import '../model/create_conversation_request.dart';
import '../model/create_message_request.dart';
import '../model/create_tarot_draw_request.dart';
import '../model/reveal_tarot_cards_request.dart';
import '../model/tarot_reveal_model.dart';
import '../model/tarot_session_model.dart';
import '../model/update_conversation_request.dart';

/// Concrete [ChatRepository] implementation.
///
/// Delegates to the three remote datasources (agent, conversation, tarot).
class ChatRepositoryImpl implements ChatRepository {
  final AgentRemoteDatasource _agentRemote;
  final ConversationRemoteDatasource _conversationRemote;
  final TarotRemoteDatasource _tarotRemote;

  ChatRepositoryImpl({
    required AgentRemoteDatasource agentRemote,
    required ConversationRemoteDatasource conversationRemote,
    required TarotRemoteDatasource tarotRemote,
  }) : _agentRemote = agentRemote,
       _conversationRemote = conversationRemote,
       _tarotRemote = tarotRemote;

  // ---------------------------------------------------------------------------
  // Agent
  // ---------------------------------------------------------------------------

  @override
  Future<Either<Failure, AgentChatModel>> chatWithAgent(
    AgentChatRequest request,
  ) => _agentRemote.chat(request);

  // ---------------------------------------------------------------------------
  // Conversation
  // ---------------------------------------------------------------------------

  @override
  Future<Either<Failure, ConversationModel>> createConversation(
    CreateConversationRequest request,
  ) => _conversationRemote.createConversation(request);

  @override
  Future<Either<Failure, List<ConversationModel>>> listConversations({
    int pageNumber = 1,
    int pageSize = 20,
  }) => _conversationRemote.listConversations(
    pageNumber: pageNumber,
    pageSize: pageSize,
  );

  @override
  Future<Either<Failure, ConversationModel>> getConversation(int id) =>
      _conversationRemote.getConversation(id);

  @override
  Future<Either<Failure, ConversationModel>> updateConversation(
    int id,
    UpdateConversationRequest request,
  ) => _conversationRemote.updateConversation(id, request);

  @override
  Future<Either<Failure, void>> deleteConversation(int id) =>
      _conversationRemote.deleteConversation(id);

  @override
  Future<Either<Failure, ConversationReplyModel>> respond(
    int id,
    CreateMessageRequest request,
  ) => _conversationRemote.respond(id, request);

  @override
  Future<Either<Failure, List<ConversationMessageModel>>> listMessages(
    int id, {
    int pageNumber = 1,
    int pageSize = 20,
  }) => _conversationRemote.listMessages(
    id,
    pageNumber: pageNumber,
    pageSize: pageSize,
  );

  @override
  Future<Either<Failure, List<ConversationEventModel>>> listEvents(int id) =>
      _conversationRemote.listEvents(id);

  // ---------------------------------------------------------------------------
  // Tarot
  // ---------------------------------------------------------------------------

  @override
  Future<Either<Failure, TarotSessionModel>> createTarotDraw(
    CreateTarotDrawRequest request,
  ) => _tarotRemote.createDraw(request);

  @override
  Future<Either<Failure, TarotSessionModel>> getTarotDraw(int id) =>
      _tarotRemote.getDraw(id);

  @override
  Future<Either<Failure, TarotRevealModel>> revealTarotCards(
    int id,
    RevealTarotCardsRequest request,
  ) => _tarotRemote.revealCards(id, request);

  @override
  Future<Either<Failure, TarotRevealModel>> interpretTarotCards(int id) =>
      _tarotRemote.interpretCards(id);
}
