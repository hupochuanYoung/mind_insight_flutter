import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mind_insight/di_container.dart';
import 'package:mind_insight/src/core/constant/app_color_resources.dart';
import 'package:mind_insight/src/core/constant/app_dimensions.dart';
import 'package:mind_insight/src/core/constant/app_text_styles.dart';
import 'package:mind_insight/src/core/route/app_router.dart';
import 'package:mind_insight/src/features/chat/data/datasource/conversation_remote_datasource.dart';
import 'package:mind_insight/src/features/chat/data/model/conversation_model.dart';

/// Chat History screen — displays a list of previous conversations.
class ChatHistoryScreen extends StatefulWidget {
  const ChatHistoryScreen({super.key});

  @override
  State<ChatHistoryScreen> createState() => _ChatHistoryScreenState();
}

class _ChatHistoryScreenState extends State<ChatHistoryScreen> {
  bool _isLoading = true;
  String? _error;
  List<ConversationModel> _conversations = [];

  @override
  void initState() {
    super.initState();
    _loadConversations();
  }

  Future<void> _loadConversations() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    final result = await sl<ConversationRemoteDatasource>().listConversations();

    if (!mounted) return;

    result.fold(
      (failure) {
        setState(() {
          _error = failure.errorMessage ?? 'Failed to load history';
          _isLoading = false;
        });
      },
      (conversations) {
        setState(() {
          _conversations = conversations;
          _isLoading = false;
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorResources.surface,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
          color: ColorResources.ink,
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'Chat History',
          style: textBoldLarge.copyWith(color: ColorResources.ink),
        ),
        centerTitle: true,
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_error != null) {
      return _buildErrorState();
    }

    if (_conversations.isEmpty) {
      return _buildEmptyState();
    }

    return RefreshIndicator(
      onRefresh: _loadConversations,
      color: ColorResources.primary,
      child: ListView.separated(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 32),
        itemCount: _conversations.length,
        separatorBuilder: (_, i) => const SizedBox(height: 10),
        itemBuilder: (context, index) {
          return _ConversationCard(
            conversation: _conversations[index],
            onTap: () => _openConversation(_conversations[index]),
          );
        },
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(40),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                color: ColorResources.primarySoft,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.chat_bubble_outline_rounded,
                size: 32,
                color: ColorResources.primary,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'No conversations yet',
              style: textBoldLarge.copyWith(color: ColorResources.ink),
            ),
            const SizedBox(height: 8),
            Text(
              'Start a reading to see your conversation history here.',
              textAlign: TextAlign.center,
              style: textRegular.copyWith(color: ColorResources.muted),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(40),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.error_outline_rounded,
              size: 48,
              color: ColorResources.error,
            ),
            const SizedBox(height: 16),
            Text(
              _error!,
              textAlign: TextAlign.center,
              style: textRegular.copyWith(color: ColorResources.muted),
            ),
            const SizedBox(height: 20),
            FilledButton.icon(
              onPressed: _loadConversations,
              icon: const Icon(Icons.refresh_rounded, size: 18),
              label: const Text('Retry'),
              style: FilledButton.styleFrom(
                backgroundColor: ColorResources.primary,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _openConversation(ConversationModel conversation) {
    context.push('${RouteUri.chatSession}?type=${conversation.type}');
  }
}

// =============================================================================
// Conversation Card Widget
// =============================================================================

class _ConversationCard extends StatelessWidget {
  const _ConversationCard({required this.conversation, required this.onTap});

  final ConversationModel conversation;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: ColorResources.card,
      borderRadius: BorderRadius.circular(Dimensions.radiusLarge),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(Dimensions.radiusLarge),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(Dimensions.radiusLarge),
            border: Border.all(color: ColorResources.border),
          ),
          child: Row(
            children: [
              // Type icon
              _buildTypeIcon(),
              const SizedBox(width: 14),
              // Content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      conversation.title.isNotEmpty
                          ? conversation.title
                          : _typeLabel(conversation.type),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: textMedium.copyWith(color: ColorResources.ink),
                    ),
                    if (conversation.lastMessagePreview != null &&
                        conversation.lastMessagePreview!.isNotEmpty) ...[
                      const SizedBox(height: 4),
                      Text(
                        conversation.lastMessagePreview!,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: textSmall.copyWith(color: ColorResources.muted),
                      ),
                    ],
                    const SizedBox(height: 6),
                    Text(
                      _formatDate(conversation.createdAt),
                      style: TextStyle(
                        fontSize: 11,
                        color: ColorResources.muted.withValues(alpha: 0.7),
                      ),
                    ),
                  ],
                ),
              ),
              // Chevron
              Icon(
                Icons.chevron_right_rounded,
                color: ColorResources.muted.withValues(alpha: 0.4),
                size: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTypeIcon() {
    final config = _typeConfig(conversation.type);
    return Container(
      width: 44,
      height: 44,
      decoration: BoxDecoration(
        color: config.color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(Dimensions.radiusMedium),
      ),
      child: Icon(config.icon, color: config.color, size: 22),
    );
  }

  _TypeConfig _typeConfig(String type) {
    switch (type) {
      case 'daily_fortune':
        return _TypeConfig(Icons.wb_sunny_rounded, const Color(0xFFFFB13B));
      case 'love':
        return _TypeConfig(Icons.favorite_rounded, ColorResources.pink);
      case 'career':
        return _TypeConfig(Icons.work_rounded, ColorResources.teal);
      case 'decision':
        return _TypeConfig(Icons.balance_rounded, ColorResources.primary);
      case 'relationship':
        return _TypeConfig(Icons.people_rounded, const Color(0xFF5B8DEF));
      case 'mood':
        return _TypeConfig(Icons.mood_rounded, ColorResources.amber);
      default:
        return _TypeConfig(Icons.auto_awesome_rounded, ColorResources.primary);
    }
  }

  String _typeLabel(String type) {
    switch (type) {
      case 'daily_fortune':
        return 'Daily Fortune';
      case 'love':
        return 'Love Reading';
      case 'career':
        return 'Career Guidance';
      case 'decision':
        return 'Decision Help';
      case 'relationship':
        return 'Relationship';
      case 'mood':
        return 'Mood Check';
      default:
        return 'Tarot Reading';
    }
  }

  String _formatDate(DateTime? date) {
    if (date == null) return '';
    final now = DateTime.now();
    final diff = now.difference(date);

    if (diff.inMinutes < 1) return 'Just now';
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    if (diff.inDays < 7) return '${diff.inDays}d ago';
    return '${date.month}/${date.day}/${date.year}';
  }
}

class _TypeConfig {
  final IconData icon;
  final Color color;
  const _TypeConfig(this.icon, this.color);
}
