import 'package:flutter/material.dart';
import 'package:mind_insight/src/core/component/components.dart';
import 'package:mind_insight/src/features/home/presentation/widget/daily_reading_panel.dart';
import 'package:mind_insight/src/features/home/presentation/widget/home_header.dart';
import 'package:mind_insight/src/features/home/presentation/widget/insight_card.dart';
import 'package:mind_insight/src/features/home/presentation/widget/quick_reading_grid.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  static const Color primaryColor = AppColors.primary;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 28),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const HomeHeader(),
            const SizedBox(height: 24),
            const DailyReadingPanel(),
            const SizedBox(height: 26),
            const AppSectionTitle(title: 'Start a reading'),
            const SizedBox(height: 12),
            const QuickReadingGrid(),
            const SizedBox(height: 26),
            const InsightCard(),
            const SizedBox(height: 26),
            const AppSectionTitle(title: 'Recent insights'),
            const SizedBox(height: 12),
            AppReadingTile(
              title: 'Relationship clarity',
              subtitle: 'Six of Cups, The Hermit, King of Wands',
              assetPath: TarotAssets.card(6),
            ),
            const SizedBox(height: 10),
            AppReadingTile(
              title: 'Career momentum',
              subtitle: 'Two of Wands, Nine of Cups, The Star',
              assetPath: TarotAssets.card(17),
            ),
          ],
        ),
      ),
    );
  }
}
