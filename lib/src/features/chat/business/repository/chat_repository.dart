import 'package:dartz/dartz.dart';

import '../../../../core/data/exception/failure.dart';
import '../../data/model/agent_chat_model.dart';
import '../../data/model/conversation_message_list_model.dart';
import '../../data/model/conversation_model.dart';
import '../../data/model/conversation_reply_model.dart';
import '../../data/model/tarot_reveal_model.dart';
import '../../data/model/tarot_session_model.dart';
import '../param/agent_chat_param.dart';
import '../param/create_conversation_param.dart';
import '../param/create_message_param.dart';
import '../param/create_tarot_draw_param.dart';
import '../param/reveal_tarot_cards_param.dart';
import '../param/update_conversation_param.dart';

/// Abstract repository for the entire Chat feature.
///
/// Combines agent, conversation, and tarot operations since they all
/// belong to the same user flow.
abstract class ChatRepository {
  // ---------------------------------------------------------------------------
  // Agent
  // ---------------------------------------------------------------------------

  Future<Either<Failure, AgentChatModel>> chatWithAgent(AgentChatParam param);

  // ---------------------------------------------------------------------------
  // Conversation
  // ---------------------------------------------------------------------------

  Future<Either<Failure, ConversationModel>> createConversation(
    CreateConversationParam param,
  );

  Future<Either<Failure, List<ConversationModel>>> listConversations({
    int pageNumber = 1,
    int pageSize = 20,
  });

  Future<Either<Failure, ConversationModel>> getConversation(int id);

  Future<Either<Failure, ConversationModel>> updateConversation(
    int id,
    UpdateConversationParam param,
  );

  Future<Either<Failure, void>> deleteConversation(int id);

  Future<Either<Failure, ConversationReplyModel>> respond(
    int id,
    CreateMessageParam param,
  );

  Future<Either<Failure, ConversationMessageListModel>> listMessages(
    int id, {
    int pageSize = 50,
    String? recordId,
  });

  // ---------------------------------------------------------------------------
  // Tarot
  // ---------------------------------------------------------------------------

  Future<Either<Failure, TarotSessionModel>> createTarotDraw(
    CreateTarotDrawParam param,
  );

  Future<Either<Failure, TarotSessionModel>> getTarotDraw(int id);

  Future<Either<Failure, TarotRevealModel>> revealTarotCards(
    int id,
    RevealTarotCardsParam param,
  );

  Future<Either<Failure, TarotRevealModel>> interpretTarotCards(int id);
}
