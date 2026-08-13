import 'package:flutter/foundation.dart';

import '../../business/param/agent_chat_param.dart';
import '../../business/param/create_tarot_draw_param.dart';
import '../../business/param/reveal_tarot_cards_param.dart';
import '../../business/usecase/chat_with_agent_usecase.dart';
import '../../business/usecase/create_tarot_draw_usecase.dart';
import '../../business/usecase/interpret_tarot_cards_usecase.dart';
import '../../business/usecase/reveal_tarot_cards_usecase.dart';
import '../../data/model/agent_chat_model.dart';
import '../../data/model/tarot_reveal_model.dart';
import '../../data/model/tarot_session_model.dart';

/// ViewModel for the Chat feature.
///
/// Manages agent chat, tarot draws, and conversation state.
class ChatProvider extends ChangeNotifier {
  final ChatWithAgentUseCase _chatWithAgentUseCase;
  final CreateTarotDrawUseCase _createTarotDrawUseCase;
  final RevealTarotCardsUseCase _revealTarotCardsUseCase;
  final InterpretTarotCardsUseCase _interpretTarotCardsUseCase;

  ChatProvider({
    required ChatWithAgentUseCase chatWithAgentUseCase,
    required CreateTarotDrawUseCase createTarotDrawUseCase,
    required RevealTarotCardsUseCase revealTarotCardsUseCase,
    required InterpretTarotCardsUseCase interpretTarotCardsUseCase,
  }) : _chatWithAgentUseCase = chatWithAgentUseCase,
       _createTarotDrawUseCase = createTarotDrawUseCase,
       _revealTarotCardsUseCase = revealTarotCardsUseCase,
       _interpretTarotCardsUseCase = interpretTarotCardsUseCase;

  // ---------------------------------------------------------------------------
  // State
  // ---------------------------------------------------------------------------

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  AgentChatModel? _lastAgentResponse;
  AgentChatModel? get lastAgentResponse => _lastAgentResponse;

  TarotSessionModel? _currentTarotSession;
  TarotSessionModel? get currentTarotSession => _currentTarotSession;

  TarotRevealModel? _lastReveal;
  TarotRevealModel? get lastReveal => _lastReveal;

  int? _currentConversationId;
  int? get currentConversationId => _currentConversationId;

  // ---------------------------------------------------------------------------
  // Agent Actions
  // ---------------------------------------------------------------------------

  /// Send a message to the AI agent.
  Future<void> sendMessage({
    required String message,
    String? agentType,
    String? title,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    _notify();

    final param = AgentChatParam(
      conversationId: _currentConversationId,
      agentType: agentType,
      title: title,
      message: message,
    );

    final result = await _chatWithAgentUseCase.call(param);

    result.fold(
      (failure) {
        _errorMessage = failure.errorMessage ?? 'Something went wrong';
      },
      (response) {
        _lastAgentResponse = response;
        if (response.localConversationId != 0) {
          _currentConversationId = response.localConversationId;
        }
      },
    );

    _isLoading = false;
    _notify();
  }

  // ---------------------------------------------------------------------------
  // Tarot Actions
  // ---------------------------------------------------------------------------

  /// Create a new tarot draw session.
  Future<void> createTarotDraw(CreateTarotDrawParam param) async {
    _isLoading = true;
    _errorMessage = null;
    _notify();

    final result = await _createTarotDrawUseCase.call(param);

    result.fold(
      (failure) {
        _errorMessage = failure.errorMessage ?? 'Failed to create draw';
      },
      (session) {
        _currentTarotSession = session;
      },
    );

    _isLoading = false;
    _notify();
  }

  /// Reveal selected tarot cards.
  Future<void> revealCards({
    required int tarotSessionId,
    required List<int> selectedIndexes,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    _notify();

    final result = await _revealTarotCardsUseCase.call(
      RevealTarotCardsParam(
        tarotSessionId: tarotSessionId,
        selectedIndexes: selectedIndexes,
      ),
    );

    result.fold(
      (failure) {
        _errorMessage = failure.errorMessage ?? 'Failed to reveal cards';
      },
      (reveal) {
        _lastReveal = reveal;
      },
    );

    _isLoading = false;
    _notify();
  }

  /// Interpret the revealed tarot cards.
  Future<void> interpretCards(int tarotSessionId) async {
    _isLoading = true;
    _errorMessage = null;
    _notify();

    final result = await _interpretTarotCardsUseCase.call(tarotSessionId);

    result.fold(
      (failure) {
        _errorMessage = failure.errorMessage ?? 'Failed to interpret cards';
      },
      (reveal) {
        _lastReveal = reveal;
      },
    );

    _isLoading = false;
    _notify();
  }

  // ---------------------------------------------------------------------------
  // Lifecycle
  // ---------------------------------------------------------------------------

  /// Start a new conversation (clears all state).
  void resetConversation() {
    _currentConversationId = null;
    _lastAgentResponse = null;
    _currentTarotSession = null;
    _lastReveal = null;
    _errorMessage = null;
    _notify();
  }

  void _notify() {
    notifyListeners();
  }
}
