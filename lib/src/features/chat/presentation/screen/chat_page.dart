import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_chat_core/flutter_chat_core.dart';
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:mind_insight/di_container.dart';
import 'package:mind_insight/src/core/component/components.dart';
import 'package:mind_insight/src/core/constant/app_color_resources.dart';
import 'package:mind_insight/src/core/constant/app_text_styles.dart';
import 'package:mind_insight/src/features/chat/business/param/create_tarot_draw_param.dart';
import 'package:mind_insight/src/features/chat/data/datasource/conversation_remote_datasource.dart';
import 'package:mind_insight/src/features/chat/data/model/conversation_message_model.dart';
import 'package:mind_insight/src/features/chat/presentation/provider/chat_provider.dart';
import 'package:mind_insight/src/features/chat/presentation/widget/genui/genui_registry.dart';

/// Chat page that uses [ChatProvider] for all API interactions and renders
/// dynamic GenUI widgets based on the agent's structured JSON responses.
///
/// Supports two entry modes:
/// - New conversation: pass [entryType] to start a fresh chat.
/// - Existing conversation: pass [conversationId] to load history and continue.
class ChatPage extends StatefulWidget {
  const ChatPage({
    super.key,
    this.entryType,
    this.conversationId,
    this.conversationTitle,
  });

  /// Entry type from the home page (e.g. 'daily_fortune', 'worry', etc.).
  /// Maps to the agent's `entry` context parameter.
  final String? entryType;

  /// If non-null, the page loads historical messages for this conversation
  /// and allows the user to continue chatting.
  final int? conversationId;

  /// Optional title for an existing conversation (shown in app bar).
  final String? conversationTitle;

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  static const String _currentUserId = 'user';
  static const String _assistantUserId = 'mind-insight';
  static const String _typingMessageId = '_typing_indicator_';

  late final InMemoryChatController _chatController;
  late final ChatProvider _chatProvider;

  int _messageSequence = 0;
  bool _isLoading = false;
  bool _isLoadingHistory = false;

  /// The last structured agent data — available for future follow-up actions.
  // ignore: unused_field
  Map<String, dynamic>? _lastAgentData;

  /// Whether we are resuming an existing conversation (history loaded).
  bool get _isExistingConversation => widget.conversationId != null;

