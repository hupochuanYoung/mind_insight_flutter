import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_core/flutter_chat_core.dart';
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:mind_insight/src/core/component/components.dart';
import 'package:mind_insight/src/core/constant/app_constants.dart';
import 'package:mind_insight/src/core/data/dio/dio_client.dart';
import 'package:mind_insight/src/core/data/dio/logging_interceptor.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  static const String _currentUserId = 'user';
  static const String _assistantUserId = 'mind-insight';

  late final InMemoryChatController _chatController;
  late final DioClient _dioClient;

  int _messageSequence = 0;
  String? _sessionId;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _chatController = InMemoryChatController(messages: _initialMessages());
    _dioClient = DioClient(
      AppConstants.envConfig.agentBaseUrl,
      loggingInterceptor: LoggingInterceptor(),
    );
  }

  @override
  void dispose() {
    _chatController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          const _ChatHeader(),
          _PromptStrip(onPromptTap: _handlePromptTap),
          Expanded(
            child: Chat(
              currentUserId: _currentUserId,
              resolveUser: _resolveUser,
              chatController: _chatController,
              onMessageSend: _handleMessageSend,
              backgroundColor: AppColors.surface,
              theme: _chatTheme(context),
              builders: Builders(customMessageBuilder: _buildCustomMessage),
            ),
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Initial messages
  // ---------------------------------------------------------------------------

  List<Message> _initialMessages() {
    final now = DateTime.now();
    return [
      Message.text(
        id: _nextMessageId(),
        authorId: _assistantUserId,
        createdAt: now.subtract(const Duration(minutes: 1)),
        text: '你好，我是你的塔罗向导。告诉我你想探索的问题，或者点击上方的提示开始。',
      ),
    ];
  }

  // ---------------------------------------------------------------------------
  // User actions
  // ---------------------------------------------------------------------------

  void _handlePromptTap(String prompt) {
    _handleMessageSend(prompt);
  }

  void _handleMessageSend(String text) {
    final trimmedText = text.trim();
    if (trimmedText.isEmpty || _isLoading) return;

    final now = DateTime.now();

    // Insert user message
    _chatController.insertMessage(
      Message.text(
        id: _nextMessageId(),
        authorId: _currentUserId,
        createdAt: now,
        sentAt: now,
        text: trimmedText,
      ),
    );

    // Call agent API
    _sendToAgent(trimmedText);
  }

  // ---------------------------------------------------------------------------
  // Agent API call
  // ---------------------------------------------------------------------------

  Future<void> _sendToAgent(String message) async {
    setState(() => _isLoading = true);

    try {
      final response = await _dioClient.post(
        AppConstants.chatUri,
        data: {
          'message': message,
          'user_id': _currentUserId,
          if (_sessionId != null) 'session_id': _sessionId,
        },
      );

      final data = response.data as Map<String, dynamic>;
      _sessionId = data['session_id'] as String?;
      final replies = data['replies'] as List<dynamic>? ?? [];

      final now = DateTime.now();

      for (final reply in replies) {
        final replyMap = reply as Map<String, dynamic>;
        final type = replyMap['type'] as String;
        final content = replyMap['content'];

        switch (type) {
          case 'text':
            _chatController.insertMessage(
              Message.text(
                id: _nextMessageId(),
                authorId: _assistantUserId,
                createdAt: now,
                text: content as String,
              ),
            );
          case 'genui':
            _chatController.insertMessage(
              Message.custom(
                id: _nextMessageId(),
                authorId: _assistantUserId,
                createdAt: now,
                metadata: content as Map<String, dynamic>,
              ),
            );
          case 'error':
            _chatController.insertMessage(
              Message.text(
                id: _nextMessageId(),
                authorId: _assistantUserId,
                createdAt: now,
                text: '⚠️ $content',
              ),
            );
        }
      }
    } on DioException catch (e) {
      _chatController.insertMessage(
        Message.text(
          id: _nextMessageId(),
          authorId: _assistantUserId,
          createdAt: DateTime.now(),
          text: '⚠️ 无法连接到服务：${e.message}',
        ),
      );
    } catch (e) {
      _chatController.insertMessage(
        Message.text(
          id: _nextMessageId(),
          authorId: _assistantUserId,
          createdAt: DateTime.now(),
          text: '⚠️ 发生错误：$e',
        ),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  // ---------------------------------------------------------------------------
  // Custom message builder — renders GenUI components
  // ---------------------------------------------------------------------------

  Widget _buildCustomMessage(
    BuildContext context,
    CustomMessage message,
    int index, {
    required bool isSentByMe,
    MessageGroupStatus? groupStatus,
  }) {
    final metadata = message.metadata ?? {};
    final component = metadata['component'] as String? ?? '';

    return switch (component) {
      'card_spread' => _CardSpreadWidget(
        metadata: metadata,
        onPositionTap: _handleCardPositionTap,
      ),
      'card_reveal' => _CardRevealWidget(metadata: metadata),
      _ => const SizedBox.shrink(),
    };
  }

  void _handleCardPositionTap(int positionIndex, String label) {
    // Send a message to the agent to reveal this card
    _handleMessageSend('翻开第${positionIndex + 1}张牌（$label）');
  }

  // ---------------------------------------------------------------------------
  // Helpers
  // ---------------------------------------------------------------------------

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

// =============================================================================
// GenUI Component: Card Spread (牌阵选择)
// =============================================================================

class _CardSpreadWidget extends StatelessWidget {
  const _CardSpreadWidget({
    required this.metadata,
    required this.onPositionTap,
  });

  final Map<String, dynamic> metadata;
  final void Function(int index, String label) onPositionTap;

  @override
  Widget build(BuildContext context) {
    final positions = (metadata['positions'] as List<dynamic>?) ?? [];

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF8EF),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.auto_awesome_rounded,
                size: 18,
                color: AppColors.primary,
              ),
              const SizedBox(width: 8),
              Text(
                '牌阵准备就绪',
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w800,
                  color: AppColors.ink,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            '点击牌位来翻开你的牌',
            style: Theme.of(
              context,
            ).textTheme.bodySmall?.copyWith(color: AppColors.muted),
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              for (final pos in positions)
                _buildCardBack(context, pos as Map<String, dynamic>),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCardBack(BuildContext context, Map<String, dynamic> pos) {
    final index = pos['index'] as int;
    final label = pos['label'] as String? ?? '';
    final state = pos['state'] as String? ?? 'hidden';

    return GestureDetector(
      onTap: state == 'hidden' ? () => onPositionTap(index, label) : null,
      child: Column(
        children: [
          Container(
            width: 72,
            height: 120,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: AppColors.primary.withValues(alpha: 0.6),
                width: 2,
              ),
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFF2D1B69), Color(0xFF4A2C8A)],
              ),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x30000000),
                  blurRadius: 8,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: const Center(
              child: Icon(
                Icons.auto_awesome,
                color: Color(0xFFFFF3C9),
                size: 28,
              ),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            label,
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: AppColors.muted,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

// =============================================================================
// GenUI Component: Card Reveal (翻牌结果)
// =============================================================================

class _CardRevealWidget extends StatelessWidget {
  const _CardRevealWidget({required this.metadata});

  final Map<String, dynamic> metadata;

  @override
  Widget build(BuildContext context) {
    final card = metadata['card'] as Map<String, dynamic>? ?? {};
    final positionLabel = metadata['position_label'] as String? ?? '';
    final cardName = card['name'] as String? ?? '';
    final orientation = card['orientation'] as String? ?? 'upright';
    final imageIndex = card['image_index'] as int? ?? 1;

    final isReversed = orientation == 'reversed';
    final assetPath = TarotAssets.card(imageIndex);

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
        boxShadow: const [
          BoxShadow(
            color: Color(0x15000000),
            blurRadius: 12,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TarotCardView(
            assetPath: assetPath,
            width: 72,
            height: 120,
            angle: isReversed ? 3.14159 : 0,
            borderColor: AppColors.primary.withValues(alpha: 0.5),
            borderWidth: 2,
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 3,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.primarySoft,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    positionLabel,
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  cardName,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  isReversed ? '逆位' : '正位',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: isReversed ? Colors.deepOrange : AppColors.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// =============================================================================
// Chat Header
// =============================================================================

class _ChatHeader extends StatelessWidget {
  const _ChatHeader();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 12),
      child: Row(
        children: [
          const AppIconBadge(
            icon: Icons.auto_awesome_rounded,
            backgroundColor: AppColors.primary,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Tarot Chat',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w900,
                    letterSpacing: 0,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'Ask, reflect, and shape the next reading.',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.muted,
                    letterSpacing: 0,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// =============================================================================
// Prompt Strip
// =============================================================================

class _PromptStrip extends StatelessWidget {
  const _PromptStrip({required this.onPromptTap});

  final void Function(String prompt) onPromptTap;

  static const List<_PromptAction> _prompts = [
    _PromptAction(
      icon: Icons.favorite_border_rounded,
      label: '感情',
      message: '我想了解最近的感情状况',
    ),
    _PromptAction(
      icon: Icons.work_outline_rounded,
      label: '事业',
      message: '我想看看事业发展方向',
    ),
    _PromptAction(
      icon: Icons.bolt_rounded,
      label: '能量',
      message: '我想了解当前的能量状态',
    ),
    _PromptAction(
      icon: Icons.visibility_outlined,
      label: '阴影',
      message: '帮我看看需要面对的阴影面',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 46,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        scrollDirection: Axis.horizontal,
        itemCount: _prompts.length,
        separatorBuilder: (_, _) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final prompt = _prompts[index];

          return ActionChip(
            avatar: Icon(prompt.icon, size: 18, color: AppColors.primary),
            label: Text(prompt.label),
            backgroundColor: AppColors.card,
            side: const BorderSide(color: AppColors.border),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            labelStyle: const TextStyle(
              color: AppColors.ink,
              fontWeight: FontWeight.w700,
            ),
            onPressed: () => onPromptTap(prompt.message),
          );
        },
      ),
    );
  }
}

class _PromptAction {
  const _PromptAction({
    required this.icon,
    required this.label,
    required this.message,
  });

  final IconData icon;
  final String label;
  final String message;
}
