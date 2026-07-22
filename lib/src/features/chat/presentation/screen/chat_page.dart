import 'package:flutter/material.dart';
import 'package:flutter_chat_core/flutter_chat_core.dart';
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:mind_insight/src/core/component/components.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  static const String _currentUserId = 'user';
  static const String _assistantUserId = 'mind-insight';

  late final InMemoryChatController _chatController;

  int _messageSequence = 0;

  @override
  void initState() {
    super.initState();
    _chatController = InMemoryChatController(messages: _initialMessages());
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
          const _PromptStrip(),
          Expanded(
            child: Chat(
              currentUserId: _currentUserId,
              resolveUser: _resolveUser,
              chatController: _chatController,
              onMessageSend: _handleMessageSend,
              backgroundColor: AppColors.surface,
              theme: _chatTheme(context),
            ),
          ),
        ],
      ),
    );
  }

  List<Message> _initialMessages() {
    final now = DateTime.now();

    return [
      Message.text(
        id: _nextMessageId(),
        authorId: _assistantUserId,
        createdAt: now.subtract(const Duration(minutes: 2)),
        text:
            'Hi, I am your tarot guide. Ask a question, or choose one of the prompts above to begin.',
      ),
      Message.text(
        id: _nextMessageId(),
        authorId: _assistantUserId,
        createdAt: now.subtract(const Duration(minutes: 1)),
        text:
            'For now this chat uses local mock replies. Later we can connect GenUI so readings appear as structured tarot components.',
      ),
    ];
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

  void _handleMessageSend(String text) {
    final trimmedText = text.trim();
    if (trimmedText.isEmpty) return;

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

    _chatController.insertMessage(
      Message.text(
        id: _nextMessageId(),
        authorId: _assistantUserId,
        createdAt: now.add(const Duration(milliseconds: 350)),
        text:
            'I hear: "$trimmedText". When GenUI is connected, this reply can become a tarot spread, card detail, or follow-up choice component.',
      ),
    );
  }

  String _nextMessageId() {
    _messageSequence += 1;
    return 'message-$_messageSequence-${DateTime.now().microsecondsSinceEpoch}';
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

class _PromptStrip extends StatelessWidget {
  const _PromptStrip();

  static const List<_PromptAction> _prompts = [
    _PromptAction(icon: Icons.favorite_border_rounded, label: 'Love'),
    _PromptAction(icon: Icons.work_outline_rounded, label: 'Career'),
    _PromptAction(icon: Icons.bolt_rounded, label: 'Energy'),
    _PromptAction(icon: Icons.visibility_outlined, label: 'Shadow'),
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
            onPressed: () {},
          );
        },
      ),
    );
  }
}

class _PromptAction {
  const _PromptAction({required this.icon, required this.label});

  final IconData icon;
  final String label;
}