  @override
  void initState() {
    super.initState();
    _chatProvider = sl<ChatProvider>();

    if (_isExistingConversation) {
      // Resuming existing conversation — start with empty list, load history
      _chatController = InMemoryChatController(messages: []);
      _chatProvider.setConversationId(widget.conversationId!);
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _loadHistoryMessages();
      });
    } else {
      // New conversation — show greeting and optionally auto-send
      _chatController = InMemoryChatController(messages: _initialMessages());
      if (widget.entryType != null) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _sendInitialMessage();
        });
      }
    }
  }

  @override
  void dispose() {
    _chatController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorResources.surface,
      appBar: _buildAppBar(),
      body: SafeArea(
        child: _isLoadingHistory
            ? const Center(child: CircularProgressIndicator())
            : Chat(
                currentUserId: _currentUserId,
                resolveUser: _resolveUser,
                chatController: _chatController,
                onMessageSend: _handleMessageSend,
                backgroundColor: ColorResources.surface,
                theme: _chatTheme(context),
                builders: Builders(customMessageBuilder: _buildCustomMessage),
              ),
      ),
    );
  }

  // ===========================================================================
  // App bar
  // ===========================================================================

  PreferredSizeWidget _buildAppBar() {
    final title = widget.conversationTitle ?? _entryTitle(widget.entryType);
    return AppBar(
      backgroundColor: ColorResources.surface,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      centerTitle: true,
      title: Text(
        title,
        style: textBoldLarge.copyWith(color: ColorResources.ink),
      ),
      leading: Navigator.canPop(context)
          ? IconButton(
              icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
              onPressed: () => Navigator.of(context).pop(),
            )
          : null,
    );
  }

  String _entryTitle(String? type) {
    return switch (type) {
      'daily_fortune' => '今日运势',
      'worry' => '最近烦恼',
      'relationship' => '关系问题',
      'career' => '事业学业',
      'choice' => '选择困难',
      'just_talk' => '只想聊聊',
      _ => '塔罗对话',
    };
  }

  // ===========================================================================
  // Initial messages & auto-send
  // ===========================================================================

  List<Message> _initialMessages() {
    final now = DateTime.now();
    final greeting = _greetingForEntryType(widget.entryType);
    return [
      Message.text(
        id: _nextMessageId(),
        authorId: _assistantUserId,
        createdAt: now.subtract(const Duration(minutes: 1)),
        text: greeting,
      ),
    ];
  }

  String _greetingForEntryType(String? type) {
    return switch (type) {
      'daily_fortune' => '让我为你抽一张今日牌，看看今天的能量和提醒。准备好了吗？',
      'worry' => '最近有什么让你放不下的事吗？可以慢慢说，我在听。',
      'relationship' => '你想看看哪段关系？可以简单说说你们现在的状态。',
      'career' => '最近是工作、学习，还是方向选择让你压力比较大？',
      'choice' => '你现在纠结的两个选择分别是什么？说出来我们一起看看。',
      'just_talk' => '今天不一定要抽牌，我们可以只是聊聊。你想说点什么？',
      _ => '你好，我是你的塔罗向导。告诉我你想探索的问题吧。',
    };
  }

  /// For `daily_fortune`, auto-send the initial message to skip user input.
  Future<void> _sendInitialMessage() async {
    final initialMessage = _autoMessageForEntry(widget.entryType);
    if (initialMessage == null) return;

    // Insert as user bubble
    _chatController.insertMessage(
      Message.text(
        id: _nextMessageId(),
        authorId: _currentUserId,
        createdAt: DateTime.now(),
        sentAt: DateTime.now(),
        text: initialMessage,
      ),
    );
    await _sendToAgent(initialMessage);
  }

  /// Only some entries auto-send an initial message.
  String? _autoMessageForEntry(String? type) {
    return switch (type) {
      'daily_fortune' => '我想看看今日运势',
      _ => null,
    };
  }

  // ===========================================================================
  // History loading — for existing conversations
  // ===========================================================================

  Future<void> _loadHistoryMessages() async {
    setState(() => _isLoadingHistory = true);

    final datasource = sl<ConversationRemoteDatasource>();
    final result = await datasource.listMessages(widget.conversationId!);

    if (!mounted) return;

    result.fold(
      (failure) {
        _insertAssistantText('⚠️ 无法加载历史消息');
      },
      (data) {
        final messages = data.messages;
        for (int i = 0; i < messages.length; i++) {
          final msg = messages[i];
          final isLast = i == messages.length - 1;
          _renderHistoryMessage(
            msg,
            isLastAssistant: isLast && msg.role == 'assistant',
          );
        }
      },
    );

    setState(() => _isLoadingHistory = false);
  }

  /// Render a single historical message using the same GenUI logic.
  void _renderHistoryMessage(
    ConversationMessageModel msg, {
    bool isLastAssistant = false,
  }) {
    final time = msg.dateTime ?? DateTime.now();

    if (msg.role == 'user') {
      // User messages: only show if it's plain human text (skip system JSON payloads)
      final content = msg.content;
      if (content.isEmpty) return;
      // Skip internal JSON events sent as user messages (e.g. tarot_cards_revealed)
      if (_isInternalEvent(content)) return;
      _chatController.insertMessage(
        Message.text(
          id: _nextMessageId(),
          authorId: _currentUserId,
          createdAt: time,
          sentAt: time,
          text: content,
        ),
      );
    } else {
      // Assistant messages: parse content same as live responses
      _renderAssistantContent(
        msg.content,
        at: time,
        interactive: isLastAssistant,
      );
    }
  }

  /// Check if a user message content is an internal system event (JSON payload
  /// sent to the agent, not something the user typed).
  bool _isInternalEvent(String content) {
    if (!content.trimLeft().startsWith('{')) return false;
    try {
      final parsed = jsonDecode(content) as Map<String, dynamic>;
      return parsed.containsKey('event') || parsed.containsKey('instruction');
    } catch (_) {
      return false;
    }
  }

  /// Unified rendering for assistant content (used by both history and live).
  void _renderAssistantContent(
    String content, {
    DateTime? at,
    bool interactive = true,
  }) {
    if (content.isEmpty) return;
    final time = at ?? DateTime.now();

    final cleaned = _stripMarkdownCodeBlock(content);
    Map<String, dynamic>? parsedData;
    try {
      parsedData = jsonDecode(cleaned) as Map<String, dynamic>;
    } catch (_) {
      // Plain text
      _insertAssistantText(content, at: time);
      return;
    }

    if (parsedData['type'] == 'tarot_ui') {
      if (interactive) _lastAgentData = parsedData;
      final uiView = GenUiRegistry.surfaceKey(parsedData);

      if (uiView == 'plain_message' || uiView == 'clarify_question') {
        final msg = parsedData['message'] as String? ?? '';
        if (msg.isNotEmpty) {
          _insertAssistantText(msg, at: time);
        }
      } else {
        // For history messages that are not the last, mark as read-only
        if (!interactive) {
          parsedData = Map<String, dynamic>.from(parsedData);
          parsedData['_readOnly'] = true;
        }
        _insertGenUiMessage(parsedData, at: time);
      }
    } else {
      final msg = parsedData['message'] as String?;
      if (msg != null && msg.isNotEmpty) {
        _insertAssistantText(msg, at: time);
      }
    }
  }

  // ===========================================================================
  // User actions
  // ===========================================================================

  void _handleMessageSend(String text) {
    final trimmedText = text.trim();
    if (trimmedText.isEmpty || _isLoading) return;

    final now = DateTime.now();
    _chatController.insertMessage(
      Message.text(
        id: _nextMessageId(),
        authorId: _currentUserId,
        createdAt: now,
        sentAt: now,
        text: trimmedText,
      ),
    );

    _sendToAgent(trimmedText);
  }

  // ===========================================================================
  // Agent API call — uses ChatProvider
  // ===========================================================================

  Future<void> _sendToAgent(String message) async {
    setState(() => _isLoading = true);
    _showTypingIndicator();

    // Pass entryType only on the first message (when no conversation exists yet)
    final isFirstMessage = _chatProvider.currentConversationId == null;
    await _chatProvider.sendMessage(
      message: message,
      agentType: 'tarot',
      entryType: isFirstMessage ? widget.entryType : null,
    );

    if (!mounted) return;

    _hideTypingIndicator();

    if (_chatProvider.errorMessage != null) {
      _insertAssistantText('⚠️ ${_chatProvider.errorMessage}');
    } else if (_chatProvider.lastAgentResponse != null) {
      final response = _chatProvider.lastAgentResponse!;
      _processAgentResponse(response, response.timestamp);
    }

    setState(() => _isLoading = false);
  }

  /// Parse the `AgentChatModel.messages` list from the backend.
  ///
  /// Structure: Messages[].Contents[].Text (which is a JSON-encoded Map
  /// or already a Map depending on backend serialization).
  void _processAgentResponse(dynamic agentResponse, DateTime? serverTime) {
    final messages = agentResponse.messages as List<dynamic>? ?? [];
    final time = serverTime ?? DateTime.now();

    for (final msg in messages) {
      final msgMap = msg as Map<String, dynamic>;
      final contents = msgMap['Contents'] as List<dynamic>? ?? [];

      for (final content in contents) {
        final contentMap = content as Map<String, dynamic>;
        final contentType = contentMap['Type'] as String? ?? '';

        if (contentType == 'text') {
          final textField = contentMap['Text'];
          Map<String, dynamic>? parsedData;

          // Text can be a Map (already parsed) or a JSON string
          if (textField is Map<String, dynamic>) {
            parsedData = textField;
          } else if (textField is String) {
            // Strip markdown code fences if present (```json ... ```)
            final cleaned = _stripMarkdownCodeBlock(textField);
            try {
              parsedData = jsonDecode(cleaned) as Map<String, dynamic>;
            } catch (_) {
              // Plain text, not structured JSON
              _insertAssistantText(textField, at: time);
              continue;
            }
          }

          if (parsedData != null && parsedData['type'] == 'tarot_ui') {
            _lastAgentData = parsedData;
            final uiView = GenUiRegistry.surfaceKey(parsedData);

            // Plain text responses → insert as normal text message (shows time)
            if (uiView == 'plain_message' || uiView == 'clarify_question') {
              final msg = parsedData['message'] as String? ?? '';
              if (msg.isNotEmpty) {
                _insertAssistantText(msg, at: time);
              }
            } else {
              // Interactive GenUI components → insert as custom message
              _insertGenUiMessage(parsedData, at: time);
            }
          } else if (parsedData != null) {
            // Unknown structured type — show message field if present
            final msg = parsedData['message'] as String?;
            if (msg != null && msg.isNotEmpty) {
              _insertAssistantText(msg, at: time);
            }
          }
        }
      }
    }
  }

  // ===========================================================================
  // GenUI action handler — orchestrates the tarot flow
  // ===========================================================================

  void _handleGenUiAction(
    Map<String, dynamic> action,
    Map<String, dynamic> data,
  ) {
    final actionType = action['type'] as String? ?? '';
    switch (actionType) {
      case 'start_draw':
        _handleStartDraw(action, data);
        break;
      case 'reveal_cards':
        _handleRevealCards(action, data);
        break;
      case 'continue_chat':
        // No-op — just let user keep typing
        break;
      case 'end_draw':
        _handleEndDraw();
        break;
      default:
        break;
    }
  }

  /// Create a tarot draw session, then show the card shuffle widget.
  Future<void> _handleStartDraw(
    Map<String, dynamic> action,
    Map<String, dynamic> data,
  ) async {
    setState(() => _isLoading = true);

    final innerData = data['data'] as Map<String, dynamic>? ?? {};
    final spread =
        innerData['recommended_spread'] as Map<String, dynamic>? ?? {};
    final payload = action['payload'] as Map<String, dynamic>? ?? {};
    final requiredCards =
        spread['required_cards'] as int? ??
        payload['required_cards'] as int? ??
        1;
    final positions =
        (spread['positions'] as List<dynamic>?)
            ?.map((e) => e.toString())
            .toList() ??
        ['此刻最需要看见的部分'];

    // Build draw param from the agent response data
    final param = CreateTarotDrawParam(
      conversationId:
          (payload['conversation_id'] as int?) ??
          _chatProvider.currentConversationId ??
          0,
      question: innerData['question_summary'] as String? ?? '',
      questionSummary: innerData['question_summary'] as String?,
      topic: innerData['topic'] as String?,
      spreadType:
          (payload['spread_id'] as String?) ??
          (spread['id'] as String?) ??
          'single_card',
      spreadName: spread['name'] as String?,
      requiredCards: requiredCards,
      guidance: data['message'] as String?,
      positions: positions,
      allowReversed: true,
      // Agent metadata from the chat response
      agentRecordId: _chatProvider.lastAgentResponse?.recordId,
      agentConversationId: _chatProvider.lastAgentResponse?.conversationId,
      agentRelatedRecordId: _chatProvider.lastAgentResponse?.relatedRecordId,
      agentMessageId: _chatProvider.lastAgentResponse?.messageId,
      agentStage: data['stage'] as String?,
      agentUiView: GenUiRegistry.surfaceKey(data),
      agentLanguage: data['language'] as String?,
      agentActions: data['actions'] as List<dynamic>?,
      agentText: data,
    );

    await _chatProvider.createTarotDraw(param);

    if (!mounted) return;

    if (_chatProvider.errorMessage != null) {
      _insertAssistantText('⚠️ ${_chatProvider.errorMessage}');
    } else if (_chatProvider.currentTarotSession != null) {
      final session = _chatProvider.currentTarotSession!;
      // Insert the card shuffle widget
        _insertGenUiMessage({
        'stage': 'card_shuffle',
        'message': '请选择你的牌',
        'requiredCards': session.requiredCards,
        'spreadName': session.spreadName ?? param.spreadName,
        'positions': param.positions,
        'tarotSessionId': session.id,
      });
    }

    setState(() => _isLoading = false);
  }

  /// Reveal the selected cards.
  /// Reveal the selected cards — backend returns cards + interpretation directly.
  Future<void> _handleRevealCards(
    Map<String, dynamic> action,
    Map<String, dynamic> data,
  ) async {
    setState(() => _isLoading = true);

    final payload = action['payload'] as Map<String, dynamic>? ?? {};
    final sessionId =
        (payload['tarot_session_id'] as int?) ??
        data['tarotSessionId'] as int? ??
        _chatProvider.currentTarotSession?.id ??
        0;
    final selectedIndexes =
        (data['selectedIndexes'] as List<dynamic>?)
            ?.map((e) => e as int)
            .toList() ??
        [];

    await _chatProvider.revealCards(
      tarotSessionId: sessionId,
      selectedIndexes: selectedIndexes,
    );

    if (!mounted) return;

    if (_chatProvider.errorMessage != null) {
      _insertAssistantText('⚠️ ${_chatProvider.errorMessage}');
    } else if (_chatProvider.lastReveal != null) {
      final reveal = _chatProvider.lastReveal!;

      // Reveal API returns cards + interpretation in one shot
      if (reveal.hasStructuredInterpretation) {
        final interpMap = reveal.interpretationMap!;
        _lastAgentData = interpMap;
        _insertGenUiMessage(interpMap);
      } else {
        // Fallback: show cards without full interpretation
        _insertGenUiMessage({
          'stage': 'draw_result_ready',
          'message': '牌已翻开',
          'data': {
            'status': 'draw_ready',
            'cards': reveal.cards
                .map(
                  (c) => {
                    'name': c.card,
                    'orientation': c.orientation,
                    'position': c.slot,
                  },
                )
                .toList(),
          },
          'actions': [
            {
              'id': 'continue_chat',
              'type': 'continue_chat',
              'label': '继续聊聊',
              'payload': {},
            },
            {
              'id': 'end_draw',
              'type': 'end_draw',
              'label': '先到这里',
              'payload': {},
            },
          ],
        });
      }
    }

    setState(() => _isLoading = false);
  }

  /// End the current draw — reset conversation state for a fresh start.
  void _handleEndDraw() {
    _chatProvider.resetConversation();
    _insertAssistantText('本次塔罗体验到此结束。如果你还想聊聊或再抽一次牌，随时告诉我。');
  }

  // ===========================================================================
  // Message insertion helpers
  // ===========================================================================

  void _showTypingIndicator() {
    _chatController.insertMessage(
      Message.custom(
        id: _typingMessageId,
        authorId: _assistantUserId,
        createdAt: DateTime.now(),
        metadata: {'ui_view': '_typing'},
      ),
    );
  }

  void _hideTypingIndicator() {
    try {
      _chatController.removeMessage(
        Message.custom(
          id: _typingMessageId,
          authorId: _assistantUserId,
          createdAt: DateTime.now(),
          metadata: {},
        ),
      );
    } catch (_) {
      // Already removed or not present
    }
  }

  void _insertAssistantText(String text, {DateTime? at}) {
    _chatController.insertMessage(
      Message.text(
        id: _nextMessageId(),
        authorId: _assistantUserId,
        createdAt: at ?? DateTime.now(),
        text: text,
      ),
    );
  }

  void _insertGenUiMessage(Map<String, dynamic> data, {DateTime? at}) {
    _chatController.insertMessage(
      Message.custom(
        id: _nextMessageId(),
        authorId: _assistantUserId,
        createdAt: at ?? DateTime.now(),
        metadata: data,
      ),
    );
  }

  // ===========================================================================
  // Custom message builder — delegates to GenUI registry
  // ===========================================================================

  Widget _buildCustomMessage(
    BuildContext context,
    CustomMessage message,
    int index, {
    required bool isSentByMe,
    MessageGroupStatus? groupStatus,
  }) {
    final metadata = message.metadata ?? {};
    final uiView = GenUiRegistry.surfaceKey(metadata);

    // Typing indicator
    if (uiView == '_typing') {
      return _buildTypingBubble();
    }

    final readOnly = metadata['_readOnly'] == true;
    return GenUiRegistry.build(
      data: metadata,
      onAction: readOnly ? _noOpAction : _handleGenUiAction,
    );
  }

  Widget _buildTypingBubble() {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 12),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: ColorResources.border),
        ),
        child: const IsTypingIndicator(
          size: 8,
          spacing: 4,
          color: ColorResources.muted,
        ),
      ),
    );
  }

  /// No-op action callback for read-only historical messages.
  void _noOpAction(Map<String, dynamic> action, Map<String, dynamic> data) {
    // Historical messages — actions are disabled.
  }

  // ===========================================================================
  // Helpers
  // ===========================================================================

  /// Strip markdown code block fences (```json ... ``` or ``` ... ```).
  String _stripMarkdownCodeBlock(String text) {
    final trimmed = text.trim();
    if (!trimmed.startsWith('```')) return trimmed;
    // Remove opening fence (```json or ```)
    var start = trimmed.indexOf('\n');
    if (start == -1) return trimmed;
    start += 1;
    // Remove closing fence
    var end = trimmed.lastIndexOf('```');
    if (end <= start) end = trimmed.length;
    return trimmed.substring(start, end).trim();
  }

  Future<User?> _resolveUser(String id) async {
    return switch (id) {
      _currentUserId => const User(id: _currentUserId, name: 'You'),
      _assistantUserId => const User(
        id: _assistantUserId,
        name: 'Mind Insight',
      ),
      _ => null,
    };
  }

  String _nextMessageId() {
    _messageSequence += 1;
    return 'msg-$_messageSequence-${DateTime.now().microsecondsSinceEpoch}';
  }

  ChatTheme _chatTheme(BuildContext context) {
    final baseTypography = ChatTypography.fromThemeData(Theme.of(context));
    return ChatTheme(
      colors: const ChatColors(
        primary: AppColors.primary,
        onPrimary: Colors.white,
        surface: AppColors.surface,
        onSurface: AppColors.ink,
        surfaceContainerLow: Color(0xFFFFF8EF),
        surfaceContainer: Colors.white,
        surfaceContainerHigh: AppColors.primarySoft,
      ),
      typography: baseTypography,
      shape: const BorderRadius.all(Radius.circular(8)),
    );
  }
}
