import 'package:flutter/material.dart';
import 'package:mind_insight/src/core/constant/app_color_resources.dart';
import 'package:mind_insight/src/core/constant/app_dimensions.dart';
import 'package:mind_insight/src/core/constant/app_text_styles.dart';

import 'genui_registry.dart';

/// Full interpretation display for `ui_view: interpretation`.
///
/// Shows detailed card readings, guidance, energy, and actionable advice.
class InterpretationWidget extends StatelessWidget {
  const InterpretationWidget({
    super.key,
    required this.data,
    required this.onAction,
  });

  final Map<String, dynamic> data;
  final GenUiActionCallback onAction;

  @override
  Widget build(BuildContext context) {
    final message = data['message'] as String? ?? '';
    final innerData = data['data'] as Map<String, dynamic>? ?? {};
    final interpretation =
        innerData['interpretation'] as Map<String, dynamic>? ?? {};
    final cards =
        (innerData['cards'] as List<dynamic>?)
            ?.map((e) => e as Map<String, dynamic>)
            .toList() ??
        [];
    final actions = GenUiRegistry.actionList(data);

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(Dimensions.radiusMedium),
        border: Border.all(color: ColorResources.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          _buildHeader(),
          const SizedBox(height: 14),
          // Cards summary row
          if (cards.isNotEmpty) ...[
            _buildCardsRow(cards),
            const SizedBox(height: 16),
          ],
          // Summary message
          if (message.isNotEmpty)
            _buildSection(null, message, isHighlight: true),
          // Interpretation sections
          if (interpretation.isNotEmpty) ...[
            if (interpretation['summary'] != null)
              _buildSection('解读总结', _asText(interpretation['summary'])),
            if (interpretation['card_meaning'] != null)
              _buildSection('牌义', _asText(interpretation['card_meaning'])),
            if (interpretation['orientation_meaning'] != null)
              _buildSection(
                '正逆位含义',
                _asText(interpretation['orientation_meaning']),
              ),
            if (interpretation['position_meaning'] != null)
              _buildSection(
                '牌位含义',
                _asText(interpretation['position_meaning']),
              ),
            if (interpretation['guidance'] != null)
              _buildSection('指引', _asText(interpretation['guidance'])),
            if (interpretation['action_suggestion'] != null)
              _buildSection(
                '行动建议',
                _asText(interpretation['action_suggestion']),
              ),
            if (interpretation['today_energy'] != null)
              _buildEnergySection(interpretation),
            if (interpretation['affirmation'] != null)
              _buildAffirmation(_asText(interpretation['affirmation'])),
          ],
          // Actions
          if (actions.isNotEmpty) ...[
            const SizedBox(height: 18),
            _buildActions(actions),
          ],
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: ColorResources.gold.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Icon(
            Icons.auto_stories_rounded,
            size: 18,
            color: ColorResources.gold,
          ),
        ),
        const SizedBox(width: 12),
        Text('塔罗解读', style: textExtraLarge.copyWith(color: ColorResources.ink)),
      ],
    );
  }

  Widget _buildCardsRow(List<Map<String, dynamic>> cards) {
    return Wrap(
      spacing: 8,
      runSpacing: 6,
      children: cards.map((card) {
        final name = card['name'] as String? ?? '';
        final orientation = card['orientation'] as String? ?? 'upright';
        final isReversed = orientation == 'reversed';
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: BoxDecoration(
            color: ColorResources.primarySoft,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.auto_awesome,
                size: 14,
                color: isReversed
                    ? ColorResources.pink
                    : ColorResources.primary,
              ),
              const SizedBox(width: 6),
              Text(
                '$name ${isReversed ? '逆位' : '正位'}',
                style: textSmall.copyWith(
                  color: ColorResources.ink,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildSection(
    String? title,
    String content, {
    bool isHighlight = false,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (title != null) ...[
            Text(
              title,
              style: textBoldSmall.copyWith(
                color: ColorResources.muted,
                letterSpacing: 0.5,
              ),
            ),
            const SizedBox(height: 6),
          ],
          Container(
            width: double.infinity,
            padding: isHighlight ? const EdgeInsets.all(12) : EdgeInsets.zero,
            decoration: isHighlight
                ? BoxDecoration(
                    color: const Color(0xFFFFF8EF),
                    borderRadius: BorderRadius.circular(8),
                  )
                : null,
            child: Text(
              content,
              style: textRegular.copyWith(
                color: ColorResources.ink,
                height: 1.6,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEnergySection(Map<String, dynamic> interpretation) {
    final energy = interpretation['today_energy'] != null
        ? _asText(interpretation['today_energy'])
        : null;
    final avoid = interpretation['avoid'] != null
        ? _asText(interpretation['avoid'])
        : null;

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: ColorResources.teal.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: ColorResources.teal.withValues(alpha: 0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (energy != null) ...[
            Row(
              children: [
                const Icon(
                  Icons.bolt_rounded,
                  size: 16,
                  color: ColorResources.teal,
                ),
                const SizedBox(width: 6),
                Text(
                  '今日能量',
                  style: textBoldSmall.copyWith(color: ColorResources.teal),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Text(
              energy,
              style: textRegular.copyWith(
                color: ColorResources.ink,
                height: 1.5,
              ),
            ),
          ],
          if (avoid != null) ...[
            const SizedBox(height: 10),
            Row(
              children: [
                const Icon(
                  Icons.warning_amber_rounded,
                  size: 16,
                  color: ColorResources.amber,
                ),
                const SizedBox(width: 6),
                Text(
                  '注意',
                  style: textBoldSmall.copyWith(color: ColorResources.amber),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Text(
              avoid,
              style: textRegular.copyWith(
                color: ColorResources.ink,
                height: 1.5,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildAffirmation(String affirmation) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: ColorResources.primary.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: ColorResources.primary.withValues(alpha: 0.15),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.format_quote_rounded,
            size: 20,
            color: ColorResources.primary,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              affirmation,
              style: textMedium.copyWith(
                color: ColorResources.primary,
                fontStyle: FontStyle.italic,
                height: 1.5,
              ),
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
        final isPrimary = actionType == 'continue_chat';
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
      'continue_chat' => '继续聊聊',
      'end_draw' => '结束本次',
      _ => action,
    };
  }

  /// Converts a value to displayable text.
  /// Handles String, Map (joins values), and List (joins items).
  String _asText(dynamic value) {
    if (value is String) return value;
    if (value is Map) {
      return value.entries.map((e) => '${e.key}：${e.value}').join('\n\n');
    }
    if (value is List) {
      return value.map((e) => e.toString()).join('\n');
    }
    return value.toString();
  }
}
