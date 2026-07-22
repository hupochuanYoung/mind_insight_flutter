import 'package:flutter/material.dart';
import 'package:mind_insight/src/core/component/components.dart';

class QuickReadingGrid extends StatelessWidget {
  const QuickReadingGrid({super.key});

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      childAspectRatio: 1.55,
      children: const [
        AppOptionTile(
          title: 'Love',
          subtitle: 'Heart check',
          icon: Icons.favorite_border_rounded,
          color: AppColors.pink,
        ),
        AppOptionTile(
          title: 'Career',
          subtitle: 'Next move',
          icon: Icons.work_outline_rounded,
          color: AppColors.teal,
        ),
        AppOptionTile(
          title: 'Energy',
          subtitle: 'Today\'s mood',
          icon: Icons.bolt_rounded,
          color: AppColors.amber,
        ),
        AppOptionTile(
          title: 'Shadow',
          subtitle: 'Hidden lesson',
          icon: Icons.visibility_outlined,
          color: AppColors.primary,
        ),
      ],
    );
  }
}
