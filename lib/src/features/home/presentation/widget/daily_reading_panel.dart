import 'package:flutter/material.dart';
import 'package:mind_insight/src/core/component/components.dart';

class DailyReadingPanel extends StatelessWidget {
  const DailyReadingPanel({super.key});

  static const List<String> _cards = TarotAssets.sampleSpread;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(18, 18, 18, 20),
      decoration: BoxDecoration(
        color: AppColors.ink,
        borderRadius: BorderRadius.circular(8),
        boxShadow: const [
          BoxShadow(
            color: Color(0x1F211D33),
            blurRadius: 24,
            offset: Offset(0, 14),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const AppIconBadge(
                icon: Icons.auto_awesome_rounded,
                size: 34,
                iconSize: 19,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  'Today\'s spread',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 0,
                  ),
                ),
              ),
              const _MoonBadge(),
            ],
          ),
          const SizedBox(height: 18),
          TarotCardStack(assetPaths: _cards),
          const SizedBox(height: 18),
          Text(
            'A quiet check-in for what to notice, what to release, and where your energy wants to move next.',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: const Color(0xFFE8E1FF),
              height: 1.45,
              letterSpacing: 0,
            ),
          ),
          const SizedBox(height: 18),
          AppActionButton(
            label: 'Draw my cards',
            icon: Icons.style_rounded,
            onPressed: () {},
          ),
        ],
      ),
    );
  }
}

class _MoonBadge extends StatelessWidget {
  const _MoonBadge();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: const Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.nights_stay_rounded, color: AppColors.gold, size: 15),
          SizedBox(width: 5),
          Text(
            'Moon',
            style: TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}
