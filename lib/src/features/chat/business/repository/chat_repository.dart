import 'package:dartz/dartz.dart';

import '../../../../core/data/exception/failure.dart';
import '../../data/model/agent_chat_model.dart';
import '../../data/model/agent_chat_request.dart';
import '../../data/model/conversation_event_model.dart';
import '../../data/model/conversation_message_model.dart';
import '../../data/model/conversation_model.dart';
import '../../data/model/conversation_reply_model.dart';
import '../../data/model/create_conversation_request.dart';
import '../../data/model/create_message_request.dart';
import '../../data/model/create_tarot_draw_request.dart';
import '../../data/model/reveal_tarot_cards_request.dart';
import '../../data/model/tarot_reveal_model.dart';
import '../../data/model/tarot_session_model.dart';
import '../../data/model/update_conversation_request.dart';

/// Abstract repository for the entire Chat feature.
///
/// Combines agent, conversation, and tarot operations since they all
/// belong to the same user flow.
abstract class ChatRepository {
  // ---------------------------------------------------------------------------
  // Agent
  // ---------------------------------------------------------------------------

  Future<Either<Failure, AgentChatModel>> chatWithAgent(
    AgentChatRequest request,
  );

  // ---------------------------------------------------------------------------
  // Conversation
  // ---------------------------------------------------------------------------

  Future<Either<Failure, ConversationModel>> createConversation(
    CreateConversationRequest request,
  );

  Future<Either<Failure, List<ConversationModel>>> listConversations({
    int pageNumber = 1,
    int pageSize = 20,
  });

  Future<Either<Failure, ConversationModel>> getConversation(int id);

  Future<Either<Failure, ConversationModel>> updateConversation(
    int id,
    UpdateConversationRequest request,
  );

  Future<Either<Failure, void>> deleteConversation(int id);

  Future<Either<Failure, ConversationReplyModel>> respond(
    int id,
    CreateMessageRequest request,
  );

  Future<Either<Failure, List<ConversationMessageModel>>> listMessages(
    int id, {
    int pageNumber = 1,
    int pageSize = 20,
  });

  Future<Either<Failure, List<ConversationEventModel>>> listEvents(int id);

  // ---------------------------------------------------------------------------
  // Tarot
  // ---------------------------------------------------------------------------

  Future<Either<Failure, TarotSessionModel>> createTarotDraw(
    CreateTarotDrawRequest request,
  );

  Future<Either<Failure, TarotSessionModel>> getTarotDraw(int id);

  Future<Either<Failure, TarotRevealModel>> revealTarotCards(
    int id,
    RevealTarotCardsRequest request,
  );

  Future<Either<Failure, TarotRevealModel>> interpretTarotCards(int id);
}
