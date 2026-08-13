import 'package:flutter/material.dart';
import 'package:mind_insight/src/core/constant/app_color_resources.dart';
import 'package:mind_insight/src/core/constant/app_dimensions.dart';
import 'package:mind_insight/src/core/constant/app_text_styles.dart';

import 'genui_registry.dart';

/// Renders the draw invitation UI when agent returns `ui_view: draw_invitation`.
///
/// Shows the agent's guidance message, spread info, and a "start draw" button.
class DrawInvitationWidget extends StatelessWidget {
  const DrawInvitationWidget({
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
    final spread =
        innerData['recommended_spread'] as Map<String, dynamic>? ?? {};
    final spreadName = spread['name'] as String? ?? '塔罗牌';
    final requiredCards = spread['required_cards'] as int? ?? 1;
    final positions = (spread['positions'] as List<dynamic>?)
            ?.map((e) => e.toString())
            .toList() ??
        [];
    final actions = (data['actions'] as List<dynamic>?)
            ?.map((e) => e.toString())
            .toList() ??
        [];

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
          // Icon + title row
          Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: ColorResources.primary.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.auto_awesome_rounded,
                  size: 18,
                  color: ColorResources.primary,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      spreadName,
                      style: textBoldLarge.copyWith(color: ColorResources.ink),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '需要抽 $requiredCards 张牌',
                      style: textSmall.copyWith(color: ColorResources.muted),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          // Guidance message
          Text(
            message,
            style: textRegular.copyWith(
              color: ColorResources.ink,
              height: 1.5,
            ),
          ),
          // Position labels
          if (positions.isNotEmpty) ...[
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 6,
              children: positions.map((pos) {
                return Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: ColorResources.primarySoft,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    pos,
                    style: textSmall.copyWith(color: ColorResources.primary),
                  ),
                );
              }).toList(),
            ),
          ],
          // Action button
          if (actions.contains('start_draw')) ...[
            const SizedBox(height: 18),
            SizedBox(
              width: double.infinity,
              height: 44,
              child: ElevatedButton(
                onPressed: () => onAction('start_draw', data),
                style: ElevatedButton.styleFrom(
                  backgroundColor: ColorResources.primary,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(Dimensions.radiusMedium),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.style_rounded, size: 18),
                    const SizedBox(width: 8),
                    Text('开始抽牌',
                        style: textBoldLarge.copyWith(color: Colors.white)),
                  ],
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
