import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mind_insight/src/core/constant/app_color_resources.dart';
import 'package:mind_insight/src/core/constant/app_dimensions.dart';
import 'package:mind_insight/src/core/constant/app_text_styles.dart';
import 'package:mind_insight/src/core/route/app_router.dart';
import 'package:mind_insight/src/features/home/presentation/widget/home_header.dart';

/// Redesigned home page with 6 entry points for different user intents.
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const HomeHeader(),
            const SizedBox(height: 28),
            // Intro hint
            Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: Text(
                '此刻你想做什么？',
                style: textExtraLarge.copyWith(
                  color: ColorResources.ink,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
            // 6-entry grid
            _buildEntryGrid(context),
          ],
        ),
      ),
    );
  }

  Widget _buildEntryGrid(BuildContext context) {
    final entries = _homeEntries;
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: entries.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 14,
        crossAxisSpacing: 14,
        childAspectRatio: 1.05,
      ),
      itemBuilder: (context, index) {
        final entry = entries[index];
        return _EntryCard(
          entry: entry,
          onTap: () => _navigateToEntry(context, entry),
        );
      },
    );
  }

  void _navigateToEntry(BuildContext context, _HomeEntry entry) {
    context.push('${RouteUri.chatSession}?type=${entry.type}');
  }
}

// =============================================================================
// Entry data model
// =============================================================================

class _HomeEntry {
  const _HomeEntry({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
    required this.type,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
  final String type;
}

final List<_HomeEntry> _homeEntries = [
  const _HomeEntry(
    title: '今日运势',
    subtitle: '看看今天的能量和提醒',
    icon: Icons.wb_sunny_rounded,
    color: Color(0xFFFFB13B),
    type: 'daily_fortune',
  ),
  const _HomeEntry(
    title: '最近烦恼',
    subtitle: '说说让你放不下的事',
    icon: Icons.cloud_outlined,
    color: Color(0xFF7C6FCB),
    type: 'worry',
  ),
  const _HomeEntry(
    title: '关系问题',
    subtitle: '看看一段关系里的真实感受',
    icon: Icons.favorite_outline_rounded,
    color: Color(0xFFE86F9D),
    type: 'relationship',
  ),
  const _HomeEntry(
    title: '事业学业',
    subtitle: '整理最近的压力和方向',
    icon: Icons.trending_up_rounded,
    color: Color(0xFF2F9C95),
    type: 'career',
  ),
  const _HomeEntry(
    title: '选择困难',
    subtitle: '在两个选择之间看清自己',
    icon: Icons.swap_horiz_rounded,
    color: Color(0xFF5B8DEF),
    type: 'choice',
  ),
  const _HomeEntry(
    title: '只想聊聊',
    subtitle: '不抽牌，只是陪你说说',
    icon: Icons.chat_bubble_outline_rounded,
    color: Color(0xFF9B8EC4),
    type: 'just_talk',
  ),
];

// =============================================================================
// Entry card widget
// =============================================================================

class _EntryCard extends StatelessWidget {
  const _EntryCard({required this.entry, required this.onTap});

  final _HomeEntry entry;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: ColorResources.card,
      borderRadius: BorderRadius.circular(Dimensions.radiusMedium),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(Dimensions.radiusMedium),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(Dimensions.radiusMedium),
            border: Border.all(color: ColorResources.border),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Icon with tinted background
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: entry.color.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                ),
                child: Icon(entry.icon, color: entry.color, size: 22),
              ),
              // Title + subtitle
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    entry.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: textBoldLarge.copyWith(color: ColorResources.ink),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    entry.subtitle,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: textSmall.copyWith(
                      color: ColorResources.muted,
                      height: 1.3,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
