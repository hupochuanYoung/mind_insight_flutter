import 'package:flutter/material.dart';
import 'package:mind_insight/src/core/constant/app_color_resources.dart';
import 'package:mind_insight/src/core/constant/app_dimensions.dart';
import 'package:mind_insight/src/core/constant/app_text_styles.dart';

import 'genui_registry.dart';

/// Shows revealed tarot cards after user selected them.
///
/// Used for `ui_view: card_reveal` or after reveal API returns cards.
/// Displays each card with its name, orientation (正位/逆位), and position.
class CardRevealWidget extends StatelessWidget {
  const CardRevealWidget({
    super.key,
    required this.data,
    required this.onAction,
  });

  /// Expected keys:
  /// - `cards`: list of maps with `position`, `name`, `orientation`
  /// - `message`: String — summary message from agent
  /// - `actions`: list of action objects
  final Map<String, dynamic> data;
  final GenUiActionCallback onAction;

  @override
  Widget build(BuildContext context) {
    final innerData = data['data'] as Map<String, dynamic>? ?? {};
    final cards =
        (innerData['cards'] as List<dynamic>?)
            ?.map((e) => e as Map<String, dynamic>)
            .toList() ??
        [];
    final message = data['message'] as String? ?? '';
    final actions = GenUiRegistry.actionList(data);

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF8EF),
        borderRadius: BorderRadius.circular(Dimensions.radiusMedium),
        border: Border.all(color: ColorResources.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              const Icon(
                Icons.visibility_rounded,
                size: 20,
                color: ColorResources.primary,
              ),
              const SizedBox(width: 8),
              Text(
                '翻牌结果',
                style: textBoldLarge.copyWith(color: ColorResources.ink),
              ),
            ],
          ),
          const SizedBox(height: 14),
          // Card list
          ...cards.map((card) => _buildCardTile(context, card)),
          // Message
          if (message.isNotEmpty) ...[
            const SizedBox(height: 14),
            Text(
              message,
              style: textRegular.copyWith(
                color: ColorResources.ink,
                height: 1.5,
              ),
            ),
          ],
          // Action buttons
          if (actions.isNotEmpty) ...[
            const SizedBox(height: 16),
            _buildActions(actions),
          ],
        ],
      ),
    );
  }

  Widget _buildCardTile(BuildContext context, Map<String, dynamic> card) {
    final name = card['name'] as String? ?? '';
    final orientation = card['orientation'] as String? ?? 'upright';
    final position = card['position'] as String? ?? '';
    final isReversed = orientation == 'reversed';

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: ColorResources.border),
      ),
      child: Row(
        children: [
          // Card icon
          Container(
            width: 44,
            height: 64,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(6),
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFF7C6FCB), Color(0xFF4A3F8A)],
              ),
            ),
            child: Center(
              child: isReversed
                  ? Transform.rotate(
                      angle: 3.14159,
                      child: const Icon(
                        Icons.auto_awesome,
                        color: Colors.white70,
                        size: 18,
                      ),
                    )
                  : const Icon(
                      Icons.auto_awesome,
                      color: Colors.white70,
                      size: 18,
                    ),
            ),
          ),
          const SizedBox(width: 12),
          // Card info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: textBoldLarge.copyWith(color: ColorResources.ink),
                ),
                const SizedBox(height: 3),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: isReversed
                            ? ColorResources.pink.withValues(alpha: 0.12)
                            : ColorResources.teal.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        isReversed ? '逆位' : '正位',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: isReversed
                              ? ColorResources.pink
                              : ColorResources.teal,
                        ),
                      ),
                    ),
                    if (position.isNotEmpty) ...[
                      const SizedBox(width: 8),
                      Text(
                        position,
                        style: textSmall.copyWith(color: ColorResources.muted),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActions(List<Map<String, dynamic>> actions) {
    return Wrap(
      spacing: 10,
      children: actions.map((action) {
        final actionType = action['type'] as String? ?? '';
        final label = (action['label'] as String?) ?? _actionLabel(actionType);
        final isPrimary =
            actionType == 'reveal_cards' || actionType == 'continue_chat';
        return ElevatedButton(
          onPressed: () => onAction(action, data),
          style: ElevatedButton.styleFrom(
            backgroundColor: isPrimary ? ColorResources.primary : Colors.white,
            foregroundColor: isPrimary ? Colors.white : ColorResources.primary,
            elevation: 0,
            side: isPrimary
                ? null
                : const BorderSide(color: ColorResources.primary),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          ),
          child: Text(
            label,
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
        );
      }).toList(),
    );
  }

  String _actionLabel(String action) {
    return switch (action) {
      'start_draw' => '开始抽牌',
      'reveal_cards' => '翻牌',
      'continue_chat' => '继续聊聊',
      'end_draw' => '结束',
      _ => action,
    };
  }
}
